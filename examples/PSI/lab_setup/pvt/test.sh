# pos array
caput -a c6015a-02:Axis1-PVT-Positions '0 360 720 1080 1440 1080 720'
# relative
caput c6015a-02:PVT-MoveMode 1
# Use axis
caput c6015a-02:Axis1-PVT-UseAxis 1
# build
caput c6015a-02:PVT-Build 1
# prepare a relative move
caput c6015a-02:Axis1-TgtPosCmd 1000
caput c6015a-02:Axis1-MtnCmd 2
caput c6015a-02:Axis1.CNEN 1
