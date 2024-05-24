# PVT profile move

## ioc

## Panel

caqtdm -macro "P=c6025a:,R=PVT-,M1=Axis1,TITLE=ecmc PVT test" ecmcProfileMove.ui


## Set some values

caput -a c6025a:Axis1-PVT-Positions '0 1 2 3 4 5 6 7 8 9 10'

