class apb_base_seq extends uvm_sequence#(apb_tx);  
    
    `uvm_object_utils(apb_base_seq)
    
    `NEW_OBJ

    task pre_body();
        uvm_phase phase = get_starting_phase();
        if(phase != null) begin
            phase.raise_objection(this);
            phase.phase_done.set_drain_time(this, 100);
        end
    endtask

    task post_body();
        uvm_phase phase = get_starting_phase();
        if(phase != null) begin
            phase.drop_objection(this);
        end
    endtask
endclass

class apb_config_seq extends apb_base_seq;
     bit [31:0] wr_addr;
    `uvm_object_utils(apb_config_seq)
    `NEW_OBJ

    task body(); 
        $display("Starting apb_config_seq");   
        `uvm_do_with(req , {req.wr_rd ==1; })
    endtask
endclass

