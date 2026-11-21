"""Manual raw encoder field simulation; no implied mechanical coupling."""
import re

import manual


def supported(hardware):
    return bool(re.fullmatch(r'EL(?:5021|5042|5101|5102)(?:[-_].*)?', hardware))


def channel_count(hardware):
    return 1 if hardware.startswith(('EL5021', 'EL5101')) else 2


class Terminal(manual.Fields):
    def __init__(self, prefix, slave, timeout, pv_factory):
        base = f'{prefix}ec{slave.master}:s{slave.position}:'
        names = []
        for channel in range(1, channel_count(slave.hardware) + 1):
            for field in ('encoderControl', 'encoderValue', 'encoderStatus', 'positionActual',
                          'encoderLatchPostion', 'encoderLatchPosition', 'encoderFrequency', 'encoderPeriod'):
                names.append(base + field + f'{channel:02}')
        names.append(base + 'nextSyncTime')
        super().__init__(names, timeout, pv_factory)
        self.direction = 'encoder field'
        self.base, self.hardware = base, slave.hardware

    def connect(self):
        super().connect()
        for channel in range(1, channel_count(self.hardware) + 1):
            if self.base + f'encoderStatus{channel:02}' not in self.pvs:
                raise RuntimeError(f'missing encoder status for channel {channel}')
        self.notice = ''
        if not any('positionActual' in name for name in self.pvs):
            self.notice = 'no scalar position PV; oversampling arrays are not modeled'
