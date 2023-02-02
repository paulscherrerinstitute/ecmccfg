# Simple demo of a 2 axes slit system

## Hardware
This demo is based on a ESS MCU1025 2 axis crate

## Axes

1. Slit center position (virt)
2. Slit gap/opening (virt)
3. Right blade (physical)
4. Left blade (physical)

## Softlimits and interlocks
Soft limits of the virtual axes (gap and center) are calculated dynamically in plc code based on the softlimits set on the physical axes (left and right).
These softlimits are however calculated and set slightly more narrow the needed, $(SOFT_OFFSET=2), in order to not trip the softlimits of the physical axes.

This is the coordinate system (positive in left direction):
```
    hardlimit+   softlim+         left        right          softlim-  hardlimít-
      |            |               |            |              |         |
                                    <----gap--->
                                          |
                                        center
```

### Center
```
# Dynamic softlimits

# High softlimit is the MIN of SW_FW_BASED_ON_AX3 and SW_FW_BASED_ON_AX4
epicsEnvSet(SW_FW_BASED_ON_AX3,"ax3.mon.highsoftlim + ax2.enc.actpos/2 - $(SOFT_OFFSET=2)")
epicsEnvSet(SW_FW_BASED_ON_AX4,"ax4.mon.highsoftlim - ax2.enc.actpos/2 - $(SOFT_OFFSET=2)")
epicsEnvSet("ECMC_AXIS_EXPR_LINE_4",           "ax1.mon.highsoftlim:=min(${SW_FW_BASED_ON_AX4},${SW_FW_BASED_ON_AX3})|")

# Both softlimits of the physical axis must be enabled in order for this code to work
epicsEnvSet("ECMC_AXIS_EXPR_LINE_5",           "ax1.mon.highsoftlimenable:=ax4.mon.highsoftlimenable and ax3.mon.highsoftlimenable|")

# Low softlimit is the MAX of SW_BW_BASED_ON_AX3 and SW_BW_BASED_ON_AX4
epicsEnvSet(SW_BW_BASED_ON_AX3,"ax3.mon.lowsoftlim - ax2.enc.actpos/2 + $(SOFT_OFFSET=2)")
epicsEnvSet(SW_BW_BASED_ON_AX4,"ax4.mon.lowsoftlim + ax2.enc.actpos/2 + $(SOFT_OFFSET=2)")
epicsEnvSet("ECMC_AXIS_EXPR_LINE_6",           "ax1.mon.lowsoftlim:=max(${SW_BW_BASED_ON_AX3},${SW_BW_BASED_ON_AX4})|")

# Both softlimits of the physical axis must be enabled in order for this code to work
epicsEnvSet("ECMC_AXIS_EXPR_LINE_7",           "ax1.mon.lowsoftlimenable:=ax4.mon.lowsoftlimenable and ax3.mon.lowsoftlimenable|")
```

### Gap
```
# Dynamic softlimits

# High softlimit is the MIN of SW_FW_BASED_ON_AX3 and SW_FW_BASED_ON_AX4, basically 2 times the minimum distance to softlimit
epicsEnvSet(SW_FW_BASED_ON_AX3,"(ax1.enc.actpos - ax3.mon.lowsoftlim)* 2 - $(SOFT_OFFSET=2)")
epicsEnvSet(SW_FW_BASED_ON_AX4,"(ax4.mon.highsoftlim - ax1.enc.actpos)* 2 - $(SOFT_OFFSET=2)")
epicsEnvSet("ECMC_AXIS_EXPR_LINE_4",           "ax2.mon.highsoftlim:=min(${SW_FW_BASED_ON_AX4},${SW_FW_BASED_ON_AX3})|")

# Both softlimits of the physical axis must be enabled in order for this code to work
epicsEnvSet("ECMC_AXIS_EXPR_LINE_5",           "ax2.mon.highsoftlimenable:=ax4.mon.highsoftlimenable and ax3.mon.highsoftlimenable|")

# Low softlimit is the MAX of SW_BW_BASED_ON_AX3 and SW_BW_BASED_ON_AX4
epicsEnvSet(SW_BW_BASED_ON_AX3,"(ax1.enc.actpos - ax3.mon.highsoftlim) * 2 + $(SOFT_OFFSET=2)")
epicsEnvSet(SW_BW_BASED_ON_AX4,"(ax4.mon.lowsoftlim - ax1.enc.actpos) *2 + $(SOFT_OFFSET=2)")
epicsEnvSet("ECMC_AXIS_EXPR_LINE_6",           "ax2.mon.lowsoftlim:=max(${SW_BW_BASED_ON_AX3},${SW_BW_BASED_ON_AX4})|")

# Both softlimits of the physical axis must be enabled in order for this code to work
epicsEnvSet("ECMC_AXIS_EXPR_LINE_7",           "ax2.mon.lowsoftlimenable:=ax4.mon.lowsoftlimenable and ax3.mon.lowsoftlimenable|")
```

# NOTES
The subdir "cfg_plc_il" contains code that is doing the same thing but with plc interlock instead of softlimits. Then no softlimit alarm will be raised...
