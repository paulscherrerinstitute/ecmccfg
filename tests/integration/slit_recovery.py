"""Live terminal-state/alarm/recovery checks shared by the two slit suites."""
import time
import math
from slit_motion_checks import MotionExpectation

STALL_ERROR = 0x14c19
SLAVE_INTERLOCK = 0x1432e
SLAVE_TRAJECTORY_CHANGED = 0x14331


def wait_checked(rig, predicate, description, timeout, allowed=None):
    allowed = allowed or {}
    end = time.monotonic()+timeout
    while time.monotonic() < end:
        if hasattr(rig, 'plant'): rig.plant.check()
        if rig.client.get(rig.prefix+'MCU-AppMode') != 1 or rig.client.get(rig.prefix+'m0-Stat-OK') != 1:
            raise AssertionError('IOC/bus state changed during recovery test')
        accepted = {0}
        for axis in rig.profile['axes']:
            codes = set(allowed.get(axis, ())) | {0}
            accepted.update(codes)
            error = int(rig.get(axis, '-ErrId'))
            if error not in codes: raise AssertionError(f'{axis}: unexpected error {error:#x}')
        global_error = int(rig.client.get(rig.prefix+'MCU-ErrId'))
        if global_error not in accepted: raise AssertionError(f'unexpected controller error {global_error:#x}')
        if hasattr(rig, 'check_envelope'):
            rig.check_envelope({a: rig.get(a, '-PosAct') for a in rig.profile['physical']})
        else:
            for axis in rig.profile['physical']:
                if abs(rig.get(axis, '-PosAct')) >= .8: raise AssertionError('simulation recovery travel bound')
        if rig.motion_expectation is not None: rig.motion_expectation.check()
        if predicate(): return
        time.sleep(.02)
    raise AssertionError('timeout: '+description)


def motor_idle(rig, axes):
    return all(rig.get(a, '-Busy') == 0 and abs(rig.get(a, '-VelAct')) < .005
               and rig.get(a, '.DMOV') == 1 and rig.get(a, '.MOVN') == 0
               and rig.get(a, '.MIP') == 0 and rig.get(a, '.PACT') == 0 for a in axes)


def stationary_dwell(rig, positions, allowed=None, seconds=.6):
    tolerance = rig.profile.get('tolerance', .015)
    stable_since = None
    def held():
        nonlocal stable_since
        fields = ('-Busy', '-VelAct', '.DMOV', '.MOVN', '.MIP', '.PACT')
        state = {a: {f: rig.get(a, f) for f in fields} for a in rig.profile['axes']}
        terminal = all(values['-Busy'] == 0 and values['.DMOV'] == 1
                       and values['.MOVN'] == 0 and values['.MIP'] == 0
                       and values['.PACT'] == 0 for values in state.values())
        if not terminal:
            raise AssertionError('motor record or native axis restarted after termination: '+str(state))
        for axis, value in positions.items():
            if abs(rig.get(axis, '-PosAct')-value) > tolerance: raise AssertionError(axis+': cancelled motion replayed')
        # Actual velocity is independently published and may briefly retain or
        # quantize a pre-STOP sample on slow hardware.  Demand a continuous
        # quiet interval while still rejecting command restarts and drift on
        # every observation.
        if any(abs(values['-VelAct']) >= .005 for values in state.values()):
            stable_since = None
            return False
        if stable_since is None: stable_since = time.monotonic()
        return time.monotonic()-stable_since >= seconds
    wait_checked(rig, held, 'terminal motor state and measured velocity remain stationary', seconds+5, allowed)


def reset_known_errors(rig, allowed):
    # Validate every error before issuing a reset that affects all axes.
    wait_checked(rig, lambda: motor_idle(rig, rig.profile['axes']), 'standstill before known-error reset', 5, allowed)
    rig.client.put(rig.prefix+'MCU-ErrRst', 1)
    if rig.client.get(rig.prefix+'SM00-EnaCmd'):
        rig.client.put(rig.prefix+'SM00-StateCmd', 3)
    # CA writes complete before all RT changes/readbacks necessarily publish.
    # Keep accepting only the already-validated faults during this bounded wait;
    # success still requires every axis and the controller to report no error.
    def reset_complete():
        if not motor_idle(rig, rig.profile['axes']):
            raise AssertionError('motion or motor processing restarted during known-error reset')
        return (all(rig.get(a, '-ErrId') == 0 for a in rig.profile['axes'])
                and rig.client.get(rig.prefix+'MCU-ErrId') == 0
                and rig.client.get(rig.prefix+'SM00-StateCmd') == 0)
    wait_checked(rig, reset_complete, 'known test fault resets without motion', 5, allowed)
    # Clearing the controller latch can release a motor-record retry that was
    # pending while the controller was faulted. Process STOP once more after
    # reset so that no stale target is retried and record alarms are cleared.
    for axis in rig.profile['axes']:
        rig.client.put(rig.prefix+axis+'.STOP', 1, wait=False, notify=False)
    wait_checked(rig, lambda: motor_idle(rig, rig.profile['axes'])
                 and all(rig.get(a, '.SEVR') == 0 for a in rig.profile['axes']),
                 'motor records terminate and clear alarms after error reset', 5)



