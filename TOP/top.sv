
//`include "uvm_pkg"
import uvm_pkg:: *;
`include "uvm_macros.svh" 

`include "common.sv"

`include "apb_tx.sv"
`include "apb_interface.sv"
`include "apb_monitor.sv"
`include "apb_coverage.sv"
`include "apb_sequencer.sv"
`include "apb_drv.sv"
`include "apb_agent.sv"
`include "apb_seq_lib.sv"

`include "ahb_tx.sv"
`include "sequence.sv"
`include "interface.sv"
`include "arb_intf.sv"
`include "sequencer.sv"
`include "scoreboard.sv"
`include "drv.sv"
`include "responder.sv"
`include "monitor.sv"
`include "coverage.sv"
`include "top_sqr.sv"
`include "top_seq_lib.sv"
`include "ahb_ic.sv"
`include "assertions.sv"
`include "sagent.sv"
`include "magent.sv"
`include "env.sv"
`include "test.sv"



module top;

  bit clk, rst;
  bit pclk, prst;
  
  //apb intf
  	logic [31:0] paddr;
    logic [31:0] pwdata;
    logic [31:0] prdata;
    logic pwrite;
    logic penable;
    logic pready;
    logic [1:0] presp;

    //signals required here since EDA playground uses Mentor Questa
    //without assigning these signals wavefors cannot be viewed
    //arb_intf signals
    logic [15:0] hbusreq;
    logic [15:0] hlock;
    logic [15:0]hgrant;
    logic [3:0]hmaster;
    logic hmastlock;
    logic [15:0] hsplit;
  // intf signals
//   logic [31:0] haddr;
//     logic [2:0] hburst;
//     logic[6:0] hprot;
//     logic[2:0] hsize;
//     logic hnonsec;
//     logic hexcl;
    
//     logic [1:0] htrans;
//     logic [31:0] hwdata;
//     logic [31:0] hrdata;
//     logic hwrite;
//     logic hreadyout;
//     logic [1:0] hresp;
//     logic hexokay;
  
    // Assuming 3 master interfaces, 4 slave interfaces
    //ahb_intf mpif0(.hclk(clk), .hrst(rst)) [2:0]; declaring array of physical interfaces s not possible
    //whereas declaring array of virtual interfaces is possible
    ahb_intf mpif0(.hclk(clk), .hrst(rst));
    ahb_intf mpif1(.hclk(clk), .hrst(rst));
    ahb_intf mpif2(.hclk(clk), .hrst(rst));

    ahb_intf spif0(.hclk(clk), .hrst(rst));
    ahb_intf spif1(.hclk(clk), .hrst(rst));
    ahb_intf spif2(.hclk(clk), .hrst(rst));
    ahb_intf spif3(.hclk(clk), .hrst(rst));

    arb_intf arb_pif(.hclk(clk), .hrst(rst));
    
  apb_intf apb_pif(.pclk(pclk), .prst(prst));
    
    ahb_assertions ahb_assertions_i_0(mpif0.hclk, mpif0.hrst, mpif0.haddr, mpif0.hburst, mpif0.hprot, mpif0.hsize,
    mpif0.hnonsec, mpif0.hexcl, mpif0.htrans, mpif0.hwdata, mpif0.hrdata, mpif0.hwrite, mpif0.hreadyout,
    mpif0.hresp, mpif0.hexokay );
  //TODO: this assertion is done to view slave signals, find a better way to view signals in waveform
    ahb_assertions ahb_assertions_i_0_s(spif0.hclk, spif0.hrst, spif0.haddr, spif0.hburst, spif0.hprot, spif0.hsize,
    spif0.hnonsec, spif0.hexcl, spif0.htrans, spif0.hwdata, spif0.hrdata, spif0.hwrite, spif0.hreadyout,
    spif0.hresp, spif0.hexokay );

    ahb_assertions ahb_assertions_i_1(mpif1.hclk, mpif1.hrst, mpif1.haddr, mpif1.hburst, mpif1.hprot, mpif1.hsize,
    mpif1.hnonsec, mpif1.hexcl, mpif1.htrans, mpif1.hwdata, mpif1.hrdata, mpif1.hwrite, mpif1.hreadyout,
    mpif1.hresp, mpif1.hexokay );

    ahb_assertions ahb_assertions_i_1_s(spif1.hclk, spif1.hrst, spif1.haddr, spif1.hburst, spif1.hprot, spif1.hsize,
    spif1.hnonsec, spif1.hexcl, spif1.htrans, spif1.hwdata, spif1.hrdata, spif1.hwrite, spif1.hreadyout,
    spif1.hresp, spif1.hexokay );

    ahb_assertions ahb_assertions_i_2(mpif2.hclk, mpif2.hrst, mpif2.haddr, mpif2.hburst, mpif2.hprot, mpif2.hsize,
    mpif2.hnonsec, mpif2.hexcl, mpif2.htrans, mpif2.hwdata, mpif2.hrdata, mpif2.hwrite, mpif2.hreadyout,
    mpif2.hresp, mpif2.hexokay );

    ahb_assertions ahb_assertions_i_2_s(spif2.hclk, spif2.hrst, spif2.haddr, spif2.hburst, spif2.hprot, spif2.hsize,
    spif2.hnonsec, spif2.hexcl, spif2.htrans, spif2.hwdata, spif2.hrdata, spif2.hwrite, spif2.hreadyout,
    spif2.hresp, spif2.hexokay );
  
  //apb_intf signals
	assign paddr = apb_pif.paddr ;
    assign pwdata = apb_pif.pwdata;
    assign prdata = apb_pif.prdata;
    assign pwrite = apb_pif.pwrite;
    assign penable = apb_pif.penable;
    assign pready = apb_pif.pready ;
    assign presp = apb_pif.presp ;
    //arb_intf signals
    assign hbusreq = arb_pif.hbusreq;
    assign hlock =arb_pif.hlock;
    assign hgrant =arb_pif.hgrant;
    assign hmaster= arb_pif.hmaster;
    assign hmastlock =arb_pif.hmastlock;
    assign hsplit =arb_pif.hsplit;
  
  //intf signals
