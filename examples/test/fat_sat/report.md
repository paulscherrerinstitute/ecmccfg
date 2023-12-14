# ecmc motion system test report

* Data file   : /afs/psi.ch/user/s/sandst_a/myhome/projects/data/data.log
* Date        : Fri Dec  8 12:51:17 CET 2023
* Author      : sandst_a


# Gear Ratios
From | To | Ratio [] | Offset [mm] | Data count [] | Residual error [mm²]
--- | --- | --- | --- | --- | --- |
Target Position | Reference | .00000100 | -126.00009801 | 50.00000000 | 0

# ISO 230-2 motion test

## Configuration

Setting | Value
--- | --- |
Data file | sys.stdin
Reference position source | sls-sioc-ecat01:m0s001-Enc01-PosAct
Target position source | sls-sioc-ecat01:M1-PosSet
Test number source | sls-sioc-ecat01:TestNumber
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
1|-10.0|-10.00008102|-10.00010202|-10.00008702|-10.00009202|-10.00010002|
2|-4.88|-4.88008702|-4.88009702|-4.88009702|-4.88009502|-4.88008202|
3|0.24|0.23992798|0.23990998|0.23991198|0.23991298|0.23991298|
4|5.36|5.35989798|5.35991398|5.35991398|5.35990698|5.35992198|
5|10.48|10.47989998|10.47988798|10.47987098|10.47989098|10.47990298|

### Data backward direction

i = Position index []

j = Cycle index []

tgt_pos(i) = Target position at position i [mm]

ref_pos(i,j) = Reference position at position i and cycle j [mm]

i |tgt_pos(i) [mm]|ref_pos(i,1) [mm]|ref_pos(i,2) [mm]|ref_pos(i,3) [mm]|ref_pos(i,4) [mm]|ref_pos(i,5) [mm]|
--- |--- |--- |--- |--- |--- |--- |
1|-10.0|-10.00009902|-10.00009402|-10.00008202|-10.00009102|-10.00009402|
2|-4.88|-4.88010302|-4.88010402|-4.88009502|-4.88011102|-4.88009302|
3|0.24|0.23991398|0.23989798|0.23990898|0.23992398|0.23990098|
4|5.36|5.35992798|5.35990798|5.35990498|5.35989698|5.35991898|
5|10.48|10.47989598|10.47987398|10.47986998|10.47985898|10.47989298|


## ISO230-2 calculations:

### Positioning deviation and reversal error

#### Positioning deviation forward direction (unidirectional)

x(i,j)   = Position deviation at position i, cycle j (reference position - target position) [mm]

x_avg(i) = Mean unidirectional positioning deviation at a position [mm]

i |x(i,1) [mm]|x(i,2) [mm]|x(i,3) [mm]|x(i,4) [mm]|x(i,5) [mm]|x_avg(i) [mm]|
--- |--- |--- |--- |--- |--- |--- |
1|-8.102e-05|-0.00010202|-8.702e-05|-9.202e-05|-0.00010002|-9.242e-05|
2|-8.702e-05|-9.702e-05|-9.702e-05|-9.502e-05|-8.202e-05|-9.162e-05|
3|-7.202e-05|-9.002e-05|-8.802e-05|-8.702e-05|-8.702e-05|-8.482e-05|
4|-0.00010202|-8.602e-05|-8.602e-05|-9.302e-05|-7.802e-05|-8.902e-05|
5|-0.00010002|-0.00011202|-0.00012902|-0.00010902|-9.702e-05|-0.00010942|

#### Positioning deviation backward direction (unidirectional)

x(i,j)   = Position deviation at position i, cycle j (reference position - target position) [mm]

x_avg(i) = Mean unidirectional positioning deviation at a position [mm]

i |x(i,1) [mm]|x(i,2) [mm]|x(i,3) [mm]|x(i,4) [mm]|x(i,5) [mm]|x_avg(i) [mm]|
--- |--- |--- |--- |--- |--- |--- |
1|-9.902e-05|-9.402e-05|-8.202e-05|-9.102e-05|-9.402e-05|-9.202e-05|
2|-0.00010302|-0.00010402|-9.502e-05|-0.00011102|-9.302e-05|-0.00010122|
3|-8.602e-05|-0.00010202|-9.102e-05|-7.602e-05|-9.902e-05|-9.082e-05|
4|-7.202e-05|-9.202e-05|-9.502e-05|-0.00010302|-8.102e-05|-8.862e-05|
5|-0.00010402|-0.00012602|-0.00013002|-0.00014102|-0.00010702|-0.00012162|

#### Positioning deviation bi-directional

x_avg(i) = Mean bi-directional positioning deviation at a position [mm]

B(i)     = Reversal error at a position [mm]

i |x_avg(i) [mm]|B(i) [mm]|
--- |--- |--- |
1|-9.222e-05|-4e-07|
2|-9.642e-05|9.6e-06|
3|-8.782e-05|6e-06|
4|-8.882e-05|-4e-07|
5|-0.00011552|1.22e-05|

B_avg = Axis avg. reversal error [mm]

B_avg = 5.4e-06 [mm]

**B = Axis reversal error [mm]**

**B = 1.22e-05 [mm]**

### Repeatability

S_fwd(i) = Forward estimator for unidirectional axis positiong repeatability at a position [mm]

S_bwd(i) = Backward estimator for unidirectional axis positiong repeatability at a position [mm]

R_fwd(i) = Forward unidirectional positioning repeatability at a position [mm]

R_bwd(i) = Backward unidirectional positioning repeatability at a position [mm]

R(i) = Bi-directional position repeatability at a position [mm]

i |S_fwd(i) [mm]|S_bwd(i) [mm]|R_fwd(i) [mm]|R_bwd(i) [mm]|R(i) [mm]|
--- |--- |--- |--- |--- |--- |
1|8.79e-06|6.28e-06|3.517e-05|2.514e-05|3.517e-05|
2|6.77e-06|7.29e-06|2.707e-05|2.918e-05|3.772e-05|
3|7.26e-06|1.043e-05|2.904e-05|4.17e-05|4.17e-05|
4|9e-06|1.218e-05|3.6e-05|4.871e-05|4.871e-05|
5|1.258e-05|1.573e-05|5.033e-05|6.29e-05|6.882e-05|

R_fwd = Forward unidirectional positioning repeatability of an axis (max(R_fwd(i))) [mm]

R_fwd = 5.033e-05 [mm]

R_bwd = Backward unidirectional positioning repeatability of an axis (max(R_bwd(i))) [mm]

R_bwd = 6.29e-05 [mm]

**R = Bi-directional positioning repeatability of an axis (max(R_fwd,R_bwd)) [mm]**

**R = 6.29e-05 [mm]**

### Positioning Error

E_fwd = Forward unidirectional system positioning error of an axis [mm]

E_fwd = 2.46e-05 [mm]

E_bwd = Backward unidirectional system positioning error of an axis [mm]

E_bwd = 3.3e-05 [mm]

**E = Bi-directional system positioning error of an axis [mm]**

**E = 2.46e-05 [mm]**

**M = Mean bi-directional system positioning error of an axis [mm]**

**M = 2.77e-05 [mm]**

### Accuracy

A_fwd = Forward unidirectional accuracy of an axis [mm]

A_fwd = 6.428e-05 [mm]

A_bwd = Backward unidirectional accuracy of an axis [mm]

A_bwd = 8.881e-05 [mm]

**A = Bi-directional accuracy of an axis [mm]**

**A = 8.881e-05 [mm]** 

