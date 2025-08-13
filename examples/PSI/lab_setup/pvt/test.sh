# pos array
caput c6025a-06:PVT-NumPoints 7
caput -a c6025a-06:Axis1-PVT-Positions '0 360 720 1080 1440 1080 720'
# relative
caput c6025a-06:PVT-MoveMode 0
# Use axis
caput c6025a-06:Axis1-PVT-UseAxis 1
# build

# prepare a relative move
caput c6025a-06:Axis1-TgtPosCmd 1000
caput c6025a-06:Axis1-MtnCmd 2
caput c6025a-06:Axis1.CNEN 1
caput c6025a-06:PVT-EndPulses 5
caput c6025a-06:PVT-NumPulses 5
caput c6025a-06:PVT-Build 1
