"""Independent DS402 axis and a position-triggered probe input for the SIM IOC."""
import math
import time
import ds402
import touch_probe


class IndexEncoders:
    """Blade-coupled EL5102 latch and EL7062 touch-probe index inputs."""
    def __init__(self, config, prefix, factory, timeout):
        self.config, self.timeout, self.pvs, self.owned = config, timeout, {}, []
        self.probe = touch_probe.Model()
        self.el5102_armed = self.el5102_stored = False
        self.el5102_latch = 0
        self.el5102_capture = self.el7062_capture = None
        self.previous_counts = None
        try:
            old = config['el5102']
            new = config['el7062']
            definitions = {
                'old_control': (old, 'encoderControl', 'mbbiDirect', True),
                'old_position': (old, 'positionActual', 'mbboDirect', False),
                'old_status': (old, 'encoderStatus', 'mbboDirect', False),
                # The generated SIM record retains the historical PDO typo;
                # ECMC configuration links through encoderLatchPosition alias.
                'old_latch': (old, 'encoderLatchPostion', 'mbboDirect', False),
                'new_control': (new, 'touchProbeControl', 'mbbiDirect', True),
                'new_position': (new, 'positionActual', 'mbboDirect', False, '_2'),
                'new_status': (new, 'touchProbeStatus', 'mbboDirect', False),
                'new_latch': (new, 'touchProbePositionPos', 'mbboDirect', False, '_1'),
            }
            for key, definition in definitions.items():
                terminal, field, kind, read = definition[:4]
                suffix = definition[4] if len(definition) == 5 else ''
                name = (f'{prefix}ec0:s{terminal["slave"]}:{field}'
                        f'{terminal["channel"]}{suffix}')
                pv = factory(name, auto_monitor=False)
                record = factory(name + '.RTYP', auto_monitor=False)
                self.owned.extend((pv, record))
                if not pv.wait_for_connection(timeout=timeout) or not record.wait_for_connection(timeout=timeout):
                    raise RuntimeError('cannot connect to ' + name)
                if record.get(as_string=True, use_monitor=False, timeout=timeout) != kind:
                    raise RuntimeError(name + ': expected ' + kind)
                if not (pv.read_access if read else pv.write_access):
                    raise RuntimeError('missing access: ' + name)
                self.pvs[key] = pv
        except Exception:
            self.close()
            raise

    def read(self):
        values = []
        for key in ('old_control', 'new_control'):
            value = self.pvs[key].get(use_monitor=False, timeout=self.timeout)
            if value is None or int(value) != value:
                raise RuntimeError('invalid index encoder control: ' + self.pvs[key].pvname)
            values.append(int(value))
        return tuple(values)

    def step(self, controls, position_mm):
        scale = self.config['counts_per_mm']
        counts = round(position_mm * scale)
        previous = counts if self.previous_counts is None else self.previous_counts
        period = self.config['index_period_mm'] * scale
        if period <= 0 or int(period) != period:
            raise RuntimeError('index period must be a positive integral encoder count')
        period = int(period)
        if counts > previous:
            index = ((previous // period) + 1) * period
            crossed = index <= counts
        elif counts < previous:
            index = ((previous - 1) // period) * period
            crossed = index >= counts
        else:
            index, crossed = counts, False
        old_control, new_control = controls
        old_armed = bool(old_control & 1)
        if not old_armed:
            self.el5102_stored = False
        if old_armed and self.el5102_armed and crossed and not self.el5102_stored:
            self.el5102_latch = index & 0xffffffff
            self.el5102_stored = True
            self.el5102_capture = {'raw': self.el5102_latch,
                                   'position_mm': index / scale}
        self.el5102_armed = old_armed
        probe_was_stored = self.probe.positive_stored
        probe = self.probe.step(new_control, crossed, index if crossed else counts,
                                time.monotonic_ns())
        if self.probe.positive_stored and not probe_was_stored:
            self.el7062_capture = {'raw': probe.positive,
                                   'position_mm': (index if crossed else counts) / scale}
        self.previous_counts = counts
        return {
            'old_position': counts & 0xffffffff,
            'old_latch': self.el5102_latch,
            'old_status': int(self.el5102_stored),
            'new_position': counts & 0xffffffff,
            'new_latch': probe.positive,
            'new_status': probe.status,
        }

    def publish(self, feedback):
        # Latch payload precedes the status flag, matching PDO-cycle semantics.
        for key in ('old_position', 'old_latch', 'new_position', 'new_latch',
                    'old_status', 'new_status'):
            pv = self.pvs[key]
            if not pv.connected or pv.put(feedback[key], wait=True, timeout=self.timeout) != 1:
                raise RuntimeError('index encoder feedback write failed: ' + pv.pvname)

    def snapshot(self):
        return {'el5102_stored': self.el5102_stored,
                'el5102_latch': self.el5102_latch,
                'el5102_capture': self.el5102_capture,
                'el7062_enabled': self.probe.enabled,
                'el7062_positive_stored': self.probe.positive_stored,
                'el7062_latch': self.probe.positive,
                'el7062_capture': self.el7062_capture}

    def close(self):
        for pv in self.owned:
            pv.disconnect()


class ProbeAxis:
    def __init__(self, config, prefix, factory, timeout):
        self.config, self.timeout = config, timeout
        self.io = ds402.EpicsIO(prefix, 0, config['slave'], '01', timeout, factory)
        self.io.mode = 'csv'
        self.pvs, self.owned = {}, []
        self.probe = touch_probe.Model()
        self.trigger = None
        self.triggered = False
        self.event = None
        self.model = None
        try:
            self.io.connect()
            initial = self.io.pvs['initial'].get(use_monitor=False, timeout=timeout)
            initial = ds402.signed32(initial)
            scale = config['counts_per_mm']
            self.model = ds402.Model(ds402.Settings(encoder_counts_per_rev=scale,
                                velocity_units_per_rev_per_second=scale), initial)
            for key, field, kind in (
                ('control', 'touchProbeControl01', 'mbbiDirect'),
                ('status', 'touchProbeStatus01', 'mbboDirect'),
                ('positive', 'touchProbePositionPos01_1', 'mbboDirect'),
                ('negative', 'touchProbePositionNeg01_1', 'mbboDirect'),
                ('positive_time', 'touchProbeTimestampPos01_1', 'mbboDirect'),
                ('negative_time', 'touchProbeTimestampNeg01_1', 'mbboDirect')):
                pv = factory(f'{prefix}ec0:s{config["slave"]}:{field}', auto_monitor=False)
                record = factory(pv.pvname + '.RTYP', auto_monitor=False)
                self.owned.extend((pv, record))
                if not pv.wait_for_connection(timeout=timeout) or not record.wait_for_connection(timeout=timeout):
                    raise RuntimeError('cannot connect to ' + pv.pvname)
                if record.get(as_string=True, use_monitor=False, timeout=timeout) != kind:
                    raise RuntimeError(pv.pvname + ': expected ' + kind)
                if not (pv.read_access if key == 'control' else pv.write_access):
                    raise RuntimeError('missing access: ' + pv.pvname)
                self.pvs[key] = pv
        except Exception:
            self.close()
            raise

    def configure(self, position=None, direction=1):
        if position is not None and (not math.isfinite(position) or abs(position) >= .7):
            raise ValueError('probe trigger must lie inside the SIM travel bound')
        if direction not in (-1, 1):
            raise ValueError('probe direction must be -1 or 1')
        self.trigger = None if position is None else (position*self.config['counts_per_mm'], direction)
        self.triggered = False
        self.event = None

    def read(self):
        return (*self.io.read(), self.pvs['control'].get(use_monitor=False, timeout=self.timeout))

    def step(self, commands, seconds):
        before = self.model.position_counts
        drive = self.model.step(*commands[:2], seconds)
        after = self.model.position_counts
        scale = self.config['counts_per_mm']
        if abs(after / scale) >= .8:
            raise RuntimeError('DS402 probe axis exceeded SIM travel bound')
        position, stamp, level = math.floor(after), time.monotonic_ns(), False
        if self.trigger is not None and not self.triggered:
            target, direction = self.trigger
            if direction*(target-before) >= 0 and direction*(after-target) >= 0 and after != before:
                position = round(target)
                level = self.triggered = True
                self.event = {'position_mm': position/scale, 'raw': position & 0xffffffff,
                              'time_raw': stamp & 0xffffffff}
        # Input pulses, not result PVs, generate the probe's independent latch.
        probe = self.probe.step(commands[2], level, position, stamp)
        return drive, probe

    def publish(self, feedback):
        drive, probe = feedback
        self.io.publish(drive)
        # Publish payload before asserting the stored flag; retain each capture
        # until ECMC disarms it. CA writes are not an atomic PDO transaction.
        for key in ('positive', 'negative', 'positive_time', 'negative_time', 'status'):
            pv = self.pvs[key]
            if not pv.connected or pv.put(getattr(probe, key), wait=True, timeout=self.timeout) != 1:
                raise RuntimeError('probe feedback write failed: ' + pv.pvname)

    def snapshot(self):
        return {'position_mm': self.model.position_counts/self.config['counts_per_mm'],
                'drive_state': self.model.state, 'triggered': self.triggered,
                'event': self.event.copy() if self.event else None}

    def close(self):
        if self.model is not None:
            self.model.trip()
            self.io.withdraw(self.model.feedback())
        self.io.close()
        for pv in self.owned: pv.disconnect()
