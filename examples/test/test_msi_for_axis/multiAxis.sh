
SUBST=$1
TEMP=$2
FILE=$3
msi -S $1  | sed 's/#.*//' | sed 's/ *$//' | awk -v f=$TEMP$FILE -f ./multiAxis.awk

# msi -S $1 | awk -v f=$TEMP$FILE 'BEGIN{id=1; print "Write to file filename " f;} { print $0 > f id; if($0=="#END"){print "$(SCRIPTEXEC) $#(ecmccfg_DIR)loadYamlAxis.cmd FILE=" f id > f 0; id=id+1;}}'
# awk -v f=./test.tmp -f ./multiAxis.awk
#                   remove comments remove trailing spaces
# cat tempAllAx.ax | sed 's/#.*//' | sed 's/ *$//' | awk -v f=./test.tmp -f ./multiAxis.awk
