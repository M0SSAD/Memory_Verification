import mem_pkg::*;
module memory (mem_intf.DUT intf);
    // Memory Element
    logic [DW:0] mem [DEPTH];

    always_ff @(posedge intf.clk or negedge intf.rst_n) begin
        if(!intf.rst_n) begin
            // Data is not valid.
            intf.valid_out <= 1'b0;
            intf.data_out  <= '0;
        end else if (intf.en) begin
            // Read the input to be written
            mem[intf.addr] <= intf.data_in;
            intf.valid_out <= 1'b0;
        end else begin
            // Output the data to be read
            intf.data_out <= mem[intf.addr];
            intf.valid_out <= 1'b1;
        end
    end
endmodule