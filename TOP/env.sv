class ahb_env extends uvm_env;
    int num_masters, num_slaves;

    apb_agent apb_agent_i;
    ahb_magent magentA[];
    ahb_sagent sagentA[];
    ahb_sbd sbd;
    ahb_ic ic;
    top_sqr top_sqr_i;

    `uvm_component_utils_begin(ahb_env)
        `uvm_field_int(num_masters , UVM_ALL_ON)
        `uvm_field_int(num_slaves , UVM_ALL_ON)
    `uvm_component_utils_end
    
    `NEW_COMP

    function void build_phase (uvm_phase phase);
        string agent_name;
        super.build_phase(phase);

        ic = ahb_ic::type_id::create("ic", this);
        top_sqr_i = top_sqr::type_id::create("top_sqr_i", this);
        apb_agent_i = apb_agent::type_id::create("apb_agent_i", this);
        magentA = new[num_masters];
        sagentA = new[num_slaves];

        for (int i = 0; i< num_masters; i++) begin
            $sformat(agent_name, "magentA[%0d]", i);
            magentA[i] = ahb_magent::type_id::create(agent_name, this);
            //wherever master_num is there in magentA[0], they will get "0" value and so on
            uvm_config_db#(int)::set(this, {agent_name, ".*"}, "master_num", i ); 
       
        end
        for (int i = 0; i< num_slaves; i++) begin
            $sformat(agent_name, "sagentA[%0d]", i);
         sagentA[i] = ahb_sagent::type_id::create(agent_name, this);
       //wherever slave_num is there in sagentA[0], they will get "0" value and so on
         uvm_config_db#(int)::set(this, {agent_name, ".*"}, "slave_num", i ); 
       end
        sbd = ahb_sbd::type_id::create("sbd", this);

    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        if (num_masters > 0) magentA[0].mon.ap_port.connect(sbd.imp_m0);
        if (num_masters > 1) magentA[1].mon.ap_port.connect(sbd.imp_m1);
        if (num_masters > 2) magentA[2].mon.ap_port.connect(sbd.imp_m2);

        if (num_slaves > 0) sagentA[0].mon.ap_port.connect(sbd.imp_s0);
        if (num_slaves > 1) sagentA[1].mon.ap_port.connect(sbd.imp_s1);
        if (num_slaves > 2) sagentA[2].mon.ap_port.connect(sbd.imp_s2);
        if (num_slaves > 3) sagentA[3].mon.ap_port.connect(sbd.imp_s3);
    endfunction

    function void end_of_elaboration_phase (uvm_phase phase);
        top_sqr_i.apb_sqr_i = apb_agent_i.sqr;
        for (int i = 0; i < ahb_common:: num_masters; i++)begin
            top_sqr_i.ahb_sqr_iA[i] = magentA[i].sqr;

        end
    endfunction
endclass