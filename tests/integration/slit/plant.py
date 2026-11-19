"""Coupled stepper/EL5042 plant with independent fault injection per blade."""
from dataclasses import dataclass
import math
import random
import threading
import time

import el7041
from .instrumentation import IndexEncoders, ProbeAxis


class PlantThread(threading.Thread):
    """Keep plant traffic on a CA connection separate from test commands."""
    def run(self):
        from epics import ca
        # CAThread attaches the caller's initial context. A new context gives
        # this client its own IOC circuit, so motor processing on the test
        # connection cannot hold up plant requests on that same circuit.
        ca.create_context()
        try:
            super().run()
        finally:
            # disconnect() removes PV callbacks, but PyEpics 3.5.x retains the
            # underlying channels in its process-wide chid cache. Clear them
            # while their context is alive; otherwise atexit may clear invalid
            # handles after context destruction and crash inside libca.
            context = ca.current_context()
            for entry in list(ca._cache.get(context, {}).values()):
                if entry.chid is not None:
                    ca.clear_channel(entry.chid)
            ca.flush_io()
            ca.destroy_context()


@dataclass
class Faults:
    ready: bool = True
    frozen: bool = False
    acknowledge_enable: bool = True
    forward_ok: bool = True
    backward_ok: bool = True
    drive_fault: bool = False
    encoder_error: bool = False  # EL5042 status bit 1.
    encoder_warning: bool = False  # EL5042 status bit 0.
    encoder_noise_mm: float = 0.0  # Peak amplitude of uniform measurement noise.
    encoder_bias_mm: float = 0.0  # Deterministic measurement disturbance.


@dataclass(frozen=True)
class HomingInputs:
    """Position-based sensors in the unchanged physical coordinate system."""
    low_mm: float = -.4
    high_mm: float = .4
    cam_low_mm: float = -.08
    cam_high_mm: float = .08
    cam_enabled: bool = True
    travel_bound_mm: float = .8

    def __post_init__(self):
        coordinates = (self.low_mm, self.cam_low_mm, self.cam_high_mm, self.high_mm)
        if not all(math.isfinite(v) for v in coordinates + (self.travel_bound_mm,)):
            raise ValueError('homing sensor coordinates must be finite')
        if not self.low_mm < self.cam_low_mm < self.cam_high_mm < self.high_mm:
            raise ValueError('homing cam must lie strictly between end switches')
        if self.travel_bound_mm <= max(abs(self.low_mm), abs(self.high_mm)):
            raise ValueError('homing travel bound must extend beyond end switches')


