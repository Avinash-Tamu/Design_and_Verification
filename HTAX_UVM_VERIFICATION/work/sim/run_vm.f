    +access+rwc                   // allow probes to record signals
    -timescale 1ns/1ns            // set simulation time precision
    -input waves.tcl

    -coverage A                   // record "all" coverage
    -covoverwrite                 // overwrite existing coverage db
    -covfile ./cov_conf.ccf       // feed in coverage configuration file
    -covworkdir ${BRUN_RUN_DIR}/cov_work //tells the coverage to dump in regression run
                                  // directory instead of current coverage directory   
    -svseed random
//setup UVM home
    -uvmhome $UVMHOME

//UVM options
    +UVM_VERBOSITY=UVM_LOW

//    +UVM_TESTNAME=simple_random_test                //-> DONE

//file list containing design and TB files to compiled
    -f file_list.f

