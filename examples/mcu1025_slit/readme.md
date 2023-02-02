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
epicsEnvSet("ECMC_AXIS_EXPR_LINE_3",           "static.ilFwd1:=((ax1.enc.actpos + ax2.enc.actpos/2) < ax4.mon.highsoftlim-$(SOFT_OFFSET=2)) or not(ax4.mon.highsoftlimenable)|")
epicsEnvSet("ECMC_AXIS_EXPR_LINE_4",           "static.ilFwd2:=((ax1.enc.actpos - ax2.enc.actpos/2) < ax3.mon.highsoftlim-$(SOFT_OFFSET=2)) or not(ax3.mon.highsoftlimenable)|")
epicsEnvSet("ECMC_AXIS_EXPR_LINE_5",           "static.ilBwd1:=((ax1.enc.actpos + ax2.enc.actpos/2) > ax4.mon.lowsoftlim+$(SOFT_OFFSET=2)) or not(ax4.mon.lowsoftlimenable)|")
epicsEnvSet("ECMC_AXIS_EXPR_LINE_6",           "static.ilBwd2:=((ax1.enc.actpos - ax2.enc.actpos/2) > ax3.mon.lowsoftlim+$(SOFT_OFFSET=2)) or not(ax3.mon.lowsoftlimenable)|")
epicsEnvSet("ECMC_AXIS_EXPR_LINE_7",           "ax1.mon.ilockfwd:=ax3.mon.highlim and ax4.mon.highlim and static.ilFwd1 and static.ilFwd2|")
epicsEnvSet("ECMC_AXIS_EXPR_LINE_8",           "ax1.mon.ilockbwd:=ax3.mon.lowlim and ax4.mon.lowlim and static.ilBwd1 and static.ilBwd2|")
```

### Gap
```
epicsEnvSet("ECMC_AXIS_EXPR_LINE_3",           "static.ilFwd1:=((ax1.enc.actpos + ax2.enc.actpos/2) < ax4.mon.highsoftlim-$(SOFT_OFFSET=2)) or not(ax4.mon.highsoftlimenable)|")
epicsEnvSet("ECMC_AXIS_EXPR_LINE_4",           "static.ilFwd2:=((ax1.enc.actpos - ax2.enc.actpos/2) > ax3.mon.lowsoftlim+$(SOFT_OFFSET=2)) or not(ax3.mon.lowsoftlimenable)|")
epicsEnvSet("ECMC_AXIS_EXPR_LINE_5",           "static.ilBwd1:=((ax1.enc.actpos + ax2.enc.actpos/2) > ax4.mon.lowsoftlim+$(SOFT_OFFSET=2)) or not(ax4.mon.lowsoftlimenable)|")
epicsEnvSet("ECMC_AXIS_EXPR_LINE_6",           "static.ilBwd2:=((ax1.enc.actpos - ax2.enc.actpos/2) < ax3.mon.highsoftlim-$(SOFT_OFFSET=2)) or not(ax3.mon.highsoftlimenable)|")
epicsEnvSet("ECMC_AXIS_EXPR_LINE_7",           "ax2.mon.ilockfwd:=ax3.mon.highlim and ax4.mon.highlim and static.ilFwd1 and static.ilFwd2|")
epicsEnvSet("ECMC_AXIS_EXPR_LINE_8",           "ax2.mon.ilockbwd:=ax3.mon.lowlim and ax4.mon.lowlim and static.ilBwd1 and static.ilBwd2|")
```

# TODO
Consider using the softlim of virt axes instead of plc-interlock
```
ax1.mon.highsoftlim
ax1.mon.lowsoftlim
ax2.mon.highsoftlim
ax2.mon.lowsoftlim
```
