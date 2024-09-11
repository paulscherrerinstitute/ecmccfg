+++  
title = "axis PLC"
weight = 26
chapter = false  
+++

## Introduction
Each axis can have a native PLC.
This PLC can be e.g. used for interlocking or synchronisation.
The axis PLC is part of the [yaml](axisyaml) config.
The code can be provided [inline](#inline) or in a separate [file](#file).

### inline
```yaml
plc:
  enable: yes
  externalCommands: yes
  code:
    - ax3.enc.actpos:=(ax1.enc.actpos+ax2.enc.actpos)/2
  filter:
    velocity:
      enable: yes
      size: 100
    trajectory:
      enable: yes
      size: 100
```

### file
```yaml
plc:
  enable: yes
  externalCommands: yes
  file: cfg/heave.plc
  filter:
    velocity:
      enable: yes
      size: 100
    trajectory:
      enable: yes
      size: 100
```

This is the respective plc file
```yaml
ax${AXIS_NO}.enc.actpos:=(ax{{ var.ty1 }}.enc.actpos+ax{{ var.ty2 }}.enc.actpos)/2;
```
Note the mixed use to MACROs `${AXIS_NO}` and local variables `{{ var.ty1 }}` to boost flexibility.
