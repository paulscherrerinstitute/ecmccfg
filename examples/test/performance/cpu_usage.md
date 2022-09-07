# CPU usage

## HW


* Black intel NUC:
```
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                4
On-line CPU(s) list:   0-3
Thread(s) per core:    1
Core(s) per socket:    4
Socket(s):             1
NUMA node(s):          1
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 142
Model name:            Intel(R) Core(TM) i7-8650U CPU @ 1.90GHz
Stepping:              10
CPU MHz:               1900.000
CPU max MHz:           2101.0000
CPU min MHz:           400.0000
BogoMIPS:              4224.00
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              8192K
NUMA node0 CPU(s):     0-3
```
* mcu1025 crate

## SW

* EPICS 7.0.6.1
* require 4.0.0

## LOAD
ecmc running 2 axis in forward back seq


Axis 1:
```
python ecmcForwbackwSeqAxis.py IOC_TEST:Axis1 10 60 10

```

Axis 2:
```
python ecmcForwbackwSeqAxis.py IOC_TEST:Axis2 -10 10 10

```

# ecmc extra ecnoder version

ecmc running 2 axis in forward back seq with one extra encoder on axis 1
top -H:
```  
PID USER      PR  NI    VIRT    RES    SHR S %CPU %MEM     TIME+ COMMAND
13633 anderss+ -72   0 2194928 215988 125176 S  2.3  1.3   1:30.44 ecmc_rt
```

# ecmc 8.0.0
ecmc running 2 axis in forward back seq with one extra encoder on axis 1

top -H:
```
PID USER      PR  NI    VIRT    RES    SHR S %CPU %MEM     TIME+ COMMAND
18657 anderss+ -72   0 2192384 212636 124968 S  2.3  1.3   0:01.59 ecmc_rt      

```

# ecmc 7.0.1

top -H:
```
PID USER      PR  NI    VIRT    RES    SHR S %CPU %MEM     TIME+ COMMAND
19455 anderss+ -72   0 2124156 212148 124736 S  2.3  1.3   0:01.75 ecmc_rt      
```