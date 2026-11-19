#!/usr/bin/env python3
"""Spam motor/native ABS requests before and during interlock homing."""

import argparse
import math
import random
import threading
import time

from epics import PV


class TestFailure(RuntimeError):
    pass


class IOC:
    def __init__(self, prefix, axis, plc, timeout):
        self.prefix = prefix
        self.axis = prefix + axis
        self.block = f'{prefix}PLC{plc}-DbgCmd'
        self.timeout = timeout
        self.pvs = {}

    def pv(self, name):
        if name not in self.pvs:
            pv = PV(name, auto_monitor=False)
            if not pv.wait_for_connection(timeout=self.timeout):
                raise TestFailure(f'cannot connect to {name}')
            self.pvs[name] = pv
        return self.pvs[name]

    def name(self, suffix):
        return self.axis + suffix

    def get_name(self, name):
        value = self.pv(name).get(use_monitor=False, timeout=self.timeout)
        if value is None or not math.isfinite(float(value)):
            raise TestFailure(f'failed to read finite value from {name}')
        return float(value)

    def get(self, suffix):
        return self.get_name(self.name(suffix))

    def put_name(self, name, value, wait=True):
        pv = self.pv(name)
        if not pv.write_access:
            raise TestFailure(f'PV is not writable: {name}')
        result = pv.put(value, wait=wait, timeout=self.timeout)
        if result != 1:
            raise TestFailure(f'write failed: {name}={value!r}, result={result!r}')

    def put(self, suffix, value, wait=True):
        self.put_name(self.name(suffix), value, wait)

    def close(self):
        for pv in self.pvs.values():
            pv.disconnect()


