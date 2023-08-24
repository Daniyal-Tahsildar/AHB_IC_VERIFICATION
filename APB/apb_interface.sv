interface apb_intf (input logic pclk, prst);
    logic [31:0] paddr;
    
    logic [31:0] pwdata;
    logic [31:0] prdata;
    logic pwrite;
    logic penable;
    logic pready;
    logic [1:0] presp;

    clocking master_cb @(posedge pclk);
        default input #0; 
        default output #1;
        input prst;
        output  paddr;
        output penable;
        input pready;
        output pwdata;
        input prdata;
        output pwrite;
        input presp;
    endclocking

    clocking slave_cb @(posedge pclk);
        default input #0;
        default output #1;
        input prst;
        input paddr;
        input penable;
        output pready;
        input pwdata;
        output prdata;
        input pwrite;
        output presp;
    endclocking

    clocking mon_cb @(posedge pclk);
        default input #0;
        input prst;
        input paddr;
        input penable;
        input pready;
        input pwdata;
        input prdata;
        input pwrite;
        input presp;
    endclocking

    modport master_mp( clocking master_cb);
    modport slave_mp( clocking slave_cb);
    modport mon_mp( clocking mon_cb);

endinterface