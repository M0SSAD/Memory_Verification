class subscriber;
    mailbox #(transaction) mbx_mon;
    transaction t;

    covergroup mem_gb with function sample(transaction tx);
        cp_rst_n: coverpoint tx.rst_n {
            bins zero = {0};
            bins one = {1};
            bins from_one_to_zero = (1=>0);
            bins from_zero_to_one = (0=>1);
        }
        cp_en: coverpoint tx.en {
            bins zero = {0};
            bins one = {1};
            bins from_one_to_zero = (1=>0);
            bins from_zero_to_one = (0=>1);
        }
        cp_addr: coverpoint tx.addr {
            bins min_addr = {'d0};
            bins max_addr = {DEPTH-1};
            bins range_of_addresses = {[1:DEPTH - 2]};
        }
        cp_en_addr: cross cp_addr, cp_en iff(tx.rst_n == 1);
    endgroup

    function new(mailbox #(transaction) mbxMon);
        mem_gb = new();
        this.mbx_mon = mbxMon;
    endfunction

    task run();
        forever begin
            mbx_mon.get(t);
            mem_gb.sample(t);
        end
    endtask

endclass