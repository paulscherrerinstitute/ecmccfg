# Controller params 
#  relative
caput c6025a-06:PVT-MoveMode 0
caput c6025a-06:PVT-NumPulses 111
caput c6025a-06:PVT-NumPoints 111
caput c6025a-06:PVT-EndPulses 111

# Use axis
caput c6025a-06:$1-PVT-UseAxis 1

# build
caput c6025a-06:PVT-Build 1
# prepare a relative move
caput c6025a-06:$1-TgtPosCmd 1000
caput c6025a-06:$1-MtnCmd 2
