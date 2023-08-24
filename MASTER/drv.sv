class ahb_drv extends uvm_driver#(ahb_tx);

    //flag used for quick fix: master and slave use same drv resulting in get_next_item error as slave does not have a sequencer
    bit master_slave_f; 
    //int num_masters, num_slaves;
    int master_num;
    virtual ahb_intf.master_mp vif;
    virtual arb_intf.master_mp arb_vif;

    `uvm_component_utils_begin(ahb_drv)
        `uvm_field_int(master_slave_f, UVM_ALL_ON);
        `uvm_field_int(master_num , UVM_ALL_ON)
        //`uvm_field_int(num_slaves , UVM_ALL_ON)
    `uvm_component_utils_end
    // `uvm_component_utils(ahb_drv)

    `NEW_COMP

    function void build_phase(uvm_phase phase);
        string pif_name;
        super.build_phase(phase);
        //for (int i = 0; i< num_masters; i++) begin
        $sformat(pif_name, "MPIF%0d", master_num);
            if(!uvm_resource_db#(virtual ahb_intf)::read_by_name("AHB", pif_name, vif, this)) begin
                `uvm_error("RESOURCE_DB_ERROR"," Not able to retrive ahb_vif!!")
            end
        //end
        if(!uvm_resource_db#(virtual arb_intf)::read_by_name("AHB", "ARB_INTF", arb_vif, this)) begin
            `uvm_error("RESOURCE_DB_ERROR"," Not able to retrive arb_vif!!")
        end
    endfunction

    task run_phase(uvm_phase phase);
        if(master_slave_f== 1) begin
        wait (vif.master_cb.hrst == 0);
        forever begin
            seq_item_port.get_next_item(req);
            //req.print();
            drive_tx(req); //drive the AHB interface with this request
            seq_item_port.item_done();
        end
    end
    else begin
        `uvm_info("UVM_DRV","DRV behaving as slave", UVM_NONE)
    end
    endtask

    task drive_tx(ahb_tx tx);
        arb_phase(req);
        //len number of addr_phase and len number of data_phase are pipelined
        addr_phase(req, 1);
        req.print();
        for(int i = 0; i < req.len-1; i++) begin
            fork
               
                data_phase(req);
                addr_phase(req);

            join
        end
        data_phase(req);
        set_default_values();
        
    endtask

    task set_default_values();
        arb_vif.master_cb.hbusreq[master_num] <= 0 ;
        arb_vif.master_cb.hlock[master_num] <= 0;
        arb_vif.master_cb.granted_f <= 0;
        vif.master_cb.haddr <= 0;
        vif.master_cb.hburst <= 0;
        vif.master_cb.hprot <= 0;
        vif.master_cb.hsize <= 0;
        vif.master_cb.hnonsec <= 0;
        vif.master_cb.hexcl <= 0;
        vif.master_cb.hwrite <= 0;
        vif.master_cb.htrans <= IDLE;
        @(vif.master_cb);
        vif.master_cb.hwdata <= 0;

    endtask

    task arb_phase(ahb_tx req);
        `uvm_info("AHB_TX","arb_phase", UVM_FULL)
        //signals required for arbiteration phase
        @(arb_vif.master_cb);
        arb_vif.master_cb.hbusreq[master_num] <= 1; //req.master indicates which master is making request, corresponding hbusreq is driven to '1'
        arb_vif.master_cb.hlock[master_num] <= req.mastlock;
        wait (arb_vif.master_cb.hgrant[master_num] == 1); 
        arb_vif.master_cb.hmaster <= req.master;
        arb_vif.master_cb.hmastlock <= req.mastlock;
        
    endtask

    task addr_phase(ahb_tx req= null, bit first_beat_f = 0 );
        `uvm_info("AHB_TX","addr_phase", UVM_FULL)
        @(vif.master_cb);
        vif.master_cb.haddr <= req.addr_t;
        vif.master_cb.hburst <= req.burst;
        vif.master_cb.hprot <= req.prot;
        vif.master_cb.hsize <= req.size;
        vif.master_cb.hnonsec <= req.nonsec;
        vif.master_cb.hexcl <= req.excl;
        if(first_beat_f ==1)vif.master_cb.htrans <= NONSEQ; //only for first tx, need to change for other tx
        if(first_beat_f ==0)vif.master_cb.htrans <= SEQ; 
        vif.master_cb.hwrite <= req.wr_rd;
        //do not wait for hready in the first beat 
        if(first_beat_f == 0 ) wait(vif.master_cb.hreadyout == 1);
        req.addr_t = req.addr_t + 2**req.size;
        if (req.burst inside {WRAP4, WRAP8, WRAP16}) begin
            if(req.addr_t >= req.upper_wrap_addr) begin
                req.addr_t = req.lower_wrap_addr;
            end
        end

    endtask

    task data_phase(ahb_tx req);
        `uvm_info("AHB_TX","data_phase", UVM_FULL)
        @(vif.master_cb);
        if(req.wr_rd == 1) vif.master_cb.hwdata <= req.dataQ.pop_front();
        if(req.wr_rd == 0) req.dataQ.push_back(vif.master_cb.hrdata);
        req.resp = vif.master_cb.hresp;
        if(vif.master_cb.hresp == ERROR) begin
            `uvm_error("AHB_TX", "Slave issued error response")
        end
        wait(vif.master_cb.hreadyout == 1);

    endtask
endclass