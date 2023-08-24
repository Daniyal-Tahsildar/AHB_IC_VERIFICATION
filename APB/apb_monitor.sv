class apb_mon extends uvm_monitor;
   
    virtual apb_intf.mon_mp vif;

    uvm_analysis_port#(apb_tx) ap_port;
    apb_tx tx;

    `uvm_component_utils_begin(apb_mon)
    
    `uvm_component_utils_end

    `NEW_COMP

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);
       
        ap_port = new ("ap_port", this);
    endfunction

    task run_phase(uvm_phase phase);
       
    endtask
endclass