class sequencer;
    mailbox #(transaction) mbx_sd; // mailbox between sequencer and driver;

    function new(mailbox #(transaction) mbx); 
        this.mbx_sd = mbx;
    endfunction

    task send_item(transaction tx);
        mbx_sd.put(tx);
    endtask
endclass