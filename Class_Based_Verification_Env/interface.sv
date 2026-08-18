interface mem_intf #(parameter DATA_WIDTH = 32, parameter ADDRESS_WIDTH = 4) (
    input clk
);
    localparam DW = DATA_WIDTH - 1;
    localparam AW = ADDRESS_WIDTH - 1;
    logic en;
    logic rst_n;
    logic [AW:0] addr;
    logic [DW:0] data_in;
    logic [DW:0] data_out;
    logic valid_out;


    modport DUT (input clk, en, rst_n, addr, data_in, output data_out, valid_out);
endinterface