def slave_fault_errors(rig, axis, error):
    """Expected local fault and its enabled state-machine master propagation."""
    allowed = {axis: (error,)}
    if rig.client.get(rig.prefix+'SM00-EnaCmd') == 1:
        allowed.update({master: (0x1432b, 0x1432e) for master in ('CENTERY', 'GAPY')})
    return allowed


def unrepresentable_stall_target(desired, reference, quantum, max_adjustment, motor_resolution=None):
    """Choose a nearby target between integer encoder counts, with valid tol."""
    values = (desired, reference, quantum, max_adjustment)
    if not all(math.isfinite(v) for v in values) or quantum <= 0 or max_adjustment <= 0:
        raise AssertionError('stall test requires finite position and positive encoder resolution')
    if motor_resolution is None:
        candidates = [reference+(round((desired-reference)/quantum)+.5)*quantum]
    else:
        if not math.isfinite(motor_resolution) or motor_resolution <= 0:
            raise AssertionError('stall test requires positive motor resolution')
        count = round(desired/motor_resolution)
        candidates = [(count+i)*motor_resolution for i in range(-8, 9)]
    choices = []
    for target in candidates:
        counts = (target-reference)/quantum
        distance = abs(counts-round(counts))*quantum
        if abs(target-desired) <= max_adjustment and distance > quantum/100:
            choices.append((distance, -abs(target-desired), target))
    if not choices:
        raise AssertionError('no nearby motor/native target between encoder counts; cannot force AtTarget=0 with valid tolerance')
    distance, _, target = max(choices)
    # A power of ten also fits the IOC string command's 39-byte payload.
    tolerance = 10**math.floor(math.log10(min(quantum/1000, distance/10)))
    if not math.isfinite(tolerance) or tolerance <= 0:
        raise AssertionError('encoder resolution too small for a positive stall tolerance')
    return target, tolerance


