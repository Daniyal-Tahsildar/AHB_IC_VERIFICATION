class ahb_ic extends uvm_component;
    int num_masters, num_slaves;
    int granted_master, slave_target;
    logic granted_f;
    virtual ahb_intf mvifA[]; //number of masters is variable hence intfA shoould also be a dynamic array
    virtual ahb_intf svifA[];

    virtual arb_intf.slave_mp arb_vif;
    virtual arb_intf arb_vif_nocb;

    virtual apb_intf.slave_mp apb_vif;

    `uvm_component_utils_begin(ahb_ic)
        `uvm_field_int(num_masters , UVM_ALL_ON)
        `uvm_field_int(num_slaves , UVM_ALL_ON)

    `uvm_component_utils_end

    `NEW_COMP

    function void build_phase(uvm_phase phase);
        string pif_name;
        super.build_phase(phase);
        mvifA = new[num_masters];
        svifA = new[num_slaves];
        for (int i = 0; i< num_masters; i++) begin
            $sformat(pif_name, "MPIF%0d", i);
          assert(uvm_resource_db#(virtual ahb_intf)::read_by_name("AHB", pif_name, mvifA[i], this));
        end

        for (int i = 0; i< num_slaves; i++) begin
            $sformat(pif_name, "SPIF%0d", i);
          assert(uvm_resource_db#(virtual ahb_intf)::read_by_name("AHB", pif_name, svifA[i], this));
        end

        assert(uvm_resource_db#(virtual arb_intf)::read_by_name("AHB", "ARB_INTF", arb_vif, this));
        assert(uvm_resource_db#(virtual arb_intf)::read_by_name("AHB", "ARB_INTF", arb_vif_nocb, this));
        assert(uvm_resource_db#(virtual apb_intf)::read_by_name("APB", "apb_vif", apb_vif, this));
    endfunction

    task run_phase(uvm_phase phase);
        fork
            forever begin
                @(apb_vif.slave_cb);
                if (apb_vif.slave_cb.penable == 1) begin
                    apb_vif.slave_cb.pready <= 1;
                end
            end

            forever begin
                @(arb_vif.slave_cb);
                if (arb_vif_nocb.granted_f == 0) begin
                    arb_vif.slave_cb.hgrant <= 1; // 0th master will have grant (default) 
                    granted_master = 0;

                    for (int i = 0; i< num_masters; i++) begin
                        if (arb_vif.slave_cb.hbusreq[i]) begin
                            arb_vif.slave_cb.hgrant <= 0; 
                            arb_vif.slave_cb.hgrant[i] <= 1; 
                            granted_master = i;
                            arb_vif_nocb.granted_f = 1; // Already grant is given 

                            i = num_masters;
                            break;
                        end
                    end
                end
            end

            forever begin
                @(posedge mvifA[granted_master].hclk);
                //slave_target = 0; // default state //commented out since it gives errors whenever loop restarts
                if(mvifA[granted_master].haddr inside {[`S0_START:`S0_END]}) slave_target = 0;
                if(mvifA[granted_master].haddr inside {[`S1_START:`S1_END]}) slave_target = 1;
                if(mvifA[granted_master].haddr inside {[`S2_START:`S2_END]}) slave_target = 2;
                if(mvifA[granted_master].haddr inside {[`S3_START:`S3_END]}) slave_target = 3;

                // route the request signals from master interface to slave interface
                    //request signals: haddr, hwrite, htrans, hburst, hprot, hsize, hwdata
                    svifA[slave_target].haddr = mvifA[granted_master].haddr;
                    svifA[slave_target].hwrite = mvifA[granted_master].hwrite;
                    svifA[slave_target].htrans = mvifA[granted_master].htrans;
                    svifA[slave_target].hburst = mvifA[granted_master].hburst;
                    svifA[slave_target].hprot = mvifA[granted_master].hprot;
                    svifA[slave_target].hnonsec = mvifA[granted_master].hnonsec;
                    svifA[slave_target].hexcl = mvifA[granted_master].hexcl;
                    svifA[slave_target].hsize = mvifA[granted_master].hsize;
                    svifA[slave_target].hwdata = mvifA[granted_master].hwdata;

                // route the response signals from slave interface to master interface
                    mvifA[granted_master].hrdata = svifA[slave_target].hrdata;
                    mvifA[granted_master].hresp = svifA[slave_target].hresp;
                    mvifA[granted_master].hreadyout = svifA[slave_target].hreadyout;

            end
        join
    endtask

endclass