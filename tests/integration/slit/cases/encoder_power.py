"""Relay-controlled EL5042 supply, zero raw position when off, and wake gating."""
import time

from .base import SlitCase


class EncoderPowerCase(SlitCase):
    axis = 'TR_HI'
    encoder = 2

    def setUp(self):
        super().setUp()
        self.number = self.rig.profile['axes'][self.axis]
        self.power = self.rig.profile['physical'][self.axis]['encoder_power']
        self.off_raw = 0
        transport = self.rig.open_text_commands()
        self.addCleanup(self.rig.close_text_commands, transport)
        self.previous = self.query('EncConfigIndex')
        self.saved = {}
        self.addCleanup(self.restore)
        self.config('SelectAxisEncConfig', self.encoder, full=True)
        self.saved = {key: self.query(key) for key in (
            'EncPwrEnable', 'EncPwrPol', 'EncPwrDelay', 'EncPwrTimeout', 'EncPwrOffDelay',
            'EnableAutoDisable', 'AutoDisableAfterTime', 'EnableAutoEnable', 'AutoEnableTimeout',
            'CntrlDeadband', 'CntrlDeadbandTime')}
        self.assertEqual(self.saved['EncPwrEnable'], 0, 'fixture starts in ordinary encoder mode')
        self.kp = self.rig.get(self.axis, '-Ctrl-Kp')
        self.assertFalse(self.rig.stop_all())
        self.rig.wait_drive_disabled(self.axis)
        # The slit SM immediately disables a completed physical group when any
        # member has axis auto-disable disabled. Retain that policy and give
        # this axis a long idle timeout, beyond the encoder dwell checks.
        self.config('AutoDisableAfterTime', 60)
        self.config('EnableAutoDisable', 1)
        self.config('EnableAutoEnable', 1)
        self.config('AutoEnableTimeout', 5)
        self.config('EncPwrPol', 1)
        self.config('EncPwrTimeout', max(2, self.saved['EncPwrDelay'] + 1))
        self.config('EncPwrDelay', .3)
        self.config('EncPwrTimeout', 2)
        self.config('EncPwrOffDelay', 1)
        self.config('EncPwrEnable', 1)
        # Coupling is opt-in, like the plant's position-based homing sensors.
        # Other test groups retain their continuously powered encoder model.
        self.rig.plant.configure_encoder_power(self.axis, active_high=True, startup_delay=.08)
        self.wait_off()

    def query(self, key):
        return self.rig.text_command(f'GetAxis{key}({self.number})', query=True)

    def config(self, key, value, full=False):
        name = key if full else 'SetAxis' + key
        self.rig.text_command(f'Cfg.{name}({self.number},{value:.9g})')

    def state(self):
        return self.rig.get(self.axis, f'-Enc0{self.encoder}-PwrState')

    def relay(self):
        return self.rig.client.get(self.rig.prefix +
                                   f'SIM:ec0:s{self.power["slave"]}:binaryOutput{self.power["channel"]}')

    def raw(self):
        cfg = self.rig.profile['physical'][self.axis]
        return self.rig.client.get(self.rig.prefix +
                                  f'SIM:ec0:s{cfg["encoder_slave"]}:positionActual{cfg["encoder_channel"]}-RB')

    def healthy(self):
        self.rig.check_native_error(self.axis)
        return True

    def wait_off(self):
        expected_relay = 1 - self.query('EncPwrPol')
        # A polarity change keeps logical state=Off. Old raw/ready readbacks
        # can therefore satisfy the off predicate before the RT relay output
        # and its CA readback have updated. Require the physical output too.
        self.rig.wait(lambda: self.healthy() and self.state() == 1
                      and self.raw() == self.off_raw
                      and not self.rig.encoder_status(self.axis) & 4
                      and self.relay() == expected_relay,
                      'encoder off with matching relay polarity, invalid raw word and not-ready', 5)
        self.assertEqual(self.relay(), expected_relay)

    def restore(self):
        errors = self.rig.stop_all()
        if self.saved:
            self.rig.wait(lambda: self.rig.get(self.axis, '-EnaAct') == 0
                          and not self.rig.drive_status(self.axis) & 2,
                          'drive feedback off before restoring encoder configuration', 5)
            self.rig.wait(lambda: self.state() in (1, 4),
                          'relay off after amplifier feedback before restoring mode', 3)
            # Restore the ordinary plant supply before removing idle suppression.
            self.rig.plant.configure_encoder_power(self.axis)
            self.rig.wait(lambda: self.rig.encoder_status(self.axis) & 4,
                          'ordinary EL5042 supply restored before removing power mode', 3)
            self.config('EncPwrEnable', 0)
            self.config('EncPwrTimeout', max(self.saved['EncPwrTimeout'], self.query('EncPwrDelay')) + 1)
            for key in ('EncPwrDelay', 'EncPwrTimeout', 'EncPwrOffDelay', 'EncPwrPol',
                        'CntrlDeadband', 'CntrlDeadbandTime', 'AutoEnableTimeout',
                        'EnableAutoEnable', 'AutoDisableAfterTime', 'EnableAutoDisable'):
                self.config(key, self.saved[key])
            if hasattr(self, 'kp'): self.rig.put(self.axis, '-Ctrl-Kp', self.kp)
            self.rig.reset()
        self.config('SelectAxisEncConfig', self.previous, full=True)
        self.assertFalse(errors, 'STOP before restoring encoder power configuration: ' + str(errors))

    def stage(self, target, command=3):
        # Do not use stage_native: it explicitly enables before execute and
        # would hide whether the execute request itself wakes the encoder.
        self.rig.put(self.axis, '-ExeCmd', 0)
        for suffix, value in (('-MtnCmd', command), ('-MtnCmdData', 0),
                              ('-TgtPosCmd', target), ('-TgtVelCmd', .2)):
            self.rig.put(self.axis, suffix, value)

    def start(self, target, command=3):
        self.stage(target, command)
        self.rig.put(self.axis, '-ExeCmd', 1)
        self.rig.wait(lambda: self.healthy() and self.rig.get(self.axis, '-Busy') == 1,
                      'execute queues encoder power-up/motion', 4)

    def arrive(self, target):
        self.rig.wait_native_stopped(self.axis, target, timeout=12)
        self.rig.wait(lambda: self.healthy() and self.rig.get(self.axis, '-AtTarget') == 1,
                      'move reaches atTarget', 4)
        self.assertAlmostEqual(self.rig.plant.physical_position(self.axis), target, delta=.015)

    def dwell_then_off(self, delay):
        # CA observations have publication/poll latency; exact cycle timing is
        # checked by the standalone production suite. Keep 0.2 s margin here.
        began = time.monotonic()
        self.rig.assert_stays(lambda: self.healthy() and self.state() == 3
                              and self.rig.get(self.axis, '-AtTarget') == 1
                              and self.rig.get(self.axis, '-EnaAct') == 1,
                              'encoder remains powered for post-settling dwell', delay - .2)
        self.wait_off()
        self.assertGreaterEqual(time.monotonic() - began, delay - .2)
        self.assertEqual(self.rig.get(self.axis, '-EnaAct'), 1, 'encoder sleeps while drive holds enable')

