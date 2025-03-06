# PVT profile move

## ioc

## Panel

caqtdm -macro "P=c6025a:,R=PVT-,M1=Axis1,TITLE=ecmc PVT test" ecmcProfileMove.ui
caqtdm -macro "P=c6015a-02:,R=PVT-,M1=Axis1,TITLE=ecmc PVT test" ecmcProfileMove.ui

## Set some values

caput -a c6025a-04:Axis1-PVT-Positions '0 1 2 3 4 5 6 7 8 9 10'

caput -a c6025a-04:Axis1-PVT-Positions '0 360 720 1080 1440 1080 720 360 0'

## Time array
caput -a c6025a-04:PVT-Times '1 2 2 1 5 1 1 5 1'
