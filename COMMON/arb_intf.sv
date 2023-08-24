//data interface is different from arbiteration interface
interface arb_intf (input logic hclk, hrst);
    logic [15:0] hbusreq;
    logic [15:0] hlock;
    logic [15:0]hgrant;
    logic [3:0]hmaster;
    logic hmastlock;
    logic granted_f;
    logic [15:0] hsplit;

    clocking master_cb @(posedge hclk);
        default input #0; 
        default output #1;

        output hbusreq;
        output granted_f;
        output hlock;
        input hgrant;
        output hmastlock;
        output hmaster;
        input hsplit;
    endclocking

    clocking slave_cb @(posedge hclk);
        default input #0; 
        default output #1;

        input hbusreq;
        input granted_f;
        input hlock;
        output hgrant;
        input hmastlock;
        input hmaster;
        output hsplit;
    endclocking

    clocking mon_cb @(posedge hclk);
        default input #0; 

        input hbusreq;
        input granted_f;
        input hlock;
        input hgrant;
        input hmastlock;
        input hmaster;
        input hsplit;
    endclocking

    modport master_mp(clocking master_cb);
    modport slave_mp(clocking slave_cb);
    modport mmon_mp(clocking mon_cb);

endinterface