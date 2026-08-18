class driver;

    virtual mem_intf.DRV intf;
    transaction tx;
    mailbox #(transaction) mbx_sd;

    function new(virtual mem_intf.DRV intf, mailbox #(transaction) mbx);
        this.intf = intf;
        this.mbx_sd = mbx;
    endfunction

    task run();
        forever begin
            // get the tx from the mailbox
            mbx_sd.get(tx);
            tx.print("Driver");

            // drive the inputs of the interface.
            @(intf.driver_cb);
            intf.rst_n <= tx.rst_n;
            intf.driver_cb.en <= tx.en;
            intf.driver_cb.addr <= tx.addr;
            intf.driver_cb.data_in <= tx.data_in;
        end
    endtask


endclass