def stall_alarm(rig, axis, trigger, step, velocity, validate):
    number = rig.profile['axes'][axis]
    origin = rig.get(axis, '-PosAct')
    target = origin+step
    validate(axis, target)
    transport = rig.open_text_commands()
    keys = ('MonAtTargetTol', 'MonEnableStallMon', 'MonStallMinTimeOut', 'MonStallTimeFactor')
    saved = {}
    complete = None
    allowed = slave_fault_errors(rig, axis, STALL_ERROR)
    previous = rig.motion_expectation
    stage = 'before monitor configuration'
    try:
        rig.trace.append({'action': 'stall test entry', 'axis': axis, 'trigger': trigger,
                          'snapshot': rig.snapshot()})
        wait_checked(rig, lambda: motor_idle(rig, rig.profile['axes']),
                     'fault-free standstill before stall-monitor configuration', 5)
        query = lambda name: rig.text_command(f'GetAxis{name}({number})', query=True)
        config = lambda name, value: rig.text_command(f'Cfg.SetAxis{name}({number},{value:.12g})')
        saved = {key: query(key) for key in keys}
        if query('MonEnableAtTargetMon') != 1: raise AssertionError('stall test requires enabled AtTarget monitoring')
        # Auto-power requires positive AtTarget tolerance even while disabled.
        # Read the actual motion-feedback scale, preserving the config selector.
        encoder = int(rig.get(axis, '-SetEncIdCmd-RB'))
        source = int(query('EncPwrSource'))
        auto_power = source > 0 and int(query('EncMode')) == 0
        backup = int(query('EncPwrBackup')) if auto_power else 0
        if auto_power: encoder = source
        selected = int(query('EncConfigIndex'))
        try:
            rig.text_command(f'Cfg.SelectAxisEncConfig({number},{encoder})')
            numerator, denominator = query('EncScaleNum'), query('EncScaleDenom')
        finally:
            rig.text_command(f'Cfg.SelectAxisEncConfig({number},{selected})')
        if not denominator: raise AssertionError('encoder denominator is zero')
        quantum = abs(numerator/denominator)
        reference = rig.get(axis, f'-Enc{encoder:02d}-PosAct')
        resolution = abs(rig.get(axis, '.MRES')) if trigger == 'motor' else None
        target, test_tolerance = unrepresentable_stall_target(
            target, reference, quantum, rig.profile.get('tolerance', .015)/10, resolution)
        validate(axis, target)
        rig.trace.append({'action': 'stall target between encoder counts', 'axis': axis,
                          'trigger': trigger, 'encoder': encoder, 'encoder_quantum': quantum,
                          'reference': reference, 'motor_resolution': resolution,
                          'target': target, 'at_target_tolerance': test_tolerance})
        stage = 'configuring stall monitor'
        config('MonEnableStallMon', 1)
        config('MonStallMinTimeOut', 1000)  # Dedicated fixtures both run at 1 kHz.
        config('MonStallTimeFactor', 0)
        config('MonAtTargetTol', test_tolerance)  # Positive, but below the unavoidable quantization error.
        stage = 'requesting test move'
        rig.trace.append({'action': 'stall monitor configured before move', 'axis': axis,
                          'trigger': trigger, 'saved_monitor': dict(saved), 'snapshot': rig.snapshot()})
        rig.motion_expectation = MotionExpectation(rig, axis)
        if trigger == 'motor':
            if hasattr(rig, 'start'): complete = rig.start(axis, target)
            else: complete = rig.start_move(axis, target)
        else:
            for field, value in (('-ExeCmd', 0), ('-MtnCmd', 3), ('-MtnCmdData', 0),
                                 ('-TgtVelCmd', velocity), ('-TgtPosCmd', target), ('-EnaCmd', 1)):
                rig.client.put(rig.prefix+axis+field, value)
            wait_checked(rig, lambda: rig.get(axis, '-EnaAct') == 1, 'enabled for native stall test', 10)
            rig.client.put(rig.prefix+axis+'-ExeCmd', 1)
        stage = 'waiting for trajectory end'
        wait_checked(rig, lambda: rig.get(axis, '-BusyLocal') == 0
                     and abs(rig.get(axis, '-VelAct')) < .005
                     and abs(rig.get(axis, '-PosAct')-target) < rig.profile.get('tolerance', .015),
                     'trajectory ends before AtTarget stall timeout', rig.profile.get('timeout', 15))
        if rig.get(axis, '-AtTarget') != 0: raise AssertionError('stall setup did not hold AtTarget low')
        # Only motor-triggered requests own a motor completion contract.
        # Native requests are checked through AtTarget and the stall alarm;
        # both interfaces must still leave motor records idle after termination.
        if trigger == 'motor' and (rig.get(axis, '.DMOV') != 0 or complete.is_set()):
            raise AssertionError('unfulfilled AtTarget incorrectly completed the motor request before the alarm')
        rig.trace.append({'action': 'AtTarget false before stall alarm', 'axis': axis,
                          'trigger': trigger, 'snapshot': rig.snapshot()})
        stage = 'waiting for stall alarm'
        def at_target_after_fault():
            if rig.get(axis, '-AtTarget') == 0: return True
            # Fault shutdown can power off the absolute source and rebase the
            # holding setpoint on its configured counter backup. AtTarget may
            # then assert; it is not evidence that the failed move succeeded.
            return (rig.get(axis, '-AtTarget') == 1 and auto_power and backup > 0
                    and rig.get(axis, '-SetEncIdCmd-RB') == backup
                    and rig.get(axis, f'-Enc{source:02d}-PwrState') == 1
                    and rig.get(axis, f'-Enc{source:02d}-PwrOn') == 0
                    and abs(rig.get(axis, '-PosSet')-rig.get(axis, '-PosAct'))
                        < rig.profile.get('tolerance', .015))
        wait_checked(rig, lambda: rig.get(axis, '-ErrId') == STALL_ERROR
                     and at_target_after_fault() and rig.get(axis, '-EnaAct') == 0
                     and motor_idle(rig, (axis,)) and int(rig.get(axis, '.MSTA')) & (1 << 9)
                     and rig.get(axis, '.SEVR') > 0 and (complete is None or complete.is_set()),
                     'stall alarm terminates motor processing despite AtTarget=0', 8, allowed)
        rig.trace.append({'action': 'AtTarget stall alarm terminates motor record', 'axis': axis,
                          'trigger': trigger, 'snapshot': rig.snapshot()})
        stage = 'checking faulted standstill and resetting'
        positions = {a: rig.get(a, '-PosAct') for a in rig.profile['physical']}
        rig.client.put(rig.prefix+axis+'.STOP', 1, wait=False, notify=False)
        stationary_dwell(rig, positions, allowed)
        for key, value in saved.items(): config(key, value)
        saved = {}
        reset_known_errors(rig, allowed)
        stationary_dwell(rig, positions)
        rig.client.put(rig.prefix+axis+'.SYNC', 1)
        wait_checked(rig, lambda: rig.get(axis, '.SEVR') == 0
                     and not int(rig.get(axis, '.MSTA')) & (1 << 9), 'motor alarm clears after reset', 5)
        rig.motion_expectation = None
        stage = 'fresh recovery move'
        rig.move(axis, origin)
        rig.trace.append({'action': 'stall recovery completed', 'axis': axis, 'trigger': trigger})
    except Exception as error:
        # Preserve the original physical/master faults before monitor settings,
        # STOP or the runner's failure cleanup can change their readbacks.
        try:
            rig.trace.append({'action': 'stall failure before cleanup', 'axis': axis,
                              'trigger': trigger, 'stage': stage, 'error': str(error),
                              'saved_monitor': dict(saved), 'snapshot': rig.snapshot()})
        except Exception:
            pass  # A failed diagnostic must never replace the original failure.
        raise
    finally:
        rig.motion_expectation = previous
        for key, value in saved.items():
            rig.text_command(f'Cfg.SetAxis{key}({number},{value:.12g})')
        rig.close_text_commands(transport)


