// sequence item enum declaration

typedef enum bit [2:0]{
    SINGLE = 3'b000,
    INCR = 3'b001,
    WRAP4 = 3'b010,
    INCR4 = 3'b011,
    WRAP8 = 3'b100,
    INCR8 = 3'b101,
    WRAP16 = 3'b110,
    INCR16 = 3'b111
} burst_t;

//tran enum declaration
typedef enum bit [1:0]{
    IDLE = 2'b00,
    BUSY = 2'b01,
    NONSEQ = 2'b10,
    SEQ = 2'b11
}trans_t;

typedef enum bit [1:0]{
    OKAY = 2'b00,
    ERROR = 2'b01,
    RETRY = 2'b10,
    SPLIT = 2'b11
}error_t;

// start and end addresses (randomly selected)
`define S0_START 32'h1000_0000
`define S0_END   32'h3000_0000
`define S1_START 32'h4000_0000
`define S1_END   32'h5000_0000
`define S2_START 32'h6000_0000
`define S2_END   32'h9000_0000
`define S3_START 32'hA000_0000
`define S3_END   32'hD000_0000

//common class functions
`define NEW_COMP\
function new (string name = "", uvm_component parent = null);\
    super.new(name,parent);\
endfunction 

`define NEW_OBJ\
function new (string name = "");\
    super.new(name);\
endfunction 

class ahb_common;
    
    static int num_matches = 0;
    static int num_mismatches = 0;

    static int m0_matches = 0;
    static int m0_mismatches = 0;

    static int m1_matches = 0;
    static int m1_mismatches = 0;

    static int m2_matches = 0;
    static int m2_mismatches = 0;

    static int num_slaves = 1;
    static int num_masters = 1;

    static int num_tx = 1;
    static int total_tx = 0;
endclass