# ecmc motion system test report

* Data file   : /home/dev/tempdata/data.log
* Date        : Wed Nov 10 11:41:41 CET 2021
* Author      : dev


# Gear Ratios
From | To | Ratio [] | Offset [mm] | Data count [] | Residual error [mm²]
--- | --- | --- | --- | --- | --- |
Target Position | Resolver | -.01466 | 491848.08319 | 50.00000 | .04482399
Target Position | Reference | .99943 | 11.54154 | 50.00000 | .03487797

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
1|15.0|15.0033|15.00452|15.00085|15.0033|15.00595|
2|25.2|25.19933|25.19913|25.19933|25.20015|25.20117|
3|35.4|35.38477|35.38762|35.38395|35.3864|35.3866|
4|45.6|45.59182|45.58978|45.59263|45.59263|45.5908|
5|55.8|55.83882|55.84025|55.83964|55.84086|55.84005|

### Data backward direction

i = Position index []

j = Cycle index []

tgt_pos(i) = Target position at position i [mm]

ref_pos(i,j) = Reference position at position i and cycle j [mm]

i |tgt_pos(i) [mm]|ref_pos(i,1) [mm]|ref_pos(i,2) [mm]|ref_pos(i,3) [mm]|ref_pos(i,4) [mm]|ref_pos(i,5) [mm]|
--- |--- |--- |--- |--- |--- |--- |
1|15.0|15.10035|14.9721|14.9721|14.96966|14.97251|
2|25.2|25.27803|25.2132|25.21259|25.21748|25.21422|
3|35.4|35.39639|35.38803|35.38926|35.39252|35.3915|
4|45.6|45.57387|45.57041|45.5649|45.56939|45.57061|
5|55.8|55.79315|55.79499|55.79132|55.79193|55.7958|


## ISO230-2 calculations:

### Positioning deviation and reversal error

#### Positioning deviation forward direction (unidirectional)

x(i,j)   = Position deviation at position i, cycle j (reference position - target position) [mm]

x_avg(i) = Mean unidirectional positioning deviation at a position [mm]

i |x(i,1) [mm]|x(i,2) [mm]|x(i,3) [mm]|x(i,4) [mm]|x(i,5) [mm]|x_avg(i) [mm]|
--- |--- |--- |--- |--- |--- |--- |
1|0.0033|0.00452|0.00085|0.0033|0.00595|0.00358|
2|-0.00067|-0.00087|-0.00067|0.00015|0.00117|-0.00018|
3|-0.01523|-0.01238|-0.01605|-0.0136|-0.0134|-0.01413|
4|-0.00818|-0.01022|-0.00737|-0.00737|-0.0092|-0.00847|
5|0.03882|0.04025|0.03964|0.04086|0.04005|0.03993|

#### Positioning deviation backward direction (unidirectional)

x(i,j)   = Position deviation at position i, cycle j (reference position - target position) [mm]

x_avg(i) = Mean unidirectional positioning deviation at a position [mm]

i |x(i,1) [mm]|x(i,2) [mm]|x(i,3) [mm]|x(i,4) [mm]|x(i,5) [mm]|x_avg(i) [mm]|
--- |--- |--- |--- |--- |--- |--- |
1|0.10035|-0.0279|-0.0279|-0.03034|-0.02749|-0.00266|
2|0.07803|0.0132|0.01259|0.01748|0.01422|0.0271|
3|-0.00361|-0.01197|-0.01074|-0.00748|-0.0085|-0.00846|
4|-0.02613|-0.02959|-0.0351|-0.03061|-0.02939|-0.03016|
5|-0.00685|-0.00501|-0.00868|-0.00807|-0.0042|-0.00656|

#### Positioning deviation bi-directional

x_avg(i) = Mean bi-directional positioning deviation at a position [mm]

B(i)     = Reversal error at a position [mm]

i |x_avg(i) [mm]|B(i) [mm]|
--- |--- |--- |
1|0.00046|0.00624|
2|0.01346|-0.02728|
3|-0.0113|-0.00567|
4|-0.01932|0.02169|
5|0.01668|0.04649|

B_avg = Axis avg. reversal error [mm]

B_avg = 0.00829 [mm]

**B = Axis reversal error [mm]**

**B = 0.04649 [mm]**

### Repeatability

S_fwd(i) = Forward estimator for unidirectional axis positiong repeatability at a position [mm]

S_bwd(i) = Backward estimator for unidirectional axis positiong repeatability at a position [mm]

R_fwd(i) = Forward unidirectional positioning repeatability at a position [mm]

R_bwd(i) = Backward unidirectional positioning repeatability at a position [mm]

R(i) = Bi-directional position repeatability at a position [mm]

i |S_fwd(i) [mm]|S_bwd(i) [mm]|R_fwd(i) [mm]|R_bwd(i) [mm]|R(i) [mm]|
--- |--- |--- |--- |--- |--- |
1|0.00188|0.05759|0.00751|0.23036|0.23036|
2|0.00085|0.02853|0.00339|0.11413|0.11413|
3|0.00148|0.00324|0.00593|0.01296|0.01511|
4|0.00124|0.00323|0.00495|0.01293|0.03063|
5|0.00076|0.00193|0.00303|0.00771|0.05185|

