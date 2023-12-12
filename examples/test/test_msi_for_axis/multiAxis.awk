# Generate loadYamlAxis.cmd calls for axes configured in subst file

BEGIN{
    print "Start parsing axes data (output from msi).";
    id=0;
    filename=f id;
    old_filename="xx";
    filename_cmd=f ".cmd";
    axisFound=0;
}
{
    # Print new file name when changed
    if($0=="axis:"){
        old_filename=filename;
        id=id+1;
        filename=f id;
        axisFound=1;
        print "Write axis file: " filename;
        print "$(SCRIPTEXEC) $(ecmccfg_DIR)loadYamlAxis.cmd FILE=" filename  > filename_cmd;
    }
    # Only print out if "axis:" is found
    if(axisFound) {
        print $0 > filename;
    }
}
END{
    print "Generated " id  " files + ecmc cmd file.";
}
