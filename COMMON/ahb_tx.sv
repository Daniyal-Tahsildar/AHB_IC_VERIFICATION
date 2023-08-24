class ahb_tx extends uvm_sequence_item;
    //declare all the fields of AHB interface except clk & rst and handshaking signals (htrans, hready, hreadyout)
    rand bit [31:0] addr;
    bit [31:0] addr_t;
    rand bit [31:0] dataQ[$];
    rand bit wr_rd;
    rand bit [4:0] len;
    rand burst_t burst; 
    rand bit [2:0] size;
    rand bit [6:0] prot;
    rand bit excl;
    rand bit [3:0] master;
    rand bit nonsec;
    rand bit mastlock;
    
    //any signal driven by slave cannot be random
    bit [1:0] resp;
    bit exokay;
    
    //function signals
    integer txsize;
    bit [31:0] lower_wrap_addr;
    bit [31:0] upper_wrap_addr;
    
    
    `uvm_object_utils_begin(ahb_tx)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_queue_int(dataQ, UVM_ALL_ON) // factory registration for a queue
        `uvm_field_int(wr_rd, UVM_ALL_ON)
        `uvm_field_enum(burst_t, burst, UVM_ALL_ON)
    
        `uvm_field_int(size, UVM_ALL_ON)
        `uvm_field_int(prot, UVM_ALL_ON)
        `uvm_field_int(excl, UVM_ALL_ON)
        `uvm_field_int(master, UVM_ALL_ON)
        `uvm_field_int(nonsec, UVM_ALL_ON)
        `uvm_field_int(mastlock, UVM_ALL_ON)
        `uvm_field_int(resp, UVM_ALL_ON)
        `uvm_field_int(exokay, UVM_ALL_ON)
        
    
    `uvm_object_utils_end
    
    `NEW_OBJ
    
    //constraints
    
    function void post_randomize();
        addr_t = addr;
        calc_wrap_boundaries();
    endfunction
    
    constraint burst_len_c {
         (burst == SINGLE) -> (len == 1);
         (burst inside {WRAP4 , INCR4}) -> (len == 4);
         (burst inside {WRAP8 , INCR8}) -> (len == 8);
         (burst inside {WRAP16 , INCR16}) -> (len == 16);
        len inside {[1:16]}; // takes care of INCR burst
    }
    
    constraint dataQ_len_c{
        dataQ.size() == len;
    }
    
    
    //AHB only supports alligned transfers (addr must be always divisible by 2**size)
    constraint aligned_c{
        addr % (2**size) == 0;
    }
    
    //default transfers kept as INCR
    constraint burst_c {
        soft burst == INCR4;
    }
    
    constraint size_c {
        soft size == 2; //4 bytes per beat: will fit into 32 bit data bus
    }
    
    constraint master_c {
        soft master == 0; 
    }
    
    constraint slave_addr_c{
        if(ahb_common::num_slaves == 1) (addr inside {[`S0_START: `S0_END]});
        if(ahb_common::num_slaves == 2) (addr inside {[`S0_START: `S0_END], [`S1_START: `S1_END]});
        if(ahb_common::num_slaves == 3) (addr inside {[`S0_START: `S0_END], [`S1_START: `S1_END], [`S2_START: `S2_END]});
        if(ahb_common::num_slaves == 4) (addr inside {[`S0_START: `S0_END], [`S1_START: `S1_END], [`S2_START: `S2_END], [`S3_START: `S3_END]});
    }
    
    //anything related to ahb_tx fields should be kept in ahb_tx.sv
    
    function void calc_wrap_boundaries();
        //wrap boundaries: txsize = num_transfers * bytes_per_beat
        txsize = len * (2**size); 
        lower_wrap_addr = addr - (addr%txsize);
        upper_wrap_addr = lower_wrap_addr + txsize - 1;
    endfunction
    endclass