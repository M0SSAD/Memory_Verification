class transaction;
    localparam DW = DATA_WIDTH - 1;
    localparam AW = ADDRESS_WIDTH - 1;

    int tx_id;
    static int counter;
    // Inputs of the DUT, TO BE RANDOMIZED.
    rand bit en;
    rand bit rst_n;
    rand bit [AW:0] addr;
    rand bit [DW:0] data_in;

    // Outputs of the DUT for the MONITOR.
    logic [DW:0] data_out;
    logic valid_out;

    // Constratints
    // constrain the rst_n 
    constraint reset_range {
        rst_n dist {0:/10, 1:/90};
    }
    constraint reset {
        if(rst_n == 0) {
            addr == '0;
            data_in == '0;
            en == '0;
        }
    }

    // constructor
    function new(bit is_copy = 0);
        if(!is_copy) begin
            counter++;
            tx_id = counter;
        end
    endfunction

    function void print(string callee);
        $display("%0s: @%0t | TX_ID: %0d TOTAL_COUNT: %0d| inputs: rst_n =%0b  en=%0d addr=%0d data_in=%0d | Outputs: data_out=%0d valid_out=%0b", callee, $time, tx_id, counter, rst_n, en, addr, data_in, data_out, valid_out);
    endfunction
    
    // shallow copy
    function transaction copy();
        transaction tx_copy;
        tx_copy = new(1);
        tx_copy.tx_id = this.tx_id; 
        tx_copy.addr = this.addr;
        tx_copy.data_in = this.data_in;
        tx_copy.en = this.en;
        tx_copy.rst_n = this.rst_n;
        tx_copy.data_out = this.data_out;
        tx_copy.valid_out = this.valid_out;
        return tx_copy;
    endfunction
endclass