class EncoderPowerTests(EncoderPowerCase):
    def cycle(self, delay, active_high=True):
        self.config('EncPwrOffDelay', delay)
        if not active_high:
            self.config('EncPwrPol', 0)
            self.rig.plant.configure_encoder_power(self.axis, active_high=False, startup_delay=.08)
            self.wait_off()
        self.start(.2)
        self.arrive(.2)
        self.dwell_then_off(delay)
        self.assertAlmostEqual(self.rig.get(self.axis, '-Enc02-PosAct'), .2, delta=.015,
                               msg='ECMC retains valid feedback despite raw EL5042 zero')
        self.rig.assert_stays(lambda: self.healthy() and self.raw() == 0
                              and self.rig.get(self.axis, '-Busy') == 0,
                              'idle raw zero never becomes a position/following-error fault', .3)
        self.config('EnableAutoEnable', 0)
        self.start(.1, command=2)
        self.arrive(.3)
        self.dwell_then_off(delay)

    def test_power_cycle_short_idle_delay(self): self.cycle(.6)
    def test_power_cycle_long_idle_delay(self): self.cycle(1.2)
    def test_active_low_relay(self): self.cycle(.8, active_high=False)

    def test_off_counter_wrap_words_do_not_add_turns(self):
        bits = int(self.query('EncBits'))
        self.assertGreater(bits, 0)
        self.assertLess(bits, 64, 'ECMC rollover counting applies to raw words below 64 bits')
        maximum = (1 << bits) - 1
        cfg = self.rig.profile['physical'][self.axis]
        self.config('EncPwrOffDelay', .6)
        self.start(.2)
        self.arrive(.2)
        self.dwell_then_off(.6)
        self.config('EnableAutoEnable', 0)
        for target in (.3, .2, .3):
            retained = self.rig.get(self.axis, '-Enc02-PosAct')
            # Verify this injected transition really exceeds ECMC's 0.7-span
            # rollover threshold; the usual ~5.65M -> zero transition does not.
            valid_raw = round((self.rig.plant.physical_position(self.axis) -
                               cfg['absolute_offset_mm']) * cfg['absolute_counts_per_mm'])
            self.assertGreater(maximum - valid_raw, .7 * maximum)
            for word in (maximum, 0, maximum):
                self.off_raw = word
                self.rig.plant.configure_encoder_power(self.axis, active_high=True,
                                                      startup_delay=.08, off_raw=word)
                self.wait_off()
                self.rig.assert_stays(lambda: self.healthy() and self.raw() == word
                                      and abs(self.rig.get(self.axis, '-Enc02-PosAct') - retained) < .001,
                                      'invalid wrap words cannot change retained position/turn count', .15)
            # A fresh, small REL request must land correctly after each wake,
            # without homing/resetting the reference between power cycles.
            delta = .1 if target == .3 else -.1
            self.start(delta, command=2)
            self.arrive(target)
            self.assertAlmostEqual(self.rig.get(self.axis, '-Enc02-PosAct'), target, delta=.015,
                                   msg='power cycle must not add or remove a raw-counter turn')
            self.dwell_then_off(.6)

    def test_wake_position_jump_exceeds_five_at_target_tolerances(self):
        if self.loop != 'closed': self.skipTest('wake jump requires primary EL5042 feedback')
        tolerance = self.query('MonAtTargetTol')
        self.assertGreater(tolerance, 0)
        self.config('EncPwrOffDelay', .8)
        self.start(.15)
        self.arrive(.15)
        self.dwell_then_off(.8)
        self.config('EnableAutoEnable', 0)
        for sign in (1, -1):
            retained = self.rig.get(self.axis, '-Enc02-PosAct')
            physical = self.rig.plant.physical_position(self.axis)
            bias = sign * 6 * tolerance
            fresh = physical + bias
            self.assertGreater(abs(fresh - retained), 5 * tolerance)
            self.rig.plant.inject(self.axis, encoder_bias_mm=bias)
            self.rig.wait(lambda: abs(self.rig.plant.snapshot()['blades'][self.axis]['encoder_mm']
                                     - fresh) < .001,
                          'encoder measurement changed while its power is off', 3)
            self.rig.assert_stays(lambda: self.healthy() and self.state() == 1
                                  and self.raw() == 0
                                  and abs(self.rig.get(self.axis, '-Enc02-PosAct') - retained) < .001,
                                  'off-state feedback stays retained despite a greater-than-5-tolerance jump', .2)
            relative = sign * 4 * tolerance
            self.start(relative, command=2)
            self.rig.assert_stays(lambda: self.healthy() and self.state() == 2
                                  and abs(self.rig.plant.physical_position(self.axis) - physical) < .002,
                                  'pending relative move waits for fresh shifted feedback', .15)
            expected = fresh + relative
            self.rig.wait_native_stopped(self.axis, expected, timeout=12)
            self.rig.wait(lambda: self.healthy() and self.rig.get(self.axis, '-AtTarget') == 1,
                          'relative move settles using shifted encoder reference', 4)
            self.assertAlmostEqual(self.rig.get(self.axis, '-Enc02-PosAct'), expected, delta=.005,
                                   msg='REL target must use wake position, not retained position')
            self.assertAlmostEqual(self.rig.plant.physical_position(self.axis), physical + relative,
                                   delta=.015, msg='measurement jump must not cause a compensating physical move')
            self.dwell_then_off(.8)
        # The case finishes powered off, so ordinary teardown can remove the
        # measurement bias before restoring continuously powered feedback.

    def test_motor_request_auto_enables_after_encoder_ready(self):
        # Ordinary motor puts, bypassing Rig.start_move's explicit enable.
        self.rig.put(self.axis, '.VAL', .25)
        self.rig.wait(lambda: self.healthy() and self.rig.get(self.axis, '-Busy') == 1,
                      'motor target queues automatic power-up', 4)
        self.arrive(.25)
        # The encoder timer starts at native settling, not the next motor poll.
        # Checking slow DMOV/MOVN first would consume part of the dwell and
        # incorrectly require another full interval after the motor catches up.
        self.dwell_then_off(1)
        self.rig.wait(lambda: self.rig.get(self.axis, '.DMOV') == 1
                      and self.rig.get(self.axis, '.MOVN') == 0,
                      'motor flags settle after powered move', 4)

    def test_power_up_delay_even_when_ready_arrives_early(self):
        self.config('EncPwrDelay', .7)
        self.start(.2)
        self.rig.wait(lambda: self.rig.encoder_status(self.axis) & 4,
                      'plant ready precedes minimum configured warmup', 3)
        before = self.rig.plant.physical_position(self.axis)
        self.rig.assert_stays(lambda: self.healthy() and self.state() == 2
                              and abs(self.rig.plant.physical_position(self.axis) - before) < .002,
                              'early ready cannot bypass configured power-up delay', .25)
        self.arrive(.2)

    def test_late_ready_holds_motion_after_minimum_delay(self):
        self.rig.plant.configure_encoder_power(self.axis, active_high=True, startup_delay=.8)
        # Preparation returns within its motion tolerance, not to an exact
        # physical zero. Detect motion from the position before execute.
        before = self.rig.plant.physical_position(self.axis)
        self.start(.2)
        self.rig.assert_stays(lambda: self.healthy() and self.state() == 2
                              and self.rig.get(self.axis, '-EnaAct') == 0
                              and abs(self.rig.plant.physical_position(self.axis) - before) < .002,
                              'ready input must qualify even after minimum delay expires', .45)
        self.arrive(.2)

    def test_missing_ready_times_out(self):
        self.config('EncPwrOffDelay', .6)
        self.start(.2)
        self.arrive(.2)
        self.dwell_then_off(.6)
        self.config('EncPwrTimeout', .8)
        self.rig.plant.inject(self.axis, ready=False)
        self.start(.4)
        self.rig.fault_stopped(self.axis, 0x1441d, timeout=5)
        self.assertEqual(self.state(), 4)
        self.assertAlmostEqual(self.rig.plant.physical_position(self.axis), .2, delta=.015)

    def test_stop_cancels_power_up(self):
        self.config('EncPwrDelay', .7)
        # Preparation settles within the fixture's position tolerance; the
        # physical starting point need not be exactly zero. Detect displacement
        # from that point, including any motion before STOP is acknowledged.
        before = self.rig.plant.physical_position(self.axis)
        self.start(.2)
        self.rig.wait(lambda: self.state() == 2, 'warmup before STOP', 3)
        self.rig.put(self.axis, '-StpCmd', 1)
        self.rig.wait(lambda: self.healthy()
                      and self.rig.get(self.axis, '-Busy') == 0
                      and self.rig.get(self.axis, '-ExeCmd-RB') == 0,
                      'cancelled request idle with Execute cleared', 3)
        self.rig.assert_stays(lambda: self.healthy()
                              and self.rig.get(self.axis, '-Busy') == 0
                              and self.rig.get(self.axis, '-ExeCmd-RB') == 0
                              and abs(self.rig.plant.physical_position(self.axis) - before) < .002,
                              'STOP cancels pending move rather than replaying after readiness', 1)

    def disturbance(self, bias, deadband):
        if self.loop != 'closed': self.skipTest('disturbance requires primary EL5042 feedback')
        self.config('CntrlDeadband', deadband)
        self.config('CntrlDeadbandTime', 100)
        # Feedforward completes the move; zero Kp holds a deterministic injected
        # measurement bias rather than physically correcting it away.
        self.rig.put(self.axis, '-Ctrl-Kp', 0)
        self.start(.2)
        self.arrive(.2)
        self.rig.plant.inject(self.axis, encoder_bias_mm=bias)
        expected = 0 if bias > .01 else 1
        self.rig.wait(lambda: self.rig.get(self.axis, '-AtTarget') == expected,
                      'disturbance reaches requested target-band condition', 3)
        self.rig.assert_stays(lambda: self.healthy() and self.state() == 3,
                              'unsettled feedback prevents encoder power-off', 1.2)
        self.rig.plant.inject(self.axis, encoder_bias_mm=0)
        self.rig.wait(lambda: self.rig.get(self.axis, '-AtTarget') == 1,
                      'feedback settles again', 3)
        # The tighter deadband also has its own 100-cycle qualification time.
        self.dwell_then_off(1)

    def test_at_target_loss_restarts_idle_delay(self): self.disturbance(.014, 0)
    def test_tighter_deadband_holds_encoder_on(self): self.disturbance(.004, .001)

    def off_state_diagnostics(self, error=False, warning=False):
        self.config('EncPwrDelay', 1.2)
        self.config('EncPwrOffDelay', .6)
        self.start(.15)
        self.arrive(.15)
        self.dwell_then_off(.6)
        previous_warning = self.rig.get(self.axis, '-WrnId')
        bits = (2 if error else 0) | (1 if warning else 0)
        self.rig.plant.inject(self.axis, encoder_error=error, encoder_warning=warning)
        try:
            self.rig.wait(lambda: self.rig.encoder_status(self.axis) == bits,
                          'EL5042 reports injected diagnostics while unpowered', 3)

            def no_alarm():
                return (self.healthy() and self.rig.get(self.axis, '-Enc02-ErrId') == 0
                        and self.rig.get(self.axis, '-WrnId') == previous_warning
                        and self.rig.get(self.axis, '-Enc02-ErrId.SEVR') == 0
                        and self.rig.get(self.axis, '-Enc02-PwrState.SEVR') == 0)

            self.rig.assert_stays(lambda: no_alarm() and self.state() == 1
                                  and self.rig.encoder_status(self.axis) == bits,
                                  'off-state hardware error/warning must not alarm ECMC', .3)
            # Preparation settles within its motion tolerance, not necessarily
            # at the exact nominal target. Detect motion from the position at
            # wake-up rather than treating that harmless offset as motion.
            before = self.rig.plant.physical_position(self.axis)
            self.start(.25)
            self.rig.wait(lambda: self.state() == 2, 'encoder warm-up starts', 3)
            self.rig.assert_stays(lambda: no_alarm() and self.state() == 2
                                  and (self.rig.encoder_status(self.axis) & 3) == bits
                                  and abs(self.rig.plant.physical_position(self.axis)-before) < .002,
                                  'diagnostics remain suppressed during warm-up; motion waits', .3)
        finally:
            self.rig.plant.inject(self.axis, encoder_error=False, encoder_warning=False)
        self.arrive(.25)
        self.assertEqual(self.rig.get(self.axis, '-Enc02-ErrId'), 0)
        self.dwell_then_off(.6)

    def test_encoder_error_while_powered_off(self): self.off_state_diagnostics(error=True)
    def test_encoder_warning_while_powered_off(self): self.off_state_diagnostics(warning=True)
    def test_encoder_error_and_warning_while_powered_off(self):
        self.off_state_diagnostics(error=True, warning=True)

    def test_off_state_error_persisting_after_wake_faults(self):
        if self.loop != 'closed':
            self.skipTest('EL5042 hardware error propagation requires that encoder to be primary')
        self.config('EncPwrDelay', .8)
        self.config('EncPwrOffDelay', .6)
        self.start(.15)
        self.arrive(.15)
        self.dwell_then_off(.6)
        self.rig.plant.inject(self.axis, encoder_error=True)
        try:
            self.rig.wait(lambda: self.rig.encoder_status(self.axis) == 2,
                          'hardware error asserted before wake', 3)
            self.rig.assert_stays(lambda: self.healthy() and self.state() == 1,
                                  'intentional power-off suppresses hardware error', .2)
            self.start(.25)
            self.rig.fault_stopped(self.axis, 0x14410, timeout=5)
            self.assertEqual(self.state(), 4)
            self.assertAlmostEqual(self.rig.plant.physical_position(self.axis), .15, delta=.002,
                                   msg='persistent error must reject the queued move at wake-up')
        finally:
            self.rig.plant.inject(self.axis, encoder_error=False)
