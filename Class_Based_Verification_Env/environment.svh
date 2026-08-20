class environment;
    // Component handles
    sequencer seqr;
    driver drv;
    monitor mon;
    scoreboard scb;
    subscriber sub;

    // Mailboxes
    mailbox #(transaction) mbx_sd;
    mailbox #(transaction) mbx_mon_scb;
    mailbox #(transaction) mbx_mon_sub;

    virtual mem_intf intf;

    function new(virtual mem_intf intf);
        this.intf = intf;
        
        // Construct mailboxes
        mbx_sd = new();
        mbx_mon_scb = new();
        mbx_mon_sub = new();

        // Construct components
        seqr = new(mbx_sd);
        drv  = new(intf.DRV, mbx_sd);
        mon  = new(intf.MON, mbx_mon_sub, mbx_mon_scb);
        scb  = new(mbx_mon_scb);
        sub  = new(mbx_mon_sub); 
    endfunction

    task run();
        fork
            drv.run();
            mon.run();
            scb.run();
            sub.run();
        join_none
    endtask
endclass