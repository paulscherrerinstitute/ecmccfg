# ecmc motion system test report

* Data file   : /home/dev/tempdata/data.log
* Date        : Wed Nov 10 13:45:57 CET 2021
* Author      : dev


# Gear Ratios
From | To | Ratio [] | Offset [mm] | Data count [] | Residual error [mm²]
--- | --- | --- | --- | --- | --- |
Target Position | Resolver | -.01465 | 491650.13803 | 50.00000 | .04738638
Target Position | Reference | .99829 | 11.83005 | 50.00000 | .03585847

# ISO 230-2 motion test

## Configuration

Setting | Value
--- | --- |
Data file | sys.stdin
Reference position source | IOC_TEST:m0s012-Enc01-PosAct
Target position source | IOC_TEST:Axis1-PosSet
Test number source | IOC_TEST:TestNumber
Position count | 5 (i=1..5)
Cycle count |5 (j=1..5)
Unit | mm


## Input data

### Data forward direction

i = Position index []

j = Cycle index []

tgt_pos(i) = Target position at position i [mm]

ref_pos(i,j) = Reference position at position i and cycle j [mm]


i |tgt_pos(i) [mm]|ref_pos(i,1) [mm]|ref_pos(i,2) [mm]|ref_pos(i,3) [mm]|ref_pos(i,4) [mm]|ref_pos(i,5) [mm]|
--- |--- |--- |--- |--- |--- |--- |
1|15.0|15.01111|15.01172|15.01315|15.01457|15.01152|
2|25.2|25.19903|25.19964|25.20575|25.20555|25.20596|
3|35.4|35.3729|35.36882|35.3676|35.36679|35.36618|
4|45.6|45.58953|45.58994|45.59218|45.59096|45.59075|
5|55.8|55.83712|55.83977|55.84751|55.8469|55.84486|

### Data backward direction

i = Position index []

j = Cycle index []

tgt_pos(i) = Target position at position i [mm]

ref_pos(i,j) = Reference position at position i and cycle j [mm]

i |tgt_pos(i) [mm]|ref_pos(i,1) [mm]|ref_pos(i,2) [mm]|ref_pos(i,3) [mm]|ref_pos(i,4) [mm]|ref_pos(i,5) [mm]|
--- |--- |--- |--- |--- |--- |--- |
1|15.0|15.09318|14.97934|14.97955|14.97812|14.97792|
2|25.2|25.26277|25.21206|25.2141|25.21655|25.21553|
3|35.4|35.38104|35.37758|35.37758|35.37656|35.37901|
4|45.6|45.57446|45.57976|45.57711|45.57792|45.58118|
5|55.8|55.79476|55.80169|55.80046|55.80107|55.80087|


## ISO230-2 calculations:

### Positioning deviation and reversal error

#### Positioning deviation forward direction (unidirectional)

x(i,j)   = Position deviation at position i, cycle j (reference position - target position) [mm]

x_avg(i) = Mean unidirectional positioning deviation at a position [mm]

i |x(i,1) [mm]|x(i,2) [mm]|x(i,3) [mm]|x(i,4) [mm]|x(i,5) [mm]|x_avg(i) [mm]|
--- |--- |--- |--- |--- |--- |--- |
1|0.01111|0.01172|0.01315|0.01457|0.01152|0.01242|
2|-0.00097|-0.00036|0.00575|0.00555|0.00596|0.00319|
3|-0.0271|-0.03118|-0.0324|-0.03321|-0.03382|-0.03154|
4|-0.01047|-0.01006|-0.00782|-0.00904|-0.00925|-0.00933|
5|0.03712|0.03977|0.04751|0.0469|0.04486|0.04323|

#### Positioning deviation backward direction (unidirectional)

x(i,j)   = Position deviation at position i, cycle j (reference position - target position) [mm]

x_avg(i) = Mean unidirectional positioning deviation at a position [mm]

i |x(i,1) [mm]|x(i,2) [mm]|x(i,3) [mm]|x(i,4) [mm]|x(i,5) [mm]|x_avg(i) [mm]|
--- |--- |--- |--- |--- |--- |--- |
1|0.09318|-0.02066|-0.02045|-0.02188|-0.02208|0.00162|
2|0.06277|0.01206|0.0141|0.01655|0.01553|0.0242|
3|-0.01896|-0.02242|-0.02242|-0.02344|-0.02099|-0.02164|
4|-0.02554|-0.02024|-0.02289|-0.02208|-0.01882|-0.02191|
5|-0.00524|0.00169|0.00046|0.00107|0.00087|-0.00023|

#### Positioning deviation bi-directional

x_avg(i) = Mean bi-directional positioning deviation at a position [mm]

B(i)     = Reversal error at a position [mm]

i |x_avg(i) [mm]|B(i) [mm]|
--- |--- |--- |
1|0.00702|0.01079|
2|0.01369|-0.02102|
3|-0.02659|-0.0099|
4|-0.01562|0.01259|
5|0.0215|0.04346|

B_avg = Axis avg. reversal error [mm]

B_avg = 0.00718 [mm]

**B = Axis reversal error [mm]**

**B = 0.04346 [mm]**

### Repeatability

S_fwd(i) = Forward estimator for unidirectional axis positiong repeatability at a position [mm]

S_bwd(i) = Backward estimator for unidirectional axis positiong repeatability at a position [mm]

R_fwd(i) = Forward unidirectional positioning repeatability at a position [mm]

R_bwd(i) = Backward unidirectional positioning repeatability at a position [mm]

