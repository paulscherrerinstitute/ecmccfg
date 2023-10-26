# check

## drive

```yaml
  # ==> Cfg.SetAxisDrvType(int axis_no, int type);
  type: 1   # Stepper: 0 | DS402: 1 (DS402 = servos and adv stepper drives)
  # --> required: no, type: int, default: 0, allowed: [0, 1]
```

## encoder

### mask
The defintion type is `str`, but the iocsh-command expects `int`, make sure the conversion works.
```yaml
  # ==> Cfg.SetAxisEncRawMask(int axis_no, int rawMask);
  mask: '0xfff0'  # shift raw value by 4 bits and mask with 0xfff
  # --> required: no, type: str
```

## homing
The homing procedure it handed to the EPICS templates