class Blade:
    def __init__(self, config, position_mm=0):
        self.config = config
        self.model = el7041.Model(el7041.Settings(), position_mm * config['internal_counts_per_mm'])
        self.faults = Faults()
        self.backlash_mm = 0.0
        self.mechanical_mm = position_mm
        self.backlash_peak_gap = 0.0
        self.held_mm = position_mm
        self.homing_inputs = None
        self.encoder_mm = position_mm
        self.encoder_noise_mm = 0.0
        self.encoder_power_polarity = None
        self.encoder_power_delay = 0.0
        self.encoder_power_off_raw = 0
        self.encoder_supply_seconds = 0.0
        self.encoder_powered = True
        self.encoder_raw = None
        self.encoder_ready = True
        self.random = random.Random(config.get("noise_seed", config["drive_slave"]))

    @property
    def position_mm(self):
        return self.mechanical_mm if self.backlash_mm else self.drive_position_mm

    @property
    def drive_position_mm(self):
        return self.model.position_counts / self.config['internal_counts_per_mm']

    def configure_backlash(self, width):
        if isinstance(width, bool) or not math.isfinite(width) or width < 0:
            raise ValueError('backlash must be finite and nonnegative')
        self.mechanical_mm = self.drive_position_mm
        self.backlash_mm = float(width)
        self.backlash_peak_gap = 0.0

    def inject(self, **values):
        for name, value in values.items():
            if name not in Faults.__dataclass_fields__:
                raise ValueError('unknown fault ' + name)
            if name in ('encoder_noise_mm', 'encoder_bias_mm'):
                if isinstance(value, bool) or not isinstance(value, (int, float)) or not math.isfinite(value) or (name == 'encoder_noise_mm' and value < 0):
                    raise ValueError(name + ' must be finite, with nonnegative noise amplitude')
                setattr(self.faults, name, float(value))
                continue
            if name == 'frozen' and value and not self.faults.frozen:
                self.held_mm = self.encoder_mm
            setattr(self.faults, name, bool(value))
        if values.get('drive_fault') is False:
            self.model.fault = False

    def step(self, control, velocity, seconds, encoder_power=True):
        if self.faults.drive_fault:
            self.model.trip()
            control = el7041.word16(control) & ~3  # Fault injection persists through reset/enable requests.
        feedback = self.model.step(control, velocity, seconds)
        drive_position = self.drive_position_mm
        half_gap = self.backlash_mm/2
        self.mechanical_mm = max(drive_position-half_gap, min(drive_position+half_gap, self.mechanical_mm))
        self.backlash_peak_gap = max(self.backlash_peak_gap, abs(drive_position-self.position_mm))
        status = feedback.drive_status
        if self.homing_inputs is not None:
            sensors = self.homing_inputs
            position = self.position_mm
            if abs(position) > sensors.travel_bound_mm:
                raise RuntimeError('homing plant exceeded physical travel bound')
            if position <= sensors.low_mm: status &= ~(1 << 11)
            if position >= sensors.high_mm: status &= ~(1 << 12)
            # Dedicated fixture links status bit 13 as an active-high home cam.
            if sensors.cam_enabled and sensors.cam_low_mm <= position <= sensors.cam_high_mm:
                status |= 1 << 13
        if self.faults.drive_fault:
            status = (status | 8) & ~3
        if not self.faults.acknowledge_enable:
            status &= ~2
        if not self.faults.forward_ok:
            status &= ~(1 << 12)
        if not self.faults.backward_ok:
            status &= ~(1 << 11)
        if self.faults.frozen:
            mm = self.held_mm
        else:
            peak = self.faults.encoder_noise_mm
            mm = self.position_mm + self.faults.encoder_bias_mm + (self.random.uniform(-peak, peak) if peak else 0.0)
        self.encoder_mm = mm
        self.encoder_noise_mm = mm - self.position_mm
        raw = round((mm - self.config['absolute_offset_mm']) * self.config['absolute_counts_per_mm'])
        raw %= 1 << self.config['absolute_bits']
        self.encoder_powered = (self.encoder_power_polarity is None or
                                bool(encoder_power) == self.encoder_power_polarity)
        self.encoder_supply_seconds = (self.encoder_supply_seconds + seconds
                                       if self.encoder_powered else 0.0)
        valid_supply = self.encoder_powered and self.encoder_supply_seconds >= self.encoder_power_delay
        self.encoder_raw = raw if valid_supply else self.encoder_power_off_raw
        self.encoder_ready = valid_supply and self.faults.ready
        encoder_status = ((4 if self.encoder_ready else 0) |
                          (2 if self.faults.encoder_error else 0) |
                          (1 if self.faults.encoder_warning else 0))
        return (el7041.Feedback(status, feedback.encoder_status, feedback.position),
                self.encoder_raw, encoder_status)


