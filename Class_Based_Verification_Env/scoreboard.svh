class scoreboard;
    mailbox #(transaction) mbx_mon;
    transaction tx;
    // Memory element that will simulate the DUT.
    logic [DW:0] mem [int]; // associative array

    function new (mailbox #(transaction) mbxMon);
        this.mbx_mon = mbxMon;
    endfunction

    task run();
        forever begin
            mbx_mon.get(tx);
            tx.print("Scoreboard");
            if(!tx.rst_n) begin
                if(tx.valid_out !== '0 || tx.data_out !== '0) begin
                    $display("SCOREBOARD-FAIL @%0t | EXPECTED valid_out=0 data_out=0 | ACTUAL valid_out=%0b data_out=%0d.", $time, tx.valid_out, tx.data_out);
                end else begin
                    $display("SCOREBOARD-PASS @%0t | EXPECTED valid_out=0 data_out=0 | ACTUAL valid_out=%0b data_out=%0d.", $time, tx.valid_out, tx.data_out);
                end
            end else begin
                if(tx.en) begin
                    mem[tx.addr] = tx.data_in;
                end else begin
                    if (mem.exists(tx.addr)) begin
                        if(mem[tx.addr] !== tx.data_out || tx.valid_out !== '1) begin
                            $display("SCOREBOARD-FAIL @%0t | Addr: %0d | Expected: data_out=%0d valid_out=1 | Actual: data_out=%0d valid_out=%0d", $time, tx.addr, mem[tx.addr], tx.data_out, tx.valid_out);
                        end else begin
                            $display("SCOREBOARD-PASS @%0t | Addr: %0d | Expected: data_out=%0d valid_out=1 | Actual: data_out=%0d valid_out=%0d", $time, tx.addr, mem[tx.addr], tx.data_out, tx.valid_out);
                        end
                    end else begin
                        $display("SCOREBOARD-WARNING @%0t | Read from uninitialized Addr: %0d", $time, tx.addr);
                    end
                end
            end
        end
    endtask

endclass