import mem_pkg::*;
interface mem_intf (
    input clk
);
    logic en;
    logic rst_n;
    logic [AW:0] addr;
    logic [DW:0] data_in;
    logic [DW:0] data_out;
    logic valid_out;

    // clocking blocks for synchronizing.
    // rst_n is an asynchronous signal, so it wasn't included.
    clocking driver_cb @(posedge clk); 
        default input #1step output #1;
        input valid_out, data_out;
        output en, addr, data_in;
    endclocking

    clocking monitor_cb @(posedge clk); 
        default input #1step;
        input valid_out, data_out, en, addr, data_in;
    endclocking

    modport DUT (input clk, en, rst_n, addr, data_in, output data_out, valid_out);
    modport DRV(clocking driver_cb, output rst_n);
    modport MON(clocking monitor_cb, input rst_n);
endinterface