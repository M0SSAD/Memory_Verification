class monitor;
    virtual mem_intf.MON intf;
    mailbox #(transaction) mbx_sub;
    mailbox #(transaction) mbx_scb;
    transaction tx;
    transaction tx_sub;
    transaction tx_scb;
    event reset_event;
    function new (virtual mem_intf.MON intf_m, mailbox #(transaction) mbxSub, mailbox #(transaction) mbxScb);
        this.intf = intf_m;
        this.mbx_sub = mbxSub;
        this.mbx_scb = mbxScb;
    endfunction

    task run();
        forever begin
            @(intf.monitor_cb); // wait for the clock edge.
            // sample the signals from the interface and reconstruct the tx
            tx = new(1);
            tx.addr = intf.monitor_cb.addr;
            tx.data_in = intf.monitor_cb.data_in;
            tx.en = intf.monitor_cb.en;
            tx.rst_n = intf.rst_n;
            tx.data_out = intf.monitor_cb.data_out;
            tx.valid_out = intf.monitor_cb.valid_out;
            tx.print("Monitor");
            // copy the tx to send to scoreboard and subscriber
            tx_sub = tx.copy();
            tx_scb = tx.copy();

            mbx_sub.put(tx_sub);
            mbx_scb.put(tx_scb);
        end
    endtask

endclass