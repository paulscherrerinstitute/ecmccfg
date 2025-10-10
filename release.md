# 11.0.0

## Breaking changes

### Redefinition of axis MtnCmd (mbbo string and value more consistent)
Always write a string to this PV.

New definition:
```
record(mbbo,  "${P}${AXIS_NAME}-MtnCmd"){
  info(asyn:READBACK,"1")
  field(DESC, "${AXIS_NAME}: Motion Command")
  field(DTYP, "asynInt32")
  field(OUT,  "@asyn($(PORT),$(ADDR),$(TIMEOUT))T_SMP_MS=$(T_SMP_MS=1000)/TYPE=asynInt32/ax$(AXIS_NO).command?")
  field(ZRST, "NO_COMMAND")
  field(ZRVL, -1)
  field(ONST, "VEL")
  field(ONVL, 1)
  field(TWST, "REL")
  field(TWVL, 2)
  field(THST, "ABS")
  field(THVL, 3)
  field(NIST, "PVT_INTERN")
  field(NIVL, 9)
  field(TEST, "HOME")
  field(TEVL, 10)
  field(VAL,  0)
}
```
Old definition:
```
record(mbbo,  "${P}${AXIS_NAME}-MtnCmd"){
  field(DESC, "${AXIS_NAME}: Motion Command")
  field(DTYP, "asynInt32")
  field(OUT,  "@asyn($(PORT),$(ADDR),$(TIMEOUT))T_SMP_MS=$(T_SMP_MS=1000)/TYPE=asynInt32/ax$(AXIS_NO).command?")
  field(ZRST, "NO_COMMAND")
  field(ZRVL, 0)
  field(ONST, "VEL")
  field(ONVL, 1)
  field(TWST, "REL")
  field(TWVL, 2)
  field(THST, "ABS")
  field(THVL, 3)
  field(FVST, "PVT_REL")
  field(FVVL, 8)
  field(SXST, "PVT_ABS")
  field(SXVL, 9)
  field(SVST, "HOME")
  field(SVVL, 10)
  field(VAL,  0)
}
```

# 10.0.10
* Fix encoder filter handling

# 9.6.7
* Write target.enable also if false
* Add support for encoder calibration by lookup tables

# 9.6.6
* Add wrapper to ecmccomp/applyComponent.cmd (automatically requires ecmccomp)
* Cleanup in PSI best practices.

# 9.6.5
* Unset PLC_MACROS after loadPLCFile.cmd and loadPLCLib.cmd
* Minor updates to manual
* Update ipos4808 cfgs

# Previous versions
See https://github.com/epics-modules/ecmc/blob/master/RELEASE.md
and https://github.com/paulscherrerinstitute/ecmccfg/blob/master/Changelog.adoc
