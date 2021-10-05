# Test of modulo motion

Two parameters are used to define modulo behaviour:
* ECMC_MOD_RANGE 
* ECMC_MOD_TYPE

## ECMC_MOD_RANGE
Allowed range for setpoint

## ECMC_MOD_TYPE
For positioning and ECMC_MOD_RANGE > 0: 
* 0 = Normal 
* 1 = Always Fwd
* 2 = Always Bwd
* 3 = Closest Distance

Example: Range 0..10, Closets distance.
```
epicsEnvSet("ECMC_MOD_RANGE" ,            "10")                         # Modulo range (traj setpoints and encoder values will be in range 0..ECMC_MOD_RANGE)
epicsEnvSet("ECMC_MOD_TYPE",              "3")                          # For positioning and MOD_RANGE
```
