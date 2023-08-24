`uvm_analysis_imp_decl(_m0)
`uvm_analysis_imp_decl(_m1)
`uvm_analysis_imp_decl(_m2)

`uvm_analysis_imp_decl(_s0)
`uvm_analysis_imp_decl(_s1)
`uvm_analysis_imp_decl(_s2)
`uvm_analysis_imp_decl(_s3)
class ahb_sbd extends uvm_scoreboard;
    uvm_analysis_imp_m0#(ahb_tx, ahb_sbd) imp_m0;
    uvm_analysis_imp_m1#(ahb_tx, ahb_sbd) imp_m1;
    uvm_analysis_imp_m2#(ahb_tx, ahb_sbd) imp_m2;

    uvm_analysis_imp_s0#(ahb_tx, ahb_sbd) imp_s0;
    uvm_analysis_imp_s1#(ahb_tx, ahb_sbd) imp_s1;
    uvm_analysis_imp_s2#(ahb_tx, ahb_sbd) imp_s2;
    uvm_analysis_imp_s3#(ahb_tx, ahb_sbd) imp_s3;

    ahb_tx master_tx, slave_tx;
    //array to acomodate multiple master and slave tx
    ahb_tx master_txAQ[2:0][$];
    ahb_tx slave_txAQ[3:0][$];

    `uvm_component_utils(ahb_sbd)

    `NEW_COMP

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        imp_m0 = new("imp_m0",this);
        imp_m1 = new("imp_m1",this);
        imp_m2 = new("imp_m2",this);
        
        imp_s0 = new("imp_s0",this);
        imp_s1 = new("imp_s1",this);
        imp_s2 = new("imp_s2",this);
        imp_s3 = new("imp_s3",this);
    endfunction

    function void write_m0(ahb_tx tx);
        `uvm_info("SBD","Getting tx from m0", UVM_LOW)
        master_txAQ[0].push_back(tx);
    endfunction

    function void write_m1(ahb_tx tx);
        `uvm_info("SBD","Getting tx from m1", UVM_LOW)
        
        master_txAQ[1].push_back(tx);
    endfunction

    function void write_m2(ahb_tx tx);
        `uvm_info("SBD","Getting tx from m2", UVM_LOW)
        master_txAQ[2].push_back(tx);
    endfunction

    function void write_s0(ahb_tx tx);
        `uvm_info("SBD","Getting tx from s0", UVM_LOW)
        slave_txAQ[0].push_back(tx);
    endfunction

    function void write_s1(ahb_tx tx);
        `uvm_info("SBD","Getting tx from s1", UVM_LOW)
        slave_txAQ[1].push_back(tx);
    endfunction

    function void write_s2(ahb_tx tx);
        `uvm_info("SBD","Getting tx from s2", UVM_LOW)
        slave_txAQ[2].push_back(tx);
    endfunction

    function void write_s3(ahb_tx tx);
        `uvm_info("SBD","Getting tx from s3", UVM_LOW)
        slave_txAQ[3].push_back(tx);
    endfunction

    task compare_tx (input ahb_tx act_tx, input int master_num);
        ahb_tx exp_tx;
        int slave_target; 
        bit [31:0] addr;
        addr = act_tx.addr;
        if(addr inside {[`S0_START:`S0_END]}) slave_target = 0;
        if(addr inside {[`S1_START:`S1_END]}) slave_target = 1;
        if(addr inside {[`S2_START:`S2_END]}) slave_target = 2;
        if(addr inside {[`S3_START:`S3_END]}) slave_target = 3;
        wait(slave_txAQ[slave_target].size() > 0);
        exp_tx = slave_txAQ[slave_target].pop_front();
        if(act_tx.compare(exp_tx))begin
            ahb_common::num_matches++;
            if(master_num == 0) ahb_common::m0_matches++;
            if(master_num == 1) ahb_common::m1_matches++;
            if(master_num == 2) ahb_common::m2_matches++;
            
        end
        else begin
            ahb_common::num_mismatches++;  
            if(master_num == 0) ahb_common::m0_mismatches++;
            if(master_num == 1) ahb_common::m1_mismatches++;
            if(master_num == 2) ahb_common::m2_mismatches++;    
            act_tx.print();
            exp_tx.print();              
        end

    endtask

    task run_phase(uvm_phase phase);
        ahb_tx m0_act_tx, m1_act_tx, m2_act_tx;
      fork
        forever begin
            wait(master_txAQ[0].size() > 0);
            m0_act_tx = master_txAQ[0].pop_front();
            compare_tx(m0_act_tx, 0);
        end

        forever begin
            wait(master_txAQ[1].size() > 0);

            m1_act_tx = master_txAQ[1].pop_front();
            compare_tx(m1_act_tx, 1);
        end

        forever begin
            wait(master_txAQ[2].size() > 0);

            m2_act_tx = master_txAQ[2].pop_front();
            compare_tx(m2_act_tx, 2);
        end
      join
    endtask
endclass