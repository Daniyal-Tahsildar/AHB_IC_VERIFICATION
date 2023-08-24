class top_base_seq extends uvm_sequence;  
    
    `uvm_object_utils(top_base_seq)
    
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

class top_wr_rd_seq extends top_base_seq;
    ahb_wr_rd_seq ahb_wr_rd_seq_i;
    apb_config_seq apb_config_seq_i;

    `uvm_object_utils(top_wr_rd_seq)
    `uvm_declare_p_sequencer(top_sqr)
    `NEW_OBJ

    task body();  
        `uvm_do_on(apb_config_seq_i, p_sequencer.apb_sqr_i)  
        fork
            `uvm_do_on(ahb_wr_rd_seq_i, p_sequencer.ahb_sqr_iA[0])  
            `uvm_do_on(ahb_wr_rd_seq_i, p_sequencer.ahb_sqr_iA[1])  
            `uvm_do_on(ahb_wr_rd_seq_i, p_sequencer.ahb_sqr_iA[2])  
        join
        endtask
endclass

