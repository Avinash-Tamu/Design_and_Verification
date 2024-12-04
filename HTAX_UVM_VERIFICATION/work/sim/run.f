    +access+rwc                   //allow probes to record signals
    -timescale 1ns/1ps            //set simulation time precision
    -input waves.tcl

    -coverage A                   // record "all" coverage
    -covoverwrite                 // overwrite existing coverage db
    -covfile ./cov_conf.ccf       // feed in coverage configuration file

//setup UVM home
    -uvmhome $UVMHOME

//UVM options
    +UVM_VERBOSITY=UVM_LOW

//Add the list of test classes here (uncomment only one)
    //+UVM_TESTNAME=base_test         //-> done
//    +UVM_TESTNAME=simple_random_test   //-> done

//file list containing design and TB files to compiled
    -f file_list.f
