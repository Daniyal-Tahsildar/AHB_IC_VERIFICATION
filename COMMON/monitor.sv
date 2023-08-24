class ahb_mon extends uvm_monitor;
    int master_num, slave_num;
    bit master_slave_f;

    virtual ahb_intf.mon_mp vif;
    uvm_analysis_port#(ahb_tx) ap_port;
    ahb_tx tx;
    trans_t prev_htrans = IDLE;
    `uvm_component_utils_begin(ahb_mon)
    `uvm_field_int(master_num , UVM_ALL_ON)
  `uvm_field_int(slave_num , UVM_ALL_ON)
    `uvm_field_int(master_slave_f , UVM_ALL_ON)
    `uvm_component_utils_end

    `NEW_COMP

    function void build_phase(uvm_phase phase);
        string pif_name;

        super.build_phase(phase);
        if (master_slave_f == 1) $sformat(pif_name, "MPIF%0d", master_num);
        if (master_slave_f == 0) $sformat(pif_name, "SPIF%0d", slave_num);
        if(!uvm_resource_db#(virtual ahb_intf)::read_by_name("AHB", pif_name, vif, this)) begin
            `uvm_error("RESOURCE_DB_ERROR"," Not able to retrive ahb_vif!!")
        end
        ap_port = new ("ap_port", this);
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            @(vif.mon_cb);
           // if(vif.mon_cb.hreadyout == 1) begin
                case(vif.mon_cb.htrans)
                    IDLE: begin
                        case(prev_htrans)
                            IDLE: begin
                                //do nothing
                            end
                            BUSY: begin
                                `uvm_error("AHB_TX", "Illegal htrans scenario: HTRANS_BUSY_IDLE")
                            end
            
                            NONSEQ: begin
                                data_phase();
                                ap_port.write(tx);
                               // $display("writing tx to ap_port");
                                //tx.print();
                            end
            
                            SEQ: begin
                                data_phase();
                                ap_port.write(tx);
                                //$display("writing tx to ap_port");
                                //tx.print();
                            end
                        endcase

                    end
                    BUSY: begin
                        case(prev_htrans)
                            IDLE: begin
                                `uvm_error("AHB_TX", "Illegal htrans scenario: HTRANS_IDLE_BUSY")
            
                            end
                            BUSY: begin
                                //nothing
                            end
            
                            NONSEQ: begin
                                data_phase();
                            end
            
                            SEQ: begin
                                data_phase();
                            end
                        endcase
                    end

                    NONSEQ: begin
                        case(prev_htrans)
                            IDLE: begin
                                collect_addr_phase();
                            end
                            BUSY: begin
                                `uvm_error("AHB_TX", "Illegal htrans scenario: HTRANS_BUSY_NONSEQ")
                                
                            end
            
                            NONSEQ: begin
                                data_phase();
                                ap_port.write(tx);
                                //$display("writing tx to ap_port");
                                //tx.print();
                                collect_addr_phase(); //this means that a new tx has started, so earlier tx needs to be given to analysis port 

                            end
            
                            SEQ: begin
                                data_phase();
                                ap_port.write(tx);
                                //$display("writing tx to ap_port");
                                //tx.print();
                                collect_addr_phase();
                            end
                        endcase

                    end

                    SEQ: begin
                        case(prev_htrans)
                            IDLE: begin
                                `uvm_error("AHB_TX", "Illegal htrans scenario: HTRANS_IDLE_SEQ")
            
                            end
                            BUSY: begin
                                //collect_addr_phase(); //should not collect addr info since it will override the existing addr info
            
                            end
            
                            NONSEQ: begin
                                data_phase();
                            // collect_addr_phase();
            
                            end
            
                            SEQ: begin
                                data_phase();
                            // collect_addr_phase();
                            end
                        endcase
                        
                    end
                endcase
                prev_htrans = trans_t'(vif.mon_cb.htrans); //static casting
           // end
        end
    endtask

    task collect_addr_phase();
        tx = ahb_tx::type_id::create("tx");
        tx.addr = vif.mon_cb.haddr;
        tx.burst = burst_t'(vif.mon_cb.hburst);
        tx.prot = vif.mon_cb.hprot;
        tx.size = vif.mon_cb.hsize;
        tx.nonsec = vif.mon_cb.hnonsec;
        tx.excl = vif.mon_cb.hexcl;
        tx.wr_rd = vif.mon_cb.hwrite;
    endtask

    task data_phase();
        if(tx.wr_rd==1) begin
            tx.dataQ.push_back( vif.mon_cb.hwdata);
           

        end
        if(tx.wr_rd==0) begin
            tx.dataQ.push_back( vif.mon_cb.hrdata);

        end

    endtask
endclass