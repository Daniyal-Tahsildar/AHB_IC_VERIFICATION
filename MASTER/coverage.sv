class ahb_cov extends uvm_subscriber#(ahb_tx);

    ahb_tx tx;

    `uvm_component_utils(ahb_cov)

    covergroup ahb_cg;
        wr_rd_cp: coverpoint tx.wr_rd;
        burst_cp: coverpoint tx.burst;
        size_cp: coverpoint tx.size;
    endgroup

    function new (string name = "", uvm_component parent = null);
        super.new(name,parent);
        ahb_cg = new();
    endfunction 

    function void write (ahb_tx t);
        $cast(tx, t);
        ahb_cg.sample();
    endfunction
endclass