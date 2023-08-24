class apb_drv extends uvm_driver#(apb_tx);

    virtual apb_intf.master_mp vif;

    `uvm_component_utils(apb_drv)
       
    `NEW_COMP

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
            if(!uvm_resource_db#(virtual apb_intf)::read_by_name("APB", "apb_vif", vif, this)) begin
                `uvm_error("RESOURCE_DB_ERROR"," Not able to retrive apb_vif!!")
            end
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            drive_tx(req); 
            seq_item_port.item_done();
        end
    endtask

    task drive_tx(apb_tx tx);
        @(vif.master_cb);
        vif.master_cb.paddr <= req.addr;
        if (req.wr_rd == 1) vif.master_cb.pwdata <= req.data;
        vif.master_cb.pwrite <= req.wr_rd;
        vif.master_cb.penable <= 1;
        wait (vif.master_cb.pready == 1);
        @(vif.master_cb);
        vif.master_cb.paddr <= 0;
        if (req.wr_rd == 1) vif.master_cb.pwdata <= 0;
        vif.master_cb.pwrite <= 0;
        vif.master_cb.penable <= 0;

    endtask
endclass