class base_sequence;
    int num_of_txs = 100;
    virtual task run(sequencer seqr); 
        $display("Error: Base sequence body should not be executed directly.");
    endtask
endclass

class random_rw_sequence extends base_sequence;
    task run(sequencer seqr); 
        for(int i = 0; i < num_of_txs; i++) begin
            transaction tx;
            tx = new();
            assert(tx.randomize()) else $fatal(1, "randomization failed in the random_rw_sequence!");
            tx.print("random_rw_sequence");
            seqr.send_item(tx);
        end
    endtask
endclass

class write_sequence extends base_sequence;
    task run(sequencer seqr); 
        for(int i = 0; i < num_of_txs; i++) begin
            transaction tx;
            tx = new();
            assert(tx.randomize() with {en == 1; rst_n == 1;}) else $fatal(1, "Write rand failed in the write_sequence!");
            tx.print("write_sequence");
            seqr.send_item(tx);
        end
    endtask
endclass

class read_after_write_sequence extends base_sequence;
    task run(sequencer seqr);
        for(int i = 0; i < num_of_txs; i++) begin
            transaction tx_write = new();
            transaction tx_read = new();
            
            // Generate a write tx
            assert(tx_write.randomize() with { en == 1; rst_n == 1;}) else $fatal(1, "write rand failed in the read_after_write_sequence!");
            tx_write.print("read_after_write_sequence");
            seqr.send_item(tx_write);
            
            //Generate a read tx to read from the same address.
            assert(tx_read.randomize() with { en == 0; rst_n == 1; addr == tx_write.addr; }) else $fatal(1, "read rand failed in the read_after_write_sequence!");
            tx_read.print("read_after_write_sequence");
            seqr.send_item(tx_read);
        end
    endtask
endclass