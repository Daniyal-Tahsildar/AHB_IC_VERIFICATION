class ahb_sagent extends uvm_agent;
    ahb_responder responder;
    ahb_mon mon;  
    
    `uvm_component_utils(ahb_sagent)
    
    `NEW_COMP

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        responder = ahb_responder::type_id::create("responder", this);
        mon = ahb_mon::type_id::create("mon", this);

    endfunction
endclass