def stop_blade_during_virtual(rig, master, blade, interface, step, validate):
    origin = rig.get(master, '-PosAct')
    target = origin+step
    validate(master, target)
    if rig.client.get(rig.prefix+'SM00-EnaCmd') != 1:
        raise AssertionError('coordinated stop requires the master/slave state machine')
    previous = rig.motion_expectation
    expectation = MotionExpectation(rig, master)
    rig.motion_expectation = expectation
    # A blade STOP takes it out of the external virtual trajectory. Depending
    # on the RT observation order, masters report an interlock or source change.
    allowed = {a: (SLAVE_INTERLOCK, SLAVE_TRAJECTORY_CHANGED) for a in ('CENTERY', 'GAPY')}
    try:
        complete = rig.start(master, target) if hasattr(rig, 'start') else rig.start_move(master, target)
        wait_checked(rig, lambda: rig.get(master, '-Busy') == 1
                     and all(rig.get(a, '-TrjSrcTyp-RB') == 1 and abs(rig.get(a, '-VelAct')) > .005
                             and abs(rig.get(a, '-PosAct')-expectation.before[a]) > .03 for a in rig.profile['physical']),
                     'both blades move under virtual ownership before physical STOP', 10)
        before = {a: rig.get(a, '-PosAct') for a in rig.profile['physical']}
        field = '.STOP' if interface == 'motor' else '-StpCmd'
        rig.client.put(rig.prefix+blade+field, 1, wait=False, notify=False)
        # STOP deliberately removes one blade from virtual trajectory
        # ownership.  From this point the two blades can begin deceleration on
        # different RT cycles, so preserving the commanded master's orthogonal
        # coordinate is no longer a valid motion-isolation requirement.  The
        # checks below still bound each blade's stopping travel and require the
        # complete group to terminate without replay.
        rig.motion_expectation = None
        wait_checked(rig, lambda: motor_idle(rig, rig.profile['axes']) and complete.is_set(),
                     'physical STOP terminates the complete coordinated group', 8, allowed)
        if abs(rig.get(master, '-PosAct')-target) <= rig.profile.get('tolerance', .015):
            raise AssertionError('physical STOP was ignored until virtual target completion')
        positions = {a: rig.get(a, '-PosAct') for a in rig.profile['physical']}
        for a, value in positions.items():
            bound = rig.profile.get('velocity', .4)**2/(2*rig.get(a, '.ACCS'))+rig.profile.get('velocity', .4)+.05
            if abs(value-before[a]) > bound: raise AssertionError(a+': excessive coordinated stopping travel')
        rig.trace.append({'action': 'physical STOP terminated virtual group',
                          'master': master, 'blade': blade, 'interface': interface, 'snapshot': rig.snapshot()})
        stationary_dwell(rig, positions, allowed)
        reset_known_errors(rig, allowed)
        stationary_dwell(rig, positions)
        rig.motion_expectation = None
        rig.move(master, origin)
        rig.kinematics()
        rig.trace.append({'action': 'physical STOP interrupts virtual motion and recovers',
                          'master': master, 'blade': blade, 'interface': interface, 'snapshot': rig.snapshot()})
    finally:
        rig.motion_expectation = previous


