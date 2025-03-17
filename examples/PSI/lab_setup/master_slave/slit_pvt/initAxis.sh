
# pos array
caput -a c6025a-04:$1-PVT-Positions '0 1 2 3 5 6 7 8 7'
# relative
caput c6025a-04:PVT-MoveMode 1
# Use axis
caput c6025a-04:$1-PVT-UseAxis 1
# build
caput c6025a-04:PVT-Build 1
# prepare a relative move
caput c6025a-04:$1-TgtPosCmd 1000
caput c6025a-04:$1-MtnCmd 2
caput c6025a-04:$1.CNEN 1
