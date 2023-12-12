# Generate loadYamlAxis.cmd calls for axes configured in subst file

BEGIN{
    print "Start parsing axes data (output from msi).";
    id=1;
    filename=f id;
    old_filename="xx";
    filename_cmd=f ".cmd";
}
{
    if( length($0)==0 ) {
        next;
    }
    # Print new file name when changed
    if(old_filename!=filename){
        print "Write axis file: " filename;
        old_filename=filename;
    }
    print $0 > filename;
    # Trigg on # END
    if($0=="#END"){
        print "$(SCRIPTEXEC) $(ecmccfg_DIR)loadYamlAxis.cmd FILE=" filename  > filename_cmd;
        id=id+1;
        filename=f id;   
    }
}
END{
    print "Generated " id-1  " files + ecmc cmd file.";
}