R_fwd = Forward unidirectional positioning repeatability of an axis (max(R_fwd(i))) [mm]

R_fwd = 0.00751 [mm]

R_bwd = Backward unidirectional positioning repeatability of an axis (max(R_bwd(i))) [mm]

R_bwd = 0.23036 [mm]

**R = Bi-directional positioning repeatability of an axis (max(R_fwd,R_bwd)) [mm]**

**R = 0.23036 [mm]**

### Positioning Error

E_fwd = Forward unidirectional system positioning error of an axis [mm]

E_fwd = 0.05405 [mm]

E_bwd = Backward unidirectional system positioning error of an axis [mm]

E_bwd = 0.05727 [mm]

**E = Bi-directional system positioning error of an axis [mm]**

**E = 0.05405 [mm]**

**M = Mean bi-directional system positioning error of an axis [mm]**

**M = 0.036 [mm]**

### Accuracy

A_fwd = Forward unidirectional accuracy of an axis [mm]

A_fwd = 0.05853 [mm]

A_bwd = Backward unidirectional accuracy of an axis [mm]

A_bwd = 0.23036 [mm]

**A = Bi-directional accuracy of an axis [mm]**

**A = 0.23036 [mm]** 

# Limit Switch Performance

## Configuration

Setting | Value |
--- | --- |
Data file | /home/dev/tempdata/data.log |
Reference position source | IOC_TEST:m0s003-Enc01-PosAct |
Reference gear ratio | -0.0146601645 |
Reference offset | 491848.0831979882 |
Low Limit source | IOC_TEST:m0s001-BI02 |
High Limit source | IOC_TEST:m0s001-BI01 |
Test number source | IOC_TEST:TestNumber |
Unit | mm |

## Low Limit

Test | Engage [mm] | Disengage [mm] |
--- | --- | --- |
1 | -23.65748 | -23.17369 |
2 | -23.61350 | -23.20301 |
3 | -23.62816 | -23.21767 |
4 | -23.62816 | -23.18835 |
5 | -23.62816 | -23.23233 |
6 | -23.61350 | -23.20301 |
7 | -23.59884 | -23.24699 |
8 | -23.62816 | -23.21767 |
9 | -23.62816 | -23.21767 |
10 | -23.61350 | -23.20301 |
AVG   | -23.62380 | -23.21030 |
STD   | 0.01473 | 0.01994 |
Range | 0.05864 | 0.07330 |

## High Limit

Test | Engage [mm] | Disengage [mm] |
--- | --- | --- |
1 | 67.17690 | 66.76642 |
2 | 67.16224 | 66.78108 |
3 | 67.20622 | 66.79574 |
4 | 67.19156 | 66.82506 |
5 | 67.19156 | 66.76642 |
6 | 67.17690 | 66.78108 |
7 | 67.17690 | 66.79574 |
8 | 67.20622 | 66.81040 |
9 | 67.20622 | 66.82506 |
10 | 67.19156 | 66.83972 |
AVG   | 67.18860 | 66.79870 |
STD   | 0.01436 | 0.02435 |
Range | 0.04398 | 0.07330 |

## Summary

**Low limit engage range    = 0.05864 [mm]**

**Low limit disengage range = 0.07330 [mm]**

**High limit engage range    = 0.04398 [mm]**

**High limit disengage range = 0.07330 [mm]**

**Total  travel range (engage to engage) = 90.81240 [mm]**


# Resolver Performance

## Configuration

Setting | Value |
--- | --- |
Data file | /home/dev/tempdata/data.log |
Resolver position source | IOC_TEST:m0s003-Enc01-PosAct |
Resolver gain | -0.0146601645 |
Resolver offset | 491848.0831979882 |
Target position source | IOC_TEST:Axis1-PosSet |
Test number source | IOC_TEST:TestNumber |
Unit | mm |

## Resolver reading over one turn
Measured at 8 positions offset by 45deg resolver shaft angle.
The distrubution values are based on 10 values at each location.

Test | Setpoint [mm] | Resolver AVG[mm] | Diff [mm] | Resolver STD[mm]
--- | --- | --- | --- | --- |
1 | 31.00000 | 30.8901000 | -0.1099000 | 0.0980808
2 | 33.00000 | 32.8882000 | -0.1118000 | 0.0923590
3 | 35.00000 | 34.9099000 | -0.0901000 | 0.0792192
4 | 37.00000 | 36.9154000 | -0.0846000 | 0.0772411
5 | 39.00000 | 38.8843000 | -0.1157000 | 0.0942023
6 | 41.00000 | 40.9147000 | -0.0853000 | 0.0756669
7 | 43.00000 | 42.8909000 | -0.1091000 | 0.0925334
8 | 45.00000 | 44.9125000 | -0.0875000 | 0.0808439

**Resolver accuracy: 0.1157000 [mm]**

