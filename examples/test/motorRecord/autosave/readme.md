# Autosave and restore of psotion

# Motor ESS 7.0.4
For version ESS-7.0.4 of motor is was found that you need to also add the MFLG field to autosave.

So the req file should look like this:
```
# double
$(P):Axis1.DVAL
$(P):Axis1.MFLG
```

# Toubleshooting

## RSTM
The RSTM field needs to be "NearZero" (should be by default):

```
mcag-trgt-muts--24324 > dbgf IOC_TEST:Axis1.RSTM
DBF_STRING:         "NearZero"       
```
