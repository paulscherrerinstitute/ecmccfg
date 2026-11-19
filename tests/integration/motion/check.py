#!/usr/bin/env python3
"""Manual CA acceptance checks for the standalone simulation IOC."""
import argparse
import math
import os
import time


def check(client, names):
    get, put = client

    def require(condition, description):
        if not condition:
            raise AssertionError(description)

    def wait(condition, description, timeout=10):
        deadline = time.monotonic() + timeout
        while time.monotonic() < deadline:
            if condition():
                return
            time.sleep(.03)
        raise AssertionError(f'Timeout waiting for {description}')

    def idle(axis):
        return get(axis + '-Busy') == 0 and get(axis + '.DMOV') == 1

    def at(axis, target):
        return idle(axis) and abs(get(axis + '-PosAct') - target) < .006

    def require_idle():
        for axis in ('CSP', 'PLC'):
            require(idle(axis) and get(axis + '-ErrId') == 0,
                    f'{axis} must be idle and error-free before starting')

    def motor_started(axis):
        error = int(get(axis + '-ErrId'))
        limit = get(axis + '.LVIO')
        require(not error and not limit,
                f'{axis} rejected motion (ErrId={error:#x}, LVIO={limit:g})')
        return get(axis + '-Busy') == 1 and get(axis + '.DMOV') == 0

    def motor():
        require_idle()
        try:
            put('CSP-EnaCmd', 1)
            wait(lambda: get('CSP-EnaAct') == 1, 'CSP drive enable')
            put('CSP.SYNC', 1)
            wait(lambda: get('CSP.SYNC') == 0 and
                 abs(get('CSP.VAL') - get('CSP.RBV')) < .006, 'motor record sync')
            origin = get('CSP-PosAct')
            target = -.25 if origin > 0 else .25
            put('CSP.VAL', target)
            wait(lambda: motor_started('CSP'), 'CSP motion start')
            wait(lambda: at('CSP', target), 'CSP target and DMOV')
            require(abs(get('CSP.RBV') - target) < .006, 'motor readback differs from target')
            def pdo_at_target():
                command = get('SIM:ec0:s1:positionSetpoint01')
                feedback = int(get('SIM:ec0:s1:positionActual01-RB'))
                feedback = (feedback + (1 << 31)) % (1 << 32) - (1 << 31)
                return (abs(command / 1048576 - target) < .006 and
                        abs(feedback / 1048576 - target) < .006)

            wait(pdo_at_target, 'raw CSP setpoint and simulated encoder feedback')

            put('CSP.VAL', -target)
            wait(lambda: motor_started('CSP') and
                 abs(get('CSP-PosAct') - target) > .02, 'second CSP motion')
            put('CSP.STOP', 1)
            wait(lambda: idle('CSP'), 'CSP stop and DMOV')
            require(abs(get('CSP-PosAct') + target) > .05, 'CSP reached target before stop')
            require(get('CSP-ErrId') == 0, 'CSP axis error')
        finally:
            put('CSP.STOP', 1)
            put('CSP-EnaCmd', 0)

    def command(code, target=0, expected=0):
        require(get('SEQ-Request') == get('SEQ-Ack'), 'PLC has an outstanding request')
        count = get('SEQ-Commands')
        request = get('SEQ-Ack') + 1
        put('SEQ-Target', target)
        put('SEQ-Command', code)
        put('SEQ-Request', request)
        wait(lambda: get('SEQ-Ack') == request, f'PLC acknowledgement for command {code}')
        wait(lambda: get('SEQ-Commands') == count + 1 and
             get('SEQ-Result') == expected and get('SEQ-LastTarget') == target,
             f'PLC result, static counter and global target for command {code}')

    def plc():
        require_idle()
        wait(lambda: get('SEQ-FirstScans') >= 1, 'PLC first scan')
        def plc_at(target):
            error = int(get('PLC-ErrId'))
            require(not error, f'PLC axis error {error:#x} while moving to {target:g}')
            return at('PLC', target) and get('SEQ-Busy') == 0 and get('SEQ-AtTarget') == 1

        other = get('CSP-PosAct')
        scans = get('SEQ-Scans')
        first_scans = get('SEQ-FirstScans')
        try:
            command(99, expected=-1)
            command(7)
            command(1)
            wait(lambda: get('SEQ-Enabled') == 1 and get('PLC-EnaAct') == 1 and
                 get('SEQ-EncReady') == 1 and get('SEQ-HwReady') == 1, 'PLC power on')
            # Exercise the CSP offset change with a nonzero raw position.
            reference_from = -.25 if get('PLC-PosAct') > 0 else .25
            command(3, reference_from)
            wait(lambda: plc_at(reference_from), 'nonzero position before PLC reference')
            raw_pv = 'SIM:ec0:s2:positionActual01-RB'
            raw_before = int(get(raw_pv))
            command(8)

            def referenced():
                error = int(get('PLC-ErrId'))
                require(not error, f'PLC reference raised axis error {error:#x}')
                return (get('SEQ-Homed') == 1 and get('PLC-Homed') == 1 and get('SEQ-EncHomed') == 1 and
                        abs(get('SEQ-Actual')) < .006 and plc_at(0))

            wait(referenced, 'PLC reference at zero')
            deadline = time.monotonic() + .4
            while time.monotonic() < deadline:
                require(referenced(), 'PLC reference did not remain settled')
                raw_delta = (int(get(raw_pv)) - raw_before + (1 << 31)) % (1 << 32) - (1 << 31)
                require(abs(raw_delta) < .006 * 1048576, 'CSP drive moved during reference')
                time.sleep(.03)
            command(3, .25)
            wait(lambda: get('SEQ-Busy') == 1 and get('PLC.DMOV') == 0, 'PLC absolute motion')
            wait(lambda: plc_at(.25), 'PLC absolute target')
            command(4, -.15)
            wait(lambda: plc_at(.10), 'PLC relative move from .25 to .10')
            command(3, 0)
            wait(lambda: plc_at(0), 'PLC absolute return to zero after relative move')
            command(5, .12)
            wait(lambda: get('SEQ-Busy') == 1 and get('SEQ-Actual') > .025, 'PLC velocity motion')
            command(6)
            wait(lambda: idle('PLC') and get('SEQ-Busy') == 0, 'PLC halt and DMOV')
            command(3, .9, expected=-2)
            require(idle('PLC'), 'out-of-bounds PLC request caused motion')
            require(get('SEQ-AxisError') == 0 and get('PLC-ErrId') == 0, 'PLC axis error')
            require(get('SEQ-Scans') > scans and get('SEQ-FirstScans') == first_scans,
                    'unexpected PLC scan counters')
            require(abs(get('CSP-PosAct') - other) < .006, 'PLC motion moved the CSP axis')
            command(2)
            wait(lambda: get('SEQ-Enabled') == 0 and get('PLC-EnaAct') == 0, 'PLC power off')
            command(11, expected=0x14c08)
            wait(lambda: get('SEQ-AxisError') == 0x14c08 and get('PLC-ErrId') == 0x14c08,
                 'injected PLC axis error')
            command(7)
            wait(lambda: get('SEQ-AxisError') == 0 and get('PLC-ErrId') == 0,
                 'PLC reset clears the axis error')
        finally:
            put('PLC.STOP', 1)
            put('PLC-EnaCmd', 0)

    def ethercat():
        input_pv = 'SIM:ec0:s3:binaryInput01'
        output_pv = 'SIM:ec0:s4:binaryOutput01'
        try:
            # Check both transitions and the final low state through real PDO PVs.
            for bit in (0, 1, 0):
                put(input_pv, bit)
                wait(lambda: get(input_pv + '-RB') == bit, f'injected input {bit}')
                command(9)
                wait(lambda: get(output_pv) == bit and get('SEQ-EcValue') == 90 and
                     get('SEQ-EcError') == 0x20800, f'PLC PDO output and bit results for {bit}')
        finally:
            put(input_pv, 0)
            wait(lambda: get(input_pv + '-RB') == 0, 'clear simulated input')
            command(9)

    def storage():
        # Different samples on every request avoid accepting a previous waveform.
        sample = get('SEQ-Ack') + 10
        command(10, sample)
        wait(lambda: get('SEQ-DsError') == 0x20203 and get('SEQ-DsAverage') == sample + 2.5,
             'data storage bounds error and average')
        wait(lambda: tuple(get('DS00-DataAct')[:4]) == (sample, sample + 1, sample + 6, sample + 3) and
             tuple(get('DS01-DataAct')[:2]) == (sample + 1, sample + 6),
             'published source and copied data storage waveforms')

    def group_sequence():
        require_idle()
        axes = ('CSP', 'PLC')
        state_idle, state_armed, state_done, state_stopped = 0, 1, 3, 5
        require(get('Seq0-Running') == 0, 'sequence already running')
        wait(lambda: get('SEQ-GroupSize') == 2 and get('SEQ-GroupMember') == 1,
             'both axes in the PLC motion group')

        def start():
            put('Seq0-Cmd-Arm', 1)
            wait(lambda: get('Seq0-State') == state_armed and
                 get('SEQ-SeqState') == state_armed, 'sequence armed')
            put('Seq0-Cmd-Start', 1)
            wait(lambda: get('Seq0-Running') == 1 and get('SEQ-SeqRunning') == 1 and
                 get('SEQ-GroupBusy') == 1 and all(get(a + '-Busy') == 1 for a in axes),
                 'sequence starts both group members')

        try:
            command(12, 1)
            wait(lambda: get('SEQ-GroupEnable') == 1 and
                 all(get(a + '-EnaAct') == 1 for a in axes), 'group enabled')
            for axis in axes:
                if abs(get(axis + '-PosAct')) >= .006:
                    put(axis + '.SYNC', 1)
                    wait(lambda: get(axis + '.SYNC') == 0 and
                         abs(get(axis + '.VAL') - get(axis + '.RBV')) < .006,
                         f'{axis} motor record sync')
                    put(axis + '.VAL', 0)
                    wait(lambda: at(axis, 0), f'{axis} at zero before the sequence')

            start()
            command(11, expected=0x14c08)
            wait(lambda: get('SEQ-GroupError') == 0x14c08 and get('PLC-ErrId') == 0x14c08,
                 'group reports the fault from its PLC axis')
            # The group is an aggregate. Issue its halt explicitly on fault.
            command(13)
            put('Seq0-Cmd-Stop', 1)
            wait(lambda: get('SEQ-GroupBusy') == 0 and all(idle(a) for a in axes) and
                 get('Seq0-State') == state_stopped, 'group halt and sequence stop')
            require(get('CSP-PosAct') < .40, 'healthy group axis reached the target before the halt')
            require(get('CSP-ErrId') == 0, 'healthy group axis also faulted')
            command(14)
            put('Seq0-Cmd-Reset', 1)
            wait(lambda: get('SEQ-GroupError') == 0 and get('PLC-ErrId') == 0 and
                 get('Seq0-State') == state_idle and get('Seq0-ErrorId') == 0,
                 'group and sequence reset')

            command(12, 1)
            wait(lambda: get('SEQ-GroupEnable') == 1, 'group re-enabled after reset')
            start()
            wait(lambda: get('Seq0-State') == state_done and
                 get('SEQ-SeqState') == state_done and get('SEQ-GroupBusy') == 0 and
                 at('CSP', .45) and at('PLC', -.45), 'sequence completes after recovery')
            require(get('Seq0-ErrorId') == 0 and get('SEQ-GroupError') == 0,
                    'unexpected error after group sequence')
        finally:
            put('Seq0-Cmd-Stop', 1)
            for axis in axes:
                put(axis + '.STOP', 1)
                put(axis + '-EnaCmd', 0)

    require(get('MCU-Cfg-Sim-Mode') == 1, 'Refusing to issue motion outside simulation')
    cases = {'csp': motor, 'plc': plc, 'ethercat': ethercat, 'storage': storage,
             'group-sequence': group_sequence}
    for name in names:
        cases[name]()
        print(f'PASS {name}', flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--case', choices=('csp', 'plc', 'ethercat', 'storage', 'group-sequence'), action='append')
    args = parser.parse_args()
    os.environ.setdefault('EPICS_CA_AUTO_ADDR_LIST', 'NO')
    os.environ.setdefault('EPICS_CA_ADDR_LIST', '127.0.0.1')
    from epics import PV

    pvs = {}

    def pv(suffix):
        if suffix not in pvs:
            pvs[suffix] = PV('SIMMOTION:' + suffix, auto_monitor=False)
        return pvs[suffix]

    def get(suffix):
        value = pv(suffix).get(use_monitor=False, timeout=2)
        if value is None or (not suffix.endswith('-DataAct') and not math.isfinite(value)):
            raise RuntimeError(f'Could not read SIMMOTION:{suffix}')
        return value

    def put(suffix, value):
        # Motor VAL put-notify can wait for motion completion. Use ordinary
        # puts for VAL and STOP so the checker can observe or interrupt motion.
        wait = not suffix.endswith(('.VAL', '.STOP'))
        status = pv(suffix).put(value, wait=wait, timeout=2)
        if status != 1:
            raise RuntimeError(f'Could not write SIMMOTION:{suffix}={value!r} '
                               f'(CA result={status!r}, wait={wait})')

    check((get, put), args.case or ('csp', 'plc', 'ethercat', 'storage', 'group-sequence'))


if __name__ == '__main__':
    main()
