// base sequence for the handler, so I can make use of polymorphism
class base_sequence;
    int num_of_txs = 100;
    virtual task run(sequencer seqr); 
        $display("Error: Base sequence body should not be executed directly.");
    endtask
endclass


// sequence for reseting.
class reset_sequence extends base_sequence;
    task run(sequencer seqr);
        transaction tx;
        tx = new();
        assert(tx.randomize()) else $fatal(1, "randomization failed in the reset_sequence!");
        tx.rst_n = 0;
        tx.print("reset_sequence_assert");
        seqr.send_item(tx);

        tx = new();
        assert(tx.randomize()) else $fatal(1, "randomization failed in the reset_sequence!");
        tx.rst_n = 1;
        tx.print("reset_sequence_deassert");
        seqr.send_item(tx);
    endtask
endclass

// totally randomized sequence
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

// randomized write sequence
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

// randomized read after write sequence.
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

class toggle_sequence extends base_sequence;
    task run(sequencer seqr); 
        // Iterate multiple times to create a continuous 0->1->0->1 pattern
        for(int i = 0; i < 10; i++) begin
            transaction tx_read;
            transaction tx_write;
            
            // Send a Read
            tx_read = new();
            assert(tx_read.randomize() with {en == 0; rst_n == 1;}) else $fatal(1, "Read rand failed in toggle_sequence!");
            tx_read.print("toggle_sequence_read");
            seqr.send_item(tx_read);
            
            // Send a Write
            tx_write = new();
            assert(tx_write.randomize() with {en == 1; rst_n == 1;}) else $fatal(1, "Write rand failed in toggle_sequence!");
            tx_write.print("toggle_sequence_write");
            seqr.send_item(tx_write);
        end
    endtask
endclass

class boundary_sequence extends base_sequence;
    task run(sequencer seqr);
        transaction tx;
        int max_addr = mem_pkg::DEPTH - 1;

        // Write and Read at Address 0x0
        tx = new();
        assert(tx.randomize() with {en == 1; rst_n == 1; addr == 0;}) else $fatal(1, "Rand failed!");
        seqr.send_item(tx);

        tx = new();
        assert(tx.randomize() with {en == 0; rst_n == 1; addr == 0;}) else $fatal(1, "Rand failed!");
        seqr.send_item(tx);

        // Write and Read at Maximum Address (0xF)
        tx = new();
        assert(tx.randomize() with {en == 1; rst_n == 1; addr == max_addr;}) else $fatal(1, "Rand failed!");
        seqr.send_item(tx);

        tx = new();
        assert(tx.randomize() with {en == 0; rst_n == 1; addr == max_addr;}) else $fatal(1, "Rand failed!");
        seqr.send_item(tx);
    endtask
endclass

class sweep_sequence extends base_sequence;
    task run(sequencer seqr);
        transaction tx;

        // Write to all locations sequentially
        for(int i = 0; i < mem_pkg::DEPTH; i++) begin
            tx = new();
            assert(tx.randomize() with {en == 1; rst_n == 1; addr == i;}) else $fatal(1, "Sweep write rand failed!");
            tx.print("sweep_sequence_write");
            seqr.send_item(tx);
        end

        // Read from all locations sequentially
        for(int i = 0; i < mem_pkg::DEPTH; i++) begin
            tx = new();
            assert(tx.randomize() with {en == 0; rst_n == 1; addr == i;}) else $fatal(1, "Sweep read rand failed!");
            tx.print("sweep_sequence_read");
            seqr.send_item(tx);
        end
    endtask
endclass