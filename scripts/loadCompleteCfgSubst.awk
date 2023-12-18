# 

BEGIN{
    print "Start parsing axes data (output from msi).";
    id=0;
    filename_axis=faxis id;
    filename_cmd=fcmd
    axisFound=0;
}
{
    # Print new file name when changed
    if($0=="#AXISEND") {
        axisFound=0;
    }
    if($0=="axis:"){
        id=id+1;
        filename_axis=faxis id;
        axisFound=1;
        print "Write axis file: " filename;
        print "$(SCRIPTEXEC) $(ecmccfg_DIR)loadYamlAxis.cmd FILE=" filename_axis  > filename_cmd;
        print "system \"rm " filename_axis "\"" > filename_cmd;
    }
    # Printout to axis file if 
    if(axisFound) {
        print $0 > filename_axis;
    } else {
        print $0 > filename_cmd;
    }
}
END{
    print "Generated " id  " axes files + ecmc cmd file.";
}

