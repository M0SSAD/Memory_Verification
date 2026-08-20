`timescale 1ns/1ps
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

    // the valid_out is always equal to ~en of the previous cycle
    property valid_out_timing;
        @(posedge clk) disable iff(!rst_n)
            ($past(rst_n) === 1'b1) |-> (valid_out == ~$past(en)); // assert on the next clock cycle.
    endproperty

    property reset_asserted;
        @(posedge clk) 
            (!rst_n) |-> (valid_out == 1'b0 && data_out == '0);
    endproperty
    
    assert_valid_out: assert property (valid_out_timing) else $error("Timing Fail: valid_out !=  ~en after one cycle.");
    assert_reset_asserted: assert property (reset_asserted) else $error("Reset Fails: outputs are not zero after a reset.");

endinterface