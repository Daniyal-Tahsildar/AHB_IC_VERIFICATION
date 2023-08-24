interface ahb_intf (input logic hclk, hrst);
    logic [31:0] haddr;
    logic [2:0] hburst;
    logic[6:0] hprot;
    logic[2:0] hsize;
    logic hnonsec;
    logic hexcl;
    
    logic [1:0] htrans;
    logic [31:0] hwdata;
    logic [31:0] hrdata;
    logic hwrite;
    logic hreadyout;
    logic [1:0] hresp;
    logic hexokay;

    clocking master_cb @(posedge hclk);
        default input #0; 
        default output #1;
        input hrst;
        output  haddr;
        output hburst;
        output hprot;
        output hsize;
        output hnonsec;
        output hexcl;
        
        output htrans;
        output hwdata;
        input hrdata;
        output hwrite;
        input hreadyout;
        input hresp;
        input hexokay;

    endclocking

    clocking slave_cb @(posedge hclk);
        default input #0;
        default output #1;
        input hrst;
        input haddr;
        input hburst;
        input hprot;
        input hsize;
        input hnonsec;
        input hexcl;
        
        input htrans;
        input hwdata;
        output hrdata;
        input hwrite;
        output hreadyout;
        output hresp;
        output hexokay;

    endclocking

    clocking mon_cb @(posedge hclk);
        default input #0;
        input hrst;
        input haddr;
        input hburst;
        input hprot;
        input hsize;
        input hnonsec;
        input hexcl;
        
        input htrans;
        input hwdata;
        input hrdata;
        input hwrite;
        input hreadyout;
        input hresp;
        input hexokay;

    endclocking

    modport master_mp( clocking master_cb);
    modport slave_mp( clocking slave_cb);
    modport mon_mp( clocking mon_cb);

endinterface