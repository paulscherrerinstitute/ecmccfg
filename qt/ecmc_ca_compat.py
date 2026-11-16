"""Legacy CaPython first, with a small PyEpics adapter for overview readers.

Only the epicsPV(name).getw() and ca.ca_nothing interfaces used by these
scripts are adapted. Existing CaPython installations are used unchanged.
"""
from types import SimpleNamespace


def load_backend():
    try:
        import ca
        import epicsPV
    except ModuleNotFoundError as error:
        # Do not conceal broken dependencies inside an installed legacy module.
        if error.name not in ('ca', 'epicsPV'):
            raise
    else:
        return ca, epicsPV

    try:
        from epics import PV
    except ModuleNotFoundError as error:
        if error.name != 'epics':
            raise
        raise ModuleNotFoundError(
            'These overview scripts need legacy ca/epicsPV or PyEpics. '
            'Install pyepics in the Python environment running this script.'
        ) from error

    class CaNothing(RuntimeError):
        pass

    class EpicsPV:
        def __init__(self, name):
            self.name = name

        def getw(self):
            pv = PV(self.name)
            try:
                if not pv.wait_for_connection(timeout=3):
                    raise CaNothing('Channel Access connection timeout: ' + self.name)
                # EPICS long strings use CHAR waveforms; preserve scalar numbers.
                as_string = 'char' in str(pv.type).lower() and pv.count > 1
                value = pv.get(timeout=3, use_monitor=False, as_string=as_string)
                if value is None:
                    raise CaNothing('Channel Access read timeout: ' + self.name)
                return value
            finally:
                pv.disconnect()

    return SimpleNamespace(ca_nothing=CaNothing), SimpleNamespace(epicsPV=EpicsPV)


ca, epicsPV = load_backend()
