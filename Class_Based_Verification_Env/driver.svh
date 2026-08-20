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
            @(intf.driver_cb);
            // get the tx from the mailbox
            if(mbx_sd.try_get(tx)) begin
                // drive the inputs of the interface.
                tx.print("Driver");
                intf.rst_n <= tx.rst_n;
                intf.driver_cb.en <= tx.en;
                intf.driver_cb.addr <= tx.addr;
                intf.driver_cb.data_in <= tx.data_in;    
            end else begin
                intf.driver_cb.en <= 1'b0;
            end

        end
    endtask
endclass