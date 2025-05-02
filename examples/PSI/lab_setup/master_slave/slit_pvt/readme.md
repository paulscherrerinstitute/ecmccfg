## Panel
```
caqtdm -macro "IOC=c6025a" ecmcMain.ui
```

# PVT profile move

## ioc

## Panel

caqtdm -macro "IOC=c6025a-04,CNT=2,DEV1=c6025a-04,DEV2=c6025a-04,M1=CENTERY,M2=GAPY,TITLE=ecmc PVT test" ecmcProfileMove.ui


## Set some values

caput -a c6025a-04:CENTERY-PVT-Positions '0 1 2 3 4 5 6 7 8 9 10'

caput -a c6025a-04:CENTERY-PVT-Positions '0 360 720 1080 1440 1080 720 360 0'

caput -a c6025a-04:GAPY-PVT-Positions '0 360 720 1080 1440 1080 720 360 0'

## Time array
caput -a c6025a-04:PVT-Times '1 2 2 1 5 1 1 5 1'