class StallCases:
    pass


class CoupledStopCases:
    pass


def _stall(axis, trigger):
    def test(self): self.exercise_stall(axis, trigger)
    test.__name__ = 'test_stall_'+('lo' if axis == 'TR_LO' else 'hi')+'_'+trigger+'_at_target_zero'
    return test


def _coupled(master, blade, interface):
    def test(self): self.exercise_coupled_stop(master, blade, interface)
    test.__name__ = 'test_'+('center' if master == 'CENTERY' else 'gap')+'_stop_'+('lo' if blade == 'TR_LO' else 'hi')+'_'+interface
    return test


STALL_NAMES = []
COUPLED_STOP_NAMES = []
for _axis in ('TR_LO', 'TR_HI'):
    for _trigger in ('motor', 'native'):
        _test = _stall(_axis, _trigger)
        setattr(StallCases, _test.__name__, _test)
        STALL_NAMES.append(_test.__name__)
    for _master in ('CENTERY', 'GAPY'):
        for _interface in ('motor', 'native'):
            _test = _coupled(_master, _axis, _interface)
            setattr(CoupledStopCases, _test.__name__, _test)
            COUPLED_STOP_NAMES.append(_test.__name__)
STALL_NAMES, COUPLED_STOP_NAMES = tuple(STALL_NAMES), tuple(COUPLED_STOP_NAMES)


def concurrent_physical_moves(rig, primary, secondary, step, velocity, validate):
    """Bounded commanded perturbations; no claim of external-force injection."""
    origins = {a: rig.get(a, '-PosAct') for a in rig.profile['physical']}
    target = origins[primary]+step
    nudge = min(.2, step/10)
    validate(primary, target)
    for offset in (nudge, -nudge, 0): validate(secondary, origins[secondary]+offset)
    saved = {a: rig.get(a, '.VELO') for a in origins}
    previous = rig.motion_expectation
    rig.motion_expectation = None
    successful = False
    try:
        if hasattr(rig, 'touched'): rig.touched.update(origins)
        slow = min(velocity, max(.05, velocity/4))
        rig.client.put(rig.prefix+primary+'.VELO', slow)
        rig.client.put(rig.prefix+secondary+'.VELO', velocity)
        complete = rig.client.put(rig.prefix+primary+'.VAL', target, wait=False)
        wait_checked(rig, lambda: rig.get(primary, '-Busy') == 1
                     and abs(rig.get(primary, '-PosAct')-origins[primary]) > .03,
                     'primary physical move active before secondary perturbation', 10)
        for offset in (nudge, -nudge, 0):
            destination = origins[secondary]+offset
            rig.client.put(rig.prefix+secondary+'.VAL', destination, wait=False, notify=False)
            def secondary_done():
                if rig.get(primary, '-Busy') != 1 or complete.is_set():
                    raise AssertionError('secondary motion prematurely stopped/completed the independent primary axis')
                if abs(rig.get(primary, '.VAL')-target) > rig.profile.get('tolerance', .015):
                    raise AssertionError('secondary motion replaced the independent primary target')
                return (rig.get(secondary, '-Busy') == 0 and rig.get(secondary, '.DMOV') == 1
                        and abs(rig.get(secondary, '-PosAct')-destination) <= rig.profile.get('tolerance', .015))
            wait_checked(rig, secondary_done, 'secondary nudge completes while primary continues', 10)
        wait_checked(rig, lambda: complete.is_set() and motor_idle(rig, rig.profile['axes'])
                     and abs(rig.get(primary, '-PosAct')-target) <= rig.profile.get('tolerance', .015),
                     'independent primary completes its original target', step/slow+15)
        rig.move(primary, origins[primary])
        rig.trace.append({'action': 'independent physical moves overlap without interference',
                          'primary': primary, 'secondary': secondary, 'snapshot': rig.snapshot()})
        successful = True
    finally:
        if not successful:
            for a in origins: rig.client.put(rig.prefix+a+'.STOP', 1, wait=False, notify=False)
        for a, value in saved.items(): rig.client.put(rig.prefix+a+'.VELO', value)
        rig.motion_expectation = previous
