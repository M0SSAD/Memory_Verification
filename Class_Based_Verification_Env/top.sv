`timescale 1ns/1ps
import mem_pkg::*;
import pack::*; 

module top;
    // Clock generation
    bit clk;
    initial begin
        forever #5 clk = ~clk; 
    end

    // Interface instantiation
    mem_intf intf(clk);

    // DUT instantiation
    memory DUT (
        .intf(intf.DUT)
    );

    // Handles
    environment env;
    reset_sequence rst_seq;
    random_rw_sequence rand_rw_seq;
    write_sequence wr_seq;
    read_after_write_sequence raw_seq;
    toggle_sequence tgl_seq;
    boundary_sequence bnd_seq;
    sweep_sequence swp_seq;

    initial begin
        // Initialize and start the environment
        env = new(intf);
        env.run();

        // Instantiate all sequences
        rst_seq = new();
        rand_rw_seq = new();
        wr_seq = new();
        raw_seq = new();
        tgl_seq = new();
        bnd_seq = new();
        swp_seq = new();

        rst_seq.run(env.seqr);
        raw_seq.run(env.seqr);
        wr_seq.run(env.seqr);
        rand_rw_seq.run(env.seqr);
        tgl_seq.run(env.seqr);
        bnd_seq.run(env.seqr);
        swp_seq.run(env.seqr);

        #6000; 
        $display("Simulation timeout reached. Finishing...");

        env.scb.report();
        $stop;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, top);
    end
endmodule