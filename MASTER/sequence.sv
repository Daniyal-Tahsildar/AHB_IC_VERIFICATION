class ahb_base_seq extends uvm_sequence#(ahb_tx);  
    
    `uvm_object_utils(ahb_base_seq)
    
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

//sequence library
class ahb_seq_lib extends uvm_sequence_library#(ahb_tx);  
    
    `uvm_object_utils(ahb_seq_lib)
    `uvm_sequence_library_utils(ahb_seq_lib) 

    function new (string name = "");
        super.new(name);
        init_sequence_library();
    endfunction
    
endclass

class ahb_wrap_seq_lib extends uvm_sequence_library#(ahb_tx);  
    
    `uvm_object_utils(ahb_wrap_seq_lib)
    `uvm_sequence_library_utils(ahb_wrap_seq_lib) 

    function new (string name = "");
        super.new(name);
        init_sequence_library();
    endfunction
    
endclass

class ahb_wr_rd_seq extends ahb_base_seq;
    integer num_tx;

     bit [31:0] wr_addr;
    `uvm_object_utils(ahb_wr_rd_seq)
    `uvm_add_to_seq_lib(ahb_wr_rd_seq, ahb_seq_lib)
    `NEW_OBJ

    task body();
        assert(uvm_resource_db#(int)::read_by_name("GLOBAL", "NUM_TX", num_tx, this));

        repeat(num_tx) begin
            `uvm_do_with(req , {req.wr_rd ==1;})
            wr_addr = req.addr;
        end
        repeat(num_tx) begin
            `uvm_do_with(req , {req.wr_rd ==0; req.addr == wr_addr;})
        end
    endtask
endclass

class ahb_mult_wr_rd_seq extends ahb_base_seq;
    integer num_tx;
    bit [31:0] wr_addrQ[$];
    bit [31:0] addr_x;

       `uvm_object_utils(ahb_mult_wr_rd_seq)
    `uvm_add_to_seq_lib(ahb_mult_wr_rd_seq, ahb_seq_lib)

       
       `NEW_OBJ
   
       task body();
        assert(uvm_resource_db#(int)::read_by_name("GLOBAL", "NUM_TX", num_tx, this));
           repeat(num_tx) begin
               `uvm_do_with(req , {req.wr_rd ==1;})
               wr_addrQ.push_back(req.addr);
           end
           repeat(num_tx) begin
            addr_x = wr_addrQ.pop_front();
               `uvm_do_with(req , {req.wr_rd ==0; req.addr == addr_x;})
           end
       endtask
   endclass

   class ahb_wr_rd_wrap_seq extends ahb_base_seq;
    bit [31:0] wr_addr;
       `uvm_object_utils(ahb_wr_rd_wrap_seq)
        `uvm_add_to_seq_lib(ahb_wr_rd_wrap_seq, ahb_seq_lib)
    `uvm_add_to_seq_lib(ahb_wr_rd_wrap_seq, ahb_wrap_seq_lib)
       
       `NEW_OBJ
   
       task body();
           repeat(1) begin
               `uvm_do_with(req , {req.wr_rd ==1; req.burst == WRAP4;})
               wr_addr = req.addr;
           end
           repeat(1) begin
               `uvm_do_with(req , {req.wr_rd ==0; req.addr == wr_addr; req.burst == WRAP4;})
           end
       endtask
   endclass

   class ahb_mult_wr_rd_wrap_seq extends ahb_base_seq;
    integer num_tx;
    bit [31:0] wr_addrQ[$];
    bit [31:0] addr_x;

       `uvm_object_utils(ahb_mult_wr_rd_wrap_seq)
       `uvm_add_to_seq_lib(ahb_mult_wr_rd_wrap_seq, ahb_seq_lib)
    `uvm_add_to_seq_lib(ahb_mult_wr_rd_wrap_seq, ahb_wrap_seq_lib)
       
       `NEW_OBJ
   
       task body();
        assert(uvm_resource_db#(int)::read_by_name("GLOBAL", "NUM_TX", num_tx, this));
           repeat(num_tx) begin
               `uvm_do_with(req , {req.wr_rd ==1; req.burst == WRAP4;})
               wr_addrQ.push_back(req.addr);
           end
           repeat(num_tx) begin
            addr_x = wr_addrQ.pop_front();
               `uvm_do_with(req , {req.wr_rd ==0; req.addr == addr_x; req.burst == WRAP4;})
           end
       endtask
   endclass

   class ahb_wr_rd_incr8_seq extends ahb_base_seq;
    bit [31:0] wr_addr;
       `uvm_object_utils(ahb_wr_rd_incr8_seq)
    `uvm_add_to_seq_lib(ahb_wr_rd_incr8_seq, ahb_seq_lib)
       
       `NEW_OBJ
   
       task body();
           repeat(1) begin
               `uvm_do_with(req , {req.wr_rd ==1; req.burst == INCR8;})
               wr_addr = req.addr;
           end
           repeat(1) begin
               `uvm_do_with(req , {req.wr_rd ==0; req.addr == wr_addr; req.burst == INCR8;})
           end
       endtask
   endclass

   class ahb_wr_rd_incr16_seq extends ahb_base_seq;
    bit [31:0] wr_addr;
       `uvm_object_utils(ahb_wr_rd_incr16_seq)
    `uvm_add_to_seq_lib(ahb_wr_rd_incr16_seq, ahb_seq_lib)
       
       `NEW_OBJ
   
       task body();
           repeat(1) begin
               `uvm_do_with(req , {req.wr_rd ==1; req.burst == INCR16;})
               wr_addr = req.addr;
           end
           repeat(1) begin
               `uvm_do_with(req , {req.wr_rd ==0; req.addr == wr_addr; req.burst == INCR16;})
           end
       endtask
   endclass

   class ahb_mult_wr_rd_wrap16_seq extends ahb_base_seq;
    integer num_tx;
    bit [31:0] wr_addrQ[$];
    bit [31:0] addr_x;

       `uvm_object_utils(ahb_mult_wr_rd_wrap16_seq)
    `uvm_add_to_seq_lib(ahb_mult_wr_rd_wrap16_seq, ahb_seq_lib)
    `uvm_add_to_seq_lib(ahb_mult_wr_rd_wrap16_seq, ahb_wrap_seq_lib)
       
       `NEW_OBJ
   
       task body();
        assert(uvm_resource_db#(int)::read_by_name("GLOBAL", "NUM_TX", num_tx, this));
           repeat(num_tx) begin
               `uvm_do_with(req , {req.wr_rd ==1; req.burst == WRAP16;})
               wr_addrQ.push_back(req.addr);
           end
           repeat(num_tx) begin
            addr_x = wr_addrQ.pop_front();
               `uvm_do_with(req , {req.wr_rd ==0; req.addr == addr_x; req.burst == WRAP16;})
           end
       endtask
   endclass

   class ahb_rand_wr_rd_seq extends ahb_base_seq;
    integer num_tx;
    bit [31:0] wr_addrQ[$];
    bit [31:0] addr_x;
    rand burst_t burst_rand; //control this variable from test 

       `uvm_object_utils(ahb_rand_wr_rd_seq)
    `uvm_add_to_seq_lib(ahb_rand_wr_rd_seq, ahb_seq_lib)
       
       `NEW_OBJ
   
       task body();
        assert(uvm_resource_db#(int)::read_by_name("GLOBAL", "NUM_TX", num_tx, this));
           repeat(num_tx) begin
               `uvm_do_with(req , {req.wr_rd ==1; req.burst == burst_rand;})
               wr_addrQ.push_back(req.addr);
           end
           repeat(num_tx) begin
            addr_x = wr_addrQ.pop_front();
               `uvm_do_with(req , {req.wr_rd ==0; req.addr == addr_x; req.burst == burst_rand;})
           end
       endtask
   endclass
   