def wait_until(predicate, description, timeout, interval=.05):
    deadline = time.monotonic() + timeout
    last = None
    while time.monotonic() < deadline:
        last = predicate()
        if last:
            return
        time.sleep(interval)
    raise TestFailure(f'timeout waiting for {description}; last={last!r}')


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('prefix', help='IOC prefix including trailing colon')
    parser.add_argument('position_a', type=float,
                        help='first hardware-safe absolute position')
    parser.add_argument('position_b', type=float,
                        help='second hardware-safe absolute position')
    parser.add_argument('--axis', default='X', help='axis record name (default: X)')
    parser.add_argument('--plc', default='00', help='two-character PLC index (default: 00)')
    parser.add_argument('--pre-block-seconds', type=float, default=2,
                        help='maximum random jitter before asserting the block')
    parser.add_argument('--spam-interval', type=float, default=.05,
                        help='delay between motor/native command pairs')
    parser.add_argument('--home-timeout', type=float, default=40,
                        help='maximum time for home to start and complete')
    parser.add_argument('--ca-timeout', type=float, default=1,
                        help='timeout for each Channel Access operation')
    parser.add_argument('--cycles', type=int, default=0,
                        help='number of cycles; 0 repeats until Ctrl-C (default: 0)')
    parser.add_argument('--between-cycles', type=float, default=1,
                        help='maximum random low-block dwell between cycles')
    parser.add_argument('--seed', type=int,
                        help='random timing seed; omitted uses system randomness')
    args = parser.parse_args(argv)
    rng = random.Random(args.seed)

    if not args.prefix.endswith(':'):
        parser.error('prefix must end with a colon')
    if args.position_a == args.position_b:
        parser.error('the two spam positions must differ')
    if args.cycles < 0:
        parser.error('cycles must be zero or positive')
    for name in ('pre_block_seconds', 'spam_interval', 'home_timeout',
                 'ca_timeout', 'between_cycles'):
        if not math.isfinite(getattr(args, name)) or getattr(args, name) <= 0:
            parser.error(name.replace('_', '-') + ' must be finite and positive')

    ioc = IOC(args.prefix, args.axis, args.plc, args.ca_timeout)
    stop_spam = threading.Event()
    spam_error = []
    spam_count = [0]
    spam_thread = None
    passed = False

    required = ('.VAL', '-MtnCmd', '-MtnCmdData', '-TgtPosCmd', '-ExeCmd',
                '-Busy', '-Homed', '-SeqState', '-ErrId', '-PosAct', '-EnaAct',
                '-StpCmd', '-EnaCmd')

    def stop_spammer():
        stop_spam.set()
        if spam_thread is not None:
            spam_thread.join(timeout=max(2, args.ca_timeout * 3))
            if spam_thread.is_alive():
                raise TestFailure('setpoint spam thread did not stop')

    def start_spammer():
        nonlocal stop_spam, spam_thread
        stop_spam = threading.Event()
        spam_error.clear()
        spam_thread = threading.Thread(target=spam, name='setpoint-spam', daemon=True)
        spam_thread.start()

    def safe_cleanup():
        try:
            stop_spammer()
        except Exception as error:
            print(f'cleanup warning: {error}')
        for name, value in ((ioc.name('-StpCmd'), 1),
                            (ioc.name('-EnaCmd'), 0),
                            (ioc.block, 0)):
            try:
                ioc.put_name(name, value)
            except Exception as error:
                print(f'cleanup warning: {error}')

    def spam():
        try:
            targets = (args.position_a, args.position_b)
            index = 0
            while not stop_spam.is_set():
                target = targets[index % 2]
                index += 1
                # Motor-record ABS request. Never wait for motion completion.
                ioc.put('.VAL', target, wait=False)
                # Native ABS request with a new momentary execute write.
                ioc.put('-ExeCmd', 0)
                ioc.put('-MtnCmd', 3)
                ioc.put('-MtnCmdData', 0)
                ioc.put('-TgtPosCmd', target)
                ioc.put('-ExeCmd', 1)
                spam_count[0] += 2
                stop_spam.wait(args.spam_interval)
        except Exception as error:
            spam_error.append(error)
            stop_spam.set()

    def check_spammer():
        if spam_error:
            raise TestFailure(f'setpoint spam failed: {spam_error[0]}')
        if spam_thread is None or not spam_thread.is_alive():
            raise TestFailure('setpoint spam stopped unexpectedly')

    try:
        print('Checking IOC connectivity...')
        ioc.pv(ioc.block)
        for suffix in required:
            ioc.pv(ioc.name(suffix))

        error = int(ioc.get('-ErrId'))
        if error:
            raise TestFailure(f'axis starts with error 0x{error:x}')

        print(f'Axis={ioc.axis}, block={ioc.block}')
        print(f'Hardware-safe targets={args.position_a:g}, {args.position_b:g}')
        print('WARNING: this test commands real motion; Ctrl-C performs safe cleanup.')
        time.sleep(2)

        print('Starting continuous motor and native ABS setpoint spam...')
        start_spammer()
        cycle = 0
        while args.cycles == 0 or cycle < args.cycles:
            cycle += 1
            cycle_spam_start = spam_count[0]
            print(f'\n=== cycle {cycle} ===')
            ioc.put_name(ioc.block, 0)
            # Keep the low pulse visible to at least several PLC scans, then
            # deliberately assert the block at different awkward phases.
            time.sleep(.02)
            phase = ('immediate-race', 'just-enabled', 'actively-moving',
                     'random-delay')[(cycle - 1) % 4]
            if phase == 'just-enabled':
                wait_until(lambda: int(ioc.get('-EnaAct')) == 1,
                           'auto-enable before edge-timing trigger', 10)
            elif phase == 'actively-moving':
                wait_until(lambda: int(ioc.get('-Busy')) == 1,
                           'active ordinary move before trigger', 10)
            elif phase == 'random-delay':
                time.sleep(rng.uniform(0, args.between_cycles))
            # immediate-race intentionally does not wait for enable or motion.
            # Add independent sub-scan/CA jitter to every phase.
            jitter = rng.uniform(0, args.pre_block_seconds)
            if phase == 'immediate-race':
                jitter = min(jitter, .02)
            time.sleep(jitter)
            check_spammer()

            ena_before = int(ioc.get('-EnaAct'))
            busy_before = int(ioc.get('-Busy'))
            print(f'Asserting block/interlock in phase={phase}, jitter={jitter:.4f}s, '
                  f'EnaAct={ena_before}, Busy={busy_before}; spam continues...')
            ioc.put_name(ioc.block, 1)
            home_deadline = time.monotonic() + args.home_timeout

            def homing_active():
                check_spammer()
                error_now = int(ioc.get('-ErrId'))
                if error_now:
                    raise TestFailure(f'axis error before active home: 0x{error_now:x}')
                return (int(ioc.get('-Busy')) == 1
                        and int(ioc.get('-SeqState')) != 0
                        and int(ioc.get('-Homed')) == 0)

            wait_until(homing_active, 'active homing under command spam',
                       max(.1, home_deadline - time.monotonic()))
            start_position = ioc.get('-PosAct')
            print(f'Homing active at {start_position:g}; monitoring continuously...')

            while True:
                check_spammer()
                error = int(ioc.get('-ErrId'))
                busy = int(ioc.get('-Busy'))
                sequence = int(ioc.get('-SeqState'))
                homed = int(ioc.get('-Homed'))
                if error:
                    raise TestFailure(f'axis error during blocked home: 0x{error:x}')
                if homed:
                    break
                if not busy or not sequence:
                    # Busy, sequence and Homed are published separately. Allow
                    # a short completion window, but not a stopped home.
                    wait_until(lambda: int(ioc.get('-Homed')) == 1,
                               'Homed publication after Busy cleared', .5)
                    break
                if time.monotonic() >= home_deadline:
                    raise TestFailure('homing timed out under command spam')
                time.sleep(.05)

            end_position = ioc.get('-PosAct')
            ioc.put_name(ioc.block, 0)
            cycle_pairs = spam_count[0] - cycle_spam_start
            print(f'PASS cycle {cycle}: homing completed under ABS spam')
            print(f'      position {start_position:g} -> {end_position:g}')
            print(f'      injected command pairs this cycle: {cycle_pairs}')
            print(f'      trigger phase: {phase}, pre-edge EnaAct={ena_before}, Busy={busy_before}')
            print('      command spam remained continuous while block toggled')

        stop_spammer()
        # For a finite run, cancel motor bookkeeping before leaving ordinary
        # motion admitted. Infinite runs reach this cleanup through Ctrl-C.
        ioc.put('-StpCmd', 1)
        ioc.put_name(ioc.block, 0)
        passed = True
        print(f'PASS: completed {cycle} requested cycles')
        return 0
    except KeyboardInterrupt:
        print('Interrupted; performing safe cleanup')
        return 130
    except Exception as error:
        print(f'FAIL: {error}')
        return 1
    finally:
        if not passed:
            safe_cleanup()
        else:
            try:
                stop_spammer()
            except Exception as error:
                print(f'cleanup warning: {error}')
        ioc.close()


if __name__ == '__main__':
    raise SystemExit(main())
