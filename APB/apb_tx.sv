class apb_tx extends uvm_sequence_item;
    //declare all the fields of apb interface except clk & rst and handshaking signals (htrans, hready, hreadyout)
    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit wr_rd;
    rand bit [4:0] len;
    
    bit [1:0] resp;
    
    `uvm_object_utils_begin(apb_tx)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON) 
        `uvm_field_int(wr_rd, UVM_ALL_ON)
       
        `uvm_field_int(resp, UVM_ALL_ON)
    
    `uvm_object_utils_end
    
    `NEW_OBJ
    
   
    endclass