# Actuate Switches over ethercat

The switches change state on rising edge of the $(P):mxsyyy-CH0z-Ctrl-Swtch pvs:

```
c6025a-04> dbpf c6025a-04:m0s019-CH01-Ctrl-Swtch 0
DBF_STRING:         "Zero"    
c6025a-04> dbpf c6025a-04:m0s019-CH01-Ctrl-Swtch 1
DBF_STRING:         "One"     
```

NOTE: For most installations at PSI the CH02 switch breaks power to the whole node (feeds EL1100). In order to recover the lower physical button on the EL9227-5500 needs to be pressed.

