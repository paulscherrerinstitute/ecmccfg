# pos array
caput -a c6025a-04:Axis1-PVT-Positions '0 360 720 1080 1440 1080 720'
# relative
caput c6025a-04:PVT-MoveMode 0
# Use axis
caput c6025a-04:Axis1-PVT-UseAxis 1
# build
caput c6025a-04:PVT-Build 1
# prepare a relative move
caput c6025a-04:Axis1-TgtPosCmd 1000
caput c6025a-04:Axis1-MtnCmd 2
caput c6025a-04:Axis1.CNEN 1
caput c6025a-04:PVT-EndPulses 5
caput c6025a-04:PVT-NumPulses 5
