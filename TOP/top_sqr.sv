class top_sqr extends uvm_sequencer;
    int num_masters;
    apb_sqr apb_sqr_i;
    ahb_sqr ahb_sqr_iA[];

    `uvm_component_utils_begin(top_sqr)
        `uvm_field_int(num_masters , UVM_ALL_ON)
  	`uvm_component_utils_end
  
    `NEW_COMP

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ahb_sqr_iA = new[num_masters]; // onlyallocating memory for dynamic array not for individual sequencer
    endfunction
endclass