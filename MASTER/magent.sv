class ahb_magent extends uvm_agent;
    ahb_drv drv;
    ahb_sqr sqr;
    ahb_mon mon; 
    ahb_cov cov; 
    

    `uvm_component_utils(ahb_magent)
    
    `NEW_COMP

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        drv = ahb_drv::type_id::create("drv", this);
        mon = ahb_mon::type_id::create("mon", this);
        sqr = ahb_sqr::type_id::create("sqr", this);
        cov = ahb_cov::type_id::create("cov", this);

    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
        mon.ap_port.connect(cov.analysis_export);
    endfunction
endclass