R(i) = Bi-directional position repeatability at a position [mm]

i |S_fwd(i) [mm]|S_bwd(i) [mm]|R_fwd(i) [mm]|R_bwd(i) [mm]|R(i) [mm]|
--- |--- |--- |--- |--- |--- |
1|0.00143|0.05119|0.00572|0.20476|0.20476|
2|0.00352|0.02163|0.01409|0.08651|0.08651|
3|0.00267|0.00174|0.01069|0.00695|0.01872|
4|0.00102|0.00257|0.0041|0.01029|0.01978|
5|0.00457|0.00284|0.0183|0.01134|0.05828|

R_fwd = Forward unidirectional positioning repeatability of an axis (max(R_fwd(i))) [mm]

R_fwd = 0.0183 [mm]

R_bwd = Backward unidirectional positioning repeatability of an axis (max(R_bwd(i))) [mm]

R_bwd = 0.20476 [mm]

**R = Bi-directional positioning repeatability of an axis (max(R_fwd,R_bwd)) [mm]**

**R = 0.20476 [mm]**

### Positioning Error

E_fwd = Forward unidirectional system positioning error of an axis [mm]

E_fwd = 0.07477 [mm]

E_bwd = Backward unidirectional system positioning error of an axis [mm]

E_bwd = 0.04612 [mm]

**E = Bi-directional system positioning error of an axis [mm]**

**E = 0.06514 [mm]**

**M = Mean bi-directional system positioning error of an axis [mm]**

**M = 0.04809 [mm]**

### Accuracy

A_fwd = Forward unidirectional accuracy of an axis [mm]

A_fwd = 0.08927 [mm]

A_bwd = Backward unidirectional accuracy of an axis [mm]

A_bwd = 0.20476 [mm]

**A = Bi-directional accuracy of an axis [mm]**

**A = 0.20476 [mm]** 

# Limit Switch Performance

## Configuration

Setting | Value |
--- | --- |
Data file | /home/dev/tempdata/data.log |
Reference position source | IOC_TEST:m0s003-Enc01-PosAct |
Reference gear ratio | -0.0146542635 |
Reference offset | 491650.1380340423 |
Low Limit source | IOC_TEST:m0s001-BI02 |
High Limit source | IOC_TEST:m0s001-BI01 |
Test number source | IOC_TEST:TestNumber |
Unit | mm |

## Low Limit

Test | Engage [mm] | Disengage [mm] |
--- | --- | --- |
1 | -23.60009 | -23.14581 |
2 | -23.57078 | -23.17512 |
3 | -23.55613 | -23.17512 |
4 | -23.54147 | -23.17512 |
5 | -23.52682 | -23.18977 |
6 | -23.52682 | -23.18977 |
7 | -23.49751 | -23.14581 |
8 | -23.49751 | -23.16046 |
9 | -23.52682 | -23.18977 |
10 | -23.51216 | -23.20442 |
AVG   | -23.53560 | -23.17510 |
STD   | 0.03088 | 0.01854 |
Range | 0.10258 | 0.05862 |

## High Limit

Test | Engage [mm] | Disengage [mm] |
--- | --- | --- |
1 | 67.15376 | 66.80206 |
2 | 67.19773 | 66.80206 |
3 | 67.19773 | 66.83137 |
4 | 67.18307 | 66.78741 |
5 | 67.21238 | 66.81672 |
6 | 67.19773 | 66.83137 |
7 | 67.18307 | 66.78741 |
8 | 67.21238 | 66.81672 |
9 | 67.19773 | 66.81672 |
10 | 67.18307 | 66.78741 |
AVG   | 67.19190 | 66.80790 |
STD   | 0.01632 | 0.01632 |
Range | 0.05862 | 0.04396 |

## Summary

**Low limit engage range    = 0.10258 [mm]**

**Low limit disengage range = 0.05862 [mm]**

**High limit engage range    = 0.05862 [mm]**

**High limit disengage range = 0.04396 [mm]**

**Total  travel range (engage to engage) = 90.72750 [mm]**


# Resolver Performance

## Configuration

Setting | Value |
--- | --- |
Data file | /home/dev/tempdata/data.log |
Resolver position source | IOC_TEST:m0s003-Enc01-PosAct |
Resolver gain | -0.0146542635 |
Resolver offset | 491650.1380340423 |
Target position source | IOC_TEST:Axis1-PosSet |
Test number source | IOC_TEST:TestNumber |
Unit | mm |

## Resolver reading over one turn
Measured at 8 positions offset by 45deg resolver shaft angle.
The distrubution values are based on 10 values at each location.

Test | Setpoint [mm] | Resolver AVG[mm] | Diff [mm] | Resolver STD[mm]
--- | --- | --- | --- | --- |
1 | 31.00000 | 30.8713000 | -0.1287000 | 0.1101410
2 | 33.00000 | 32.8921000 | -0.1079000 | 0.0912809
3 | 35.00000 | 34.8953000 | -0.1047000 | 0.0886674
4 | 37.00000 | 36.9088000 | -0.0912000 | 0.0880354
5 | 39.00000 | 38.9047000 | -0.0953000 | 0.0808113
6 | 41.00000 | 40.8831000 | -0.1169000 | 0.0869555
7 | 43.00000 | 42.8878000 | -0.1122000 | 0.0880354
8 | 45.00000 | 44.9013000 | -0.0987000 | 0.0762163

**Resolver accuracy: 0.1287000 [mm]**

