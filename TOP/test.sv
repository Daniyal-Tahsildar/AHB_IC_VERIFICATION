class ahb_base_test extends uvm_test;

    ahb_env env;
    `uvm_component_utils(ahb_base_test)
    
    `NEW_COMP

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        env = ahb_env::type_id::create("env", this);
        //drv slave and master flag
        uvm_config_db#(int)::set(this,"env.magent*", "master_slave_f", 1);
        uvm_config_db#(int)::set(this,"env.sagent*", "master_slave_f", 0);
        uvm_config_db#(int)::set(this,"*", "num_masters", ahb_common:: num_masters);
        uvm_config_db#(int)::set(this,"*", "num_slaves", ahb_common:: num_slaves);

    endfunction

    function void end_of_elaboration_phase (uvm_phase phase);
        `uvm_info("TEST_HEIRERCHY", this.sprint(), UVM_NONE)
        //env.magentA[0].drv.set_report_verbosity_level(UVM_NONE);
        //env.magentA[0].mon.set_report_verbosity_level(UVM_NONE);
//         env.sagent.responder.set_report_verbosity_level(UVM_NONE);
//         env.sagent.mon.set_report_verbosity_level(UVM_NONE);

    endfunction

    function void report_phase (uvm_phase phase);
        if (ahb_common::total_tx == ahb_common::num_matches && ahb_common::num_mismatches == 0) begin
            `uvm_info("STATUS", $psprintf("Test is passing, total_tx = %0d, num_matches = %0d, num_mismatches = %0d", ahb_common::total_tx,  ahb_common::num_matches, ahb_common::num_mismatches), UVM_NONE)
            `uvm_info("STATUS", $psprintf("m0_matches = %0d, m0_mismatches = %0d",ahb_common::m0_matches, ahb_common::m0_mismatches), UVM_NONE)
            if (ahb_common::num_masters > 1) begin
                `uvm_info("STATUS", $psprintf("m1_matches = %0d, m1_mismatches = %0d",ahb_common::m1_matches, ahb_common::m1_mismatches), UVM_NONE)    
            end
            if (ahb_common::num_masters > 2) begin
                `uvm_info("STATUS", $psprintf("m2_matches = %0d, m2_mismatches = %0d",ahb_common::m2_matches, ahb_common::m2_mismatches), UVM_NONE)    
            end
        end
        else begin
            `uvm_error("STATUS", $psprintf("Test is failing, total_tx = %0d, num_matches = %0d, num_mismatches = %d", ahb_common::total_tx,  ahb_common::num_matches, ahb_common::num_mismatches))
            `uvm_info("STATUS", $psprintf("m0_matches = %0d, m0_mismatches = %0d",ahb_common::m0_matches, ahb_common::m0_mismatches), UVM_NONE)
            if (ahb_common::num_masters > 1) begin
                `uvm_info("STATUS", $psprintf("m1_matches = %0d, m1_mismatches = %0d",ahb_common::m1_matches, ahb_common::m1_mismatches), UVM_NONE)    
            end
            if (ahb_common::num_masters > 2) begin
                `uvm_info("STATUS", $psprintf("m2_matches = %0d, m2_mismatches = %0d",ahb_common::m2_matches, ahb_common::m2_mismatches), UVM_NONE)    
            end
        end
    endfunction
endclass

class ahb_wr_rd_test extends ahb_base_test;
    
    `uvm_component_utils(ahb_wr_rd_test)
    
    `NEW_COMP

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        ahb_common::total_tx = 2*ahb_common::num_tx*ahb_common::num_masters;
        uvm_resource_db#(int)::set("GLOBAL", "NUM_TX", ahb_common::num_tx , this);
    endfunction

    task run_phase(uvm_phase phase);
        ahb_wr_rd_seq wr_rd_seq;
        wr_rd_seq = ahb_wr_rd_seq::type_id::create("wr_rd_seq");

        phase.raise_objection(this);
        phase.phase_done.set_drain_time(this, 100);
        wr_rd_seq.start(env.magentA[0].sqr);
        if(ahb_common::num_masters> 1) wr_rd_seq.start(env.magentA[1].sqr);
        if(ahb_common::num_masters> 2) wr_rd_seq.start(env.magentA[2].sqr);
        phase.drop_objection(this);

    endtask
endclass

class top_wr_rd_test extends ahb_base_test;
    
    `uvm_component_utils(top_wr_rd_test)
    
    `NEW_COMP

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        ahb_common::total_tx = 2*ahb_common::num_tx*ahb_common::num_masters;
        uvm_resource_db#(int)::set("GLOBAL", "NUM_TX", ahb_common::num_tx , this);
   
        uvm_config_db#(uvm_object_wrapper)::set(this, "env.top_sqr_i.run_phase","default_sequence", top_wr_rd_seq::get_type()); 

    endfunction

endclass

class ahb_mult_wr_rd_test extends ahb_base_test;

    `uvm_component_utils(ahb_mult_wr_rd_test)
    
    `NEW_COMP

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        ahb_common::total_tx = 2*ahb_common::num_tx*ahb_common::num_masters;
        uvm_resource_db#(int)::set("GLOBAL", "NUM_TX", ahb_common::num_tx , this);
    endfunction

    task run_phase(uvm_phase phase);
        ahb_mult_wr_rd_seq mult_wr_rd_seq;
        mult_wr_rd_seq = ahb_mult_wr_rd_seq::type_id::create("mult_wr_rd_seq");

        phase.raise_objection(this);
        phase.phase_done.set_drain_time(this, 100);
        mult_wr_rd_seq.start(env.magentA[0].sqr);
        if(ahb_common::num_masters> 1) mult_wr_rd_seq.start(env.magentA[1].sqr);
        if(ahb_common::num_masters> 2) mult_wr_rd_seq.start(env.magentA[2].sqr);
        phase.drop_objection(this);

    endtask
endclass

class ahb_wr_rd_wrap_test extends ahb_base_test;
    
    `uvm_component_utils(ahb_wr_rd_wrap_test)
    
    `NEW_COMP

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        ahb_wr_rd_wrap_seq wr_rd_wrap_seq;
        wr_rd_wrap_seq = ahb_wr_rd_wrap_seq::type_id::create("wr_rd_wrap_seq");

        phase.raise_objection(this);
        phase.phase_done.set_drain_time(this, 100);
        wr_rd_wrap_seq.start(env.magentA[0].sqr);
        phase.drop_objection(this);

    endtask
endclass

class ahb_mult_wr_rd_wrap_test extends ahb_base_test;

    `uvm_component_utils(ahb_mult_wr_rd_wrap_test)
    
    `NEW_COMP

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        ahb_common::total_tx = 10;
        uvm_resource_db#(int)::set("GLOBAL", "NUM_TX", 5 , this);
    endfunction

    task run_phase(uvm_phase phase);
        ahb_mult_wr_rd_wrap_seq mult_wr_rd_wrap_seq;
        mult_wr_rd_wrap_seq = ahb_mult_wr_rd_wrap_seq::type_id::create("mult_wr_rd_wrap_seq");

        phase.raise_objection(this);
        phase.phase_done.set_drain_time(this, 100);
        mult_wr_rd_wrap_seq.start(env.magentA[0].sqr);
        phase.drop_objection(this);

    endtask
endclass

class ahb_wr_rd_incr8_test extends ahb_base_test;
    
    `uvm_component_utils(ahb_wr_rd_incr8_test)
    
    `NEW_COMP

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        ahb_wr_rd_incr8_seq wr_rd_incr8_seq;
        wr_rd_incr8_seq = ahb_wr_rd_incr8_seq::type_id::create("wr_rd_incr8_seq");

        phase.raise_objection(this);
        phase.phase_done.set_drain_time(this, 100);
        wr_rd_incr8_seq.start(env.magentA[0].sqr);
        phase.drop_objection(this);

    endtask
endclass

class ahb_wr_rd_incr16_test extends ahb_base_test;
    
    `uvm_component_utils(ahb_wr_rd_incr16_test)
    
    `NEW_COMP

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        ahb_wr_rd_incr16_seq wr_rd_incr16_seq;
        wr_rd_incr16_seq = ahb_wr_rd_incr16_seq::type_id::create("wr_rd_incr16_seq");

        phase.raise_objection(this);
        phase.phase_done.set_drain_time(this, 100);
        wr_rd_incr16_seq.start(env.magentA[0].sqr);
        phase.drop_objection(this);

    endtask
endclass

class ahb_mult_wr_rd_wrap16_test extends ahb_base_test;

    `uvm_component_utils(ahb_mult_wr_rd_wrap16_test)
    
    `NEW_COMP

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        ahb_common::total_tx = 10;
        uvm_resource_db#(int)::set("GLOBAL", "NUM_TX", 5 , this);
    endfunction

    task run_phase(uvm_phase phase);
        ahb_mult_wr_rd_wrap16_seq mult_wr_rd_wrap16_seq;
        mult_wr_rd_wrap16_seq = ahb_mult_wr_rd_wrap16_seq::type_id::create("mult_wr_rd_wrap16_seq");

        phase.raise_objection(this);
        phase.phase_done.set_drain_time(this, 100);
        mult_wr_rd_wrap16_seq.start(env.magentA[0].sqr);
        phase.drop_objection(this);

    endtask
endclass

class ahb_rand_wr_rd_test extends ahb_base_test;

    `uvm_component_utils(ahb_rand_wr_rd_test)
    
    `NEW_COMP

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        ahb_common::total_tx = 10;
        uvm_resource_db#(int)::set("GLOBAL", "NUM_TX", 5 , this);
    endfunction

    task run_phase(uvm_phase phase);
        ahb_rand_wr_rd_seq rand_wr_rd_seq;
        rand_wr_rd_seq = ahb_rand_wr_rd_seq::type_id::create("rand_wr_rd_seq");
        //Specify INCR or WRAP type
        rand_wr_rd_seq.burst_rand = WRAP4;

        phase.raise_objection(this);
        phase.phase_done.set_drain_time(this, 100);
        rand_wr_rd_seq.start(env.magentA[0].sqr);
        phase.drop_objection(this);

    endtask
endclass

//sequence library test
class seq_lib_test extends ahb_base_test;
    uvm_sequence_library_cfg seq_cfg;

    `uvm_component_utils(seq_lib_test)

    `NEW_COMP

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        ahb_common::total_tx = 10;

        uvm_resource_db#(int)::set("GLOBAL", "NUM_TX", 5 , this);
        seq_cfg = new("seq_cfg", UVM_SEQ_LIB_RAND, 20, 20);
        // 8 sequences are part of sequence library, run those 8 sequences 
        //total 20 times in random order
        //first number is for min count second is for max count
        uvm_config_db#(uvm_sequence_library_cfg)::set(this, "env.magentA[0].sqr.run_phase","default_sequence.config", seq_cfg); 
    endfunction

    task run_phase(uvm_phase phase);
        ahb_seq_lib seq_lib;
        seq_lib = ahb_seq_lib::type_id::create("seq_lib");
        //Specify INCR or WRAP type
        //seq_lib.burst_rand = WRAP4;

        phase.raise_objection(this);
        phase.phase_done.set_drain_time(this, 100);
        seq_lib.start(env.magentA[0].sqr);
        phase.drop_objection(this);

    endtask
endclass

class seq_lib_test_2 extends ahb_base_test;
    uvm_sequence_library_cfg seq_cfg;

    `uvm_component_utils(seq_lib_test_2)

    `NEW_COMP

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        ahb_common::total_tx = 10;

        uvm_resource_db#(int)::set("GLOBAL", "NUM_TX", 5 , this);
        seq_cfg = new("seq_cfg", UVM_SEQ_LIB_RAND, 20, 20);
        // 8 sequences are part of sequence library, run those 8 sequences 
        //total 20 times in random order
        //first number is for min count second is for max count
        uvm_config_db#(uvm_object_wrapper)::set(this, "env.magentA[0].sqr.run_phase","default_sequence", ahb_seq_lib::get_type()); 

        uvm_config_db#(uvm_sequence_library_cfg)::set(this, "env.magentA[0].sqr.run_phase","default_sequence.config", seq_cfg); 
    endfunction

endclass

class seq_lib_wrap_test extends ahb_base_test;
    uvm_sequence_library_cfg seq_cfg;

    `uvm_component_utils(seq_lib_wrap_test)

    `NEW_COMP

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        ahb_common::total_tx = 4;

        uvm_resource_db#(int)::set("GLOBAL", "NUM_TX", 2 , this);
        seq_cfg = new("seq_cfg", UVM_SEQ_LIB_RAND, 4, 6);
        // 8 sequences are part of sequence library, run those 8 sequences 
        //total 20 times in random order
        //first number is for min count second is for max count
        uvm_config_db#(uvm_object_wrapper)::set(this, "env.magentA[0].sqr.run_phase","default_sequence", ahb_wrap_seq_lib::get_type()); 

        uvm_config_db#(uvm_sequence_library_cfg)::set(this, "env.magentA[0].sqr.run_phase","default_sequence.config", seq_cfg); 
    endfunction
    
endclass
