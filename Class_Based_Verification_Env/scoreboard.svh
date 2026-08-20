class scoreboard;
    mailbox #(transaction) mbx_mon;
    transaction tx;
    int pass_count = 0;
    int fail_count = 0;
    // Memory element that will simulate the DUT.
    logic [DW:0] mem [int]; // associative array
    transaction cmd_q [$];
    function new (mailbox #(transaction) mbxMon);
        this.mbx_mon = mbxMon;
    endfunction

    task run();
        forever begin
            mbx_mon.get(tx);
            tx.print("Scoreboard");
            // reset
            if(!tx.rst_n) begin
                cmd_q.delete();
                continue;
            end 

            // process transactions from the queue, to simulate the 1 cycle latency while reading.
            if(cmd_q.size() > 0) begin
                transaction prev_tx;
                prev_tx = cmd_q.pop_front();
                if (mem.exists(prev_tx.addr)) begin
                    if(mem[prev_tx.addr] !== tx.data_out || tx.valid_out !== '1) begin
                        fail_count++;
                        $display("SCOREBOARD-FAIL @%0t | Addr: %0d | Expected: data_out=%0d valid_out=1 | Actual: data_out=%0d valid_out=%0d", $time, prev_tx.addr, mem[prev_tx.addr], tx.data_out, tx.valid_out);
                    end else begin
                        pass_count++;
                        $display("SCOREBOARD-PASS @%0t | Addr: %0d | Expected: data_out=%0d valid_out=1 | Actual: data_out=%0d valid_out=%0d", $time, prev_tx.addr, mem[prev_tx.addr], tx.data_out, tx.valid_out);
                    end
                end else begin
                    $display("SCOREBOARD-WARNING @%0t | Read from uninitialized Addr: %0d", $time, prev_tx.addr);
                end
            end

            if (tx.en) begin
                // WRITE
                mem[tx.addr] = tx.data_in;
            end
            else begin
                // READ
                cmd_q.push_back(tx);
            end
        end
    endtask
    function void report();
        $display("=================================================");
        $display("              SCOREBOARD SUMMARY                 ");
        $display("=================================================");
        $display(" Total Passed: %0d", pass_count);
        $display(" Total Failed: %0d", fail_count);
        $display("=================================================");
    endfunction

endclass