//   assign haddr =mpif0.haddr ;
//     assign hburst= mpif0.hburst;
//     assign hprot =mpif0.hprot;
//     assign hsize =mpif0.hsize;
//     assign hnonsec =mpif0.hnonsec;
//     assign hexcl= mpif0.hexcl;
    
//     assign htrans =mpif0.htrans;
//     assign hwdata =mpif0.hwdata;
//     assign hrdata =mpif0.hrdata;
//     assign hwrite =mpif0.hwrite;
//     assign hreadyout= mpif0.hreadyout;
//     assign hresp =mpif0.hresp;
//     assign hexokay =mpif0.hexokay;
  

    initial begin : generate_clock
        clk = 1'b0;
        while(1) #5 clk = ~clk;
     end

     initial begin : generate_clock_apb
      pclk = 1'b0;
      while(1) #5 pclk = ~pclk;
   end

     initial begin
        rst = 1;
        drive_rst_values;
        @(posedge clk);
        rst = 0;
     end

     initial begin
      prst = 1;
      drive_apb_rst_values;
      @(posedge pclk);
      prst = 0;
   end

     //to prevent undefined values during simulation
   task drive_apb_rst_values();
    apb_pif.paddr = 0;
    apb_pif.pwdata = 0;
    apb_pif.prdata= 0;
    apb_pif.pwrite = 0;
    apb_pif.penable = 0;
    apb_pif.pready = 0;
    apb_pif.presp = 0;
   endtask

     task drive_rst_values();
        //MPIF0
        mpif0.haddr = 0;
        mpif0.hburst = 0;
        mpif0.hprot = 0;
        mpif0.hsize = 0;
        mpif0.hnonsec = 0;
        mpif0.hexcl = 0;
        
        mpif0.htrans = 0;
        mpif0.hwdata = 0;
        mpif0.hrdata = 0;
        mpif0.hwrite = 0;
        mpif0.hreadyout = 0;
        mpif0.hresp = 0;
        mpif0.hexokay = 0;
        //MPIF1
        mpif1.haddr = 0;
        mpif1.hburst = 0;
        mpif1.hprot = 0;
        mpif1.hsize = 0;
        mpif1.hnonsec = 0;
        mpif1.hexcl = 0;
        
        mpif1.htrans = 0;
        mpif1.hwdata = 0;
        mpif1.hrdata = 0;
        mpif1.hwrite = 0;
        mpif1.hreadyout = 0;
        mpif1.hresp = 0;
        mpif1.hexokay = 0;
        //MPIF2
        mpif2.haddr = 0;
        mpif2.hburst = 0;
        mpif2.hprot = 0;
        mpif2.hsize = 0;
        mpif2.hnonsec = 0;
        mpif2.hexcl = 0;
        
        mpif2.htrans = 0;
        mpif2.hwdata = 0;
        mpif2.hrdata = 0;
        mpif2.hwrite = 0;
        mpif2.hreadyout = 0;
        mpif2.hresp = 0;
        mpif2.hexokay = 0;
        //SPIF0
        spif0.haddr = 0;
        spif0.hburst = 0;
        spif0.hprot = 0;
        spif0.hsize = 0;
        spif0.hnonsec = 0;
        spif0.hexcl = 0;
        
        spif0.htrans = 0;
        spif0.hwdata = 0;
        spif0.hrdata = 0;
        spif0.hwrite = 0;
        spif0.hreadyout = 0;
        spif0.hresp = 0;
        spif0.hexokay = 0;
        //SPIF1
        spif1.haddr = 0;
        spif1.hburst = 0;
        spif1.hprot = 0;
        spif1.hsize = 0;
        spif1.hnonsec = 0;
        spif1.hexcl = 0;
        
        spif1.htrans = 0;
        spif1.hwdata = 0;
        spif1.hrdata = 0;
        spif1.hwrite = 0;
        spif1.hreadyout = 0;
        spif1.hresp = 0;
        spif1.hexokay = 0;
        //SPIF2
        spif2.haddr = 0;
        spif2.hburst = 0;
        spif2.hprot = 0;
        spif2.hsize = 0;
        spif2.hnonsec = 0;
        spif2.hexcl = 0;
        
        spif2.htrans = 0;
        spif2.hwdata = 0;
        spif2.hrdata = 0;
        spif2.hwrite = 0;
        spif2.hreadyout = 0;
        spif2.hresp = 0;
        spif2.hexokay = 0;
        //SPIF3
        spif3.haddr = 0;
        spif3.hburst = 0;
        spif3.hprot = 0;
        spif3.hsize = 0;
        spif3.hnonsec = 0;
        spif3.hexcl = 0;
        
        spif3.htrans = 0;
        spif3.hwdata = 0;
        spif3.hrdata = 0;
        spif3.hwrite = 0;
        spif3.hreadyout = 0;
        spif3.hresp = 0;
        spif3.hexokay = 0;

        //arb_intf signals
        arb_pif.hbusreq = 0;
        arb_pif.granted_f = 0;
        arb_pif.hlock = 0;
        arb_pif.hgrant = 0;
        arb_pif.hmaster = 0;
        arb_pif.hmastlock = 0;
        arb_pif.hsplit = 0;
     endtask

    initial begin
        run_test("top_wr_rd_test");
    end

    initial begin
      //TODO: change INTF to MPIF0, currently doing that gives error 
      uvm_resource_db#(virtual ahb_intf)::set("AHB", "MPIF0", mpif0, null);
        uvm_resource_db#(virtual ahb_intf)::set("AHB", "MPIF1", mpif1, null);
        uvm_resource_db#(virtual ahb_intf)::set("AHB", "MPIF2", mpif2, null);
        uvm_resource_db#(virtual ahb_intf)::set("AHB", "SPIF0", spif0, null);
        uvm_resource_db#(virtual ahb_intf)::set("AHB", "SPIF1", spif1, null);
        uvm_resource_db#(virtual ahb_intf)::set("AHB", "SPIF2", spif2, null);
        uvm_resource_db#(virtual ahb_intf)::set("AHB", "SPIF3", spif3, null);

        uvm_resource_db#(virtual arb_intf)::set("AHB", "ARB_INTF", arb_pif, null);
        
        uvm_resource_db#(virtual apb_intf)::set("APB", "apb_vif", apb_pif, null);

    end

    initial begin
        $dumpfile("ahb_ic.vcd");
        $dumpvars();
    end
endmodule