class Plant:
    def __init__(self, profile, prefix, pv_factory, thread_factory, timeout=1, rate=100):
        self.profile, self.prefix, self.factory = profile, prefix, pv_factory
        self.thread_factory, self.timeout, self.period = thread_factory, timeout, 1 / rate
        self.stop = threading.Event()
        self.started = threading.Event()
        self.lock = threading.Lock()
        self.error, self.thread = None, None
        self.blades = {}
        self.probe_axis = None
        self.index_encoders = None
        self.last_elapsed, self.max_elapsed, self.last_commands = 0.0, 0.0, {}
        self.last_published = None
        self.io_phase = 'initializing'
        self.io_seconds, self.io_max_seconds = {}, {}
        self.failure_details = None

    def snapshot(self):
        with self.lock:
            return {'last_step_seconds': self.last_elapsed, 'max_step_seconds': self.max_elapsed,
                    'seconds_since_publish': time.monotonic() - self.last_published if self.last_published else None,
                    'error': str(self.error) if self.error else None,
                    'io_phase': self.io_phase, 'io_seconds': dict(self.io_seconds),
                    'io_max_seconds': dict(self.io_max_seconds), 'failure': self.failure_details,
                    'probe_axis': self.probe_axis.snapshot() if self.probe_axis else None,
                    'index_encoders': self.index_encoders.snapshot() if self.index_encoders else None,
                    'blades': {axis: {'position_mm': blade.position_mm,
                                     'drive_position_mm': blade.drive_position_mm,
                                     'backlash_mm': blade.backlash_mm,
                                     'backlash_peak_gap_mm': blade.backlash_peak_gap,
                                     'homing_inputs': vars(blade.homing_inputs) if blade.homing_inputs else None,
                                     'encoder_mm': blade.encoder_mm,
                                     'encoder_noise_peak_mm': blade.faults.encoder_noise_mm,
                                     'encoder_measurement_error_mm': blade.encoder_noise_mm,
                                     'encoder_frozen': blade.faults.frozen,
                                     'encoder_ready': blade.encoder_ready,
                                     'encoder_error': blade.faults.encoder_error,
                                     'encoder_warning': blade.faults.encoder_warning,
                                     'encoder_powered': blade.encoder_powered,
                                     'encoder_raw': blade.encoder_raw,
                                     'encoder_power_off_raw': blade.encoder_power_off_raw,
                                     'encoder_supply_seconds': blade.encoder_supply_seconds,
                                     'encoder_power_delay_seconds': blade.encoder_power_delay,
                                     'encoder_bias_mm': blade.faults.encoder_bias_mm,
                                     'drive_fault': blade.faults.drive_fault,
                                     'acknowledge_enable': blade.faults.acknowledge_enable,
                                     **self.last_commands.get(axis, {})}
                               for axis, blade in self.blades.items()}}

    def inject(self, axis, **values):
        with self.lock:
            self.blades[axis].inject(**values)

    def configure_probe(self, position=None, direction=1):
        with self.lock:
            if self.probe_axis is None:
                raise RuntimeError('fixture has no DS402 probe axis')
            self.probe_axis.configure(position, direction)

    def probe_snapshot(self):
        with self.lock:
            return self.probe_axis.snapshot()

    def configure_encoder_power(self, axis, active_high=None, startup_delay=0.0, off_raw=0):
        if active_high is not None and not isinstance(active_high, bool):
            raise ValueError('encoder relay polarity must be boolean or None')
        if not math.isfinite(startup_delay) or startup_delay < 0:
            raise ValueError('encoder startup delay must be finite and nonnegative')
        if isinstance(off_raw, bool) or not isinstance(off_raw, int) or not 0 <= off_raw < 2**63:
            raise ValueError('off-state raw word must fit the nonnegative EL5042 int64 output')
        with self.lock:
            blade = self.blades[axis]
            blade.encoder_power_off_raw = off_raw
            blade.encoder_power_polarity = active_high
            blade.encoder_power_delay = startup_delay
            blade.encoder_supply_seconds = 0.0

    def configure_backlash(self, axis, width=0):
        with self.lock: self.blades[axis].configure_backlash(width)

    def backlash_state(self, axis):
        with self.lock:
            blade = self.blades[axis]
            return {'width_mm': blade.backlash_mm, 'drive_mm': blade.drive_position_mm,
                    'mechanical_mm': blade.position_mm, 'peak_gap_mm': blade.backlash_peak_gap}

    def configure_homing(self, axis, inputs=None):
        if inputs is not None and not isinstance(inputs, HomingInputs):
            raise ValueError('homing inputs must be HomingInputs or None')
        with self.lock:
            self.blades[axis].homing_inputs = inputs

    def physical_position(self, axis):
        with self.lock:
            return self.blades[axis].position_mm

    def clear_faults(self):
        with self.lock:
            for blade in self.blades.values():
                blade.faults = Faults()
                blade.homing_inputs = None
                blade.model.fault = False

    def io_call(self, phase, operation, *args, **kwargs):
        with self.lock: self.io_phase = phase
        started = time.monotonic()
        try:
            return operation(*args, **kwargs)
        finally:
            duration = time.monotonic() - started
            with self.lock:
                self.io_seconds[phase] = duration
                self.io_max_seconds[phase] = max(self.io_max_seconds.get(phase, 0), duration)

    def check(self):
        if self.error is not None:
            raise RuntimeError('plant stopped: ' + str(self.error))

    def start(self):
        self.thread = self.thread_factory(target=self.run, name='slit-test-plant')
        self.thread.start()
        if not self.started.wait(self.timeout * 30):
            self.close()
            raise RuntimeError('plant initialization timed out')
        self.check()

    def run(self):
        ios, encoders, power_pvs, owned = {}, {}, {}, []
        try:
            for axis, config in self.profile['physical'].items():
                io = el7041.EpicsIO(self.prefix, 0, config['drive_slave'], '01', self.timeout, self.factory)
                ios[axis] = io
                io.connect()
                base = f'{self.prefix}ec0:s{config["encoder_slave"]}:'
                channel = config['encoder_channel']
                fields = {}
                for key, field, record in (('position', 'positionActual', 'int64out'),
                                           ('status', 'encoderStatus', 'mbboDirect'),
                                           ('initial', 'positionActual', 'int64in')):
                    name = base + field + channel + ('-RB' if key == 'initial' else '')
                    pv = self.factory(name, auto_monitor=False)
                    kind = self.factory(name + '.RTYP', auto_monitor=False)
                    owned.extend((pv, kind))
                    if not pv.wait_for_connection(timeout=self.timeout) or not kind.wait_for_connection(timeout=self.timeout):
                        raise RuntimeError('cannot connect to ' + name)
                    if kind.get(as_string=True, use_monitor=False, timeout=self.timeout) != record:
                        raise RuntimeError(name + ': expected ' + record)
                    if not (pv.read_access if key == 'initial' else pv.write_access):
                        raise RuntimeError('missing access: ' + name)
                    fields[key] = pv
                raw = fields['initial'].get(use_monitor=False, timeout=self.timeout)
                if raw is None or not math.isfinite(raw):
                    raise RuntimeError('cannot read initial absolute encoder')
                mm = (int(raw) & ((1 << config['absolute_bits']) - 1)) / config['absolute_counts_per_mm'] + config['absolute_offset_mm']
                # Counter images must agree before moving: never silently reset the IOC.
                expected = round(mm * config['internal_counts_per_mm']) % 65536
                actual = io.initial_position()
                if abs((actual - expected + 32768) % 65536 - 32768) > 8:
                    raise RuntimeError(axis + ': internal/absolute encoder images disagree; restart dedicated test IOC')
                self.blades[axis] = Blade(config, mm)
                encoders[axis] = fields
                power = config.get('encoder_power')
                if power:
                    name = self.prefix + f'ec0:s{power["slave"]}:binaryOutput{power["channel"]}'
                    pv = self.factory(name, auto_monitor=False)
                    owned.append(pv)
                    if not pv.wait_for_connection(timeout=self.timeout) or not pv.read_access:
                        raise RuntimeError('cannot read encoder relay: ' + name)
                    power_pvs[axis] = pv
            if 'probe_axis' in self.profile:
                self.probe_axis = ProbeAxis(self.profile['probe_axis'], self.prefix,
                                            self.factory, self.timeout)
            if 'index_encoders' in self.profile:
                self.index_encoders = IndexEncoders(self.profile['index_encoders'], self.prefix,
                                                    self.factory, self.timeout)
            previous = time.monotonic()
            self.started.set()
            while not self.stop.is_set():
                commands = {axis: self.io_call(axis + ' command read', io.read) for axis, io in ios.items()}
                probe_commands = self.probe_axis.read() if self.probe_axis else None
                index_commands = self.index_encoders.read() if self.index_encoders else None
                powers = {axis: self.io_call(axis + ' encoder relay read', pv.get,
                                             use_monitor=False, timeout=self.timeout)
                          for axis, pv in power_pvs.items()}
                if any(value is None or value not in (0, 1) for value in powers.values()):
                    raise RuntimeError('invalid encoder relay output readback')
                now = time.monotonic()
                elapsed = now - previous
                with self.lock:
                    self.last_elapsed = elapsed
                    self.max_elapsed = max(self.max_elapsed, elapsed)
                    self.last_commands = {axis: {'control': int(command[0]), 'velocity': int(command[1])}
                                          for axis, command in commands.items()}
                if elapsed > max(.25, self.period * 5):
                    slowest = max(self.io_seconds, key=self.io_seconds.get)
                    raise RuntimeError(f'plant loop stalled for {elapsed:.3f}s; slowest latest I/O: '
                                       f'{slowest} ({self.io_seconds[slowest]:.3f}s)')
                with self.lock:
                    feedback = {axis: self.blades[axis].step(*command, elapsed, encoder_power=powers.get(axis, True)) for axis, command in commands.items()}
                    probe_feedback = (self.probe_axis.step(probe_commands, elapsed)
                                      if self.probe_axis else None)
                    index_feedback = (self.index_encoders.step(
                        index_commands,
                        self.blades[self.profile['index_encoders']['axis']].position_mm)
                        if self.index_encoders else None)
                if self.probe_axis:
                    self.io_call('DS402 probe feedback', self.probe_axis.publish, probe_feedback)
                if self.index_encoders:
                    self.io_call('index encoder feedback', self.index_encoders.publish, index_feedback)
                for axis, (drive, position, status) in feedback.items():
                    for key, value in (('position', position), ('status', status)):
                        pv = encoders[axis][key]
                        if not pv.connected or self.io_call(axis + ' absolute ' + key + ' write', pv.put,
                                                           value, wait=True, timeout=self.timeout) != 1:
                            raise RuntimeError('encoder write failed: ' + pv.pvname)
                    self.io_call(axis + ' drive feedback write', ios[axis].publish, drive)
                with self.lock:
                    self.last_published = time.monotonic()
                previous = now
                self.stop.wait(max(0, self.period - (time.monotonic() - now)))
        except Exception as error:
            self.error = error
            # Capture timing before withdrawal deliberately trips both drives.
            with self.lock:
                self.failure_details = {'reason': str(error), 'io_phase': self.io_phase,
                                        'step_seconds': self.last_elapsed,
                                        'io_seconds': dict(self.io_seconds),
                                        'seconds_since_publish': (time.monotonic()-self.last_published
                                                                  if self.last_published is not None else None)}
        finally:
            self.started.set()
            if self.probe_axis:
                self.probe_axis.close()
            if self.index_encoders:
                self.index_encoders.close()
            for axis, io in ios.items():
                blade = self.blades.get(axis)
                if blade:
                    blade.model.trip()
                    io.withdraw(blade.model.feedback())
                io.close()
            for pv in owned:
                pv.disconnect()

    def close(self):
        self.stop.set()
        if self.thread is not None:
            self.thread.join()
