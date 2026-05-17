interface m_intf(input clk);
    logic read, write;
    logic [4:0] addr;
    logic [7:0] data_in;
    logic [7:0] data_out;

    task read_mem (input [4:0] raddr, output [7:0] rdata, input debug = 0);
        @(negedge clk);
        write <= 0;
        read <= 1;
        addr <= raddr;
        @(negedge clk);
        read <= 0;
        rdata = data_out;
        if (debug == 1) 
        $display("Read  - Address:%d  Data:%h", raddr, rdata);
    endtask

    task write_mem (input [4:0] waddr, input [7:0] wdata, input debug = 0);
        @(negedge clk);
        write <= 1;
        read  <= 0;
        addr  <= waddr;
        data_in  <= wdata;
        @(negedge clk);
        write <= 0;
        if (debug == 1)
        $display("Write - Address:%d  Data:%h", waddr, wdata);
    endtask

    modport TB (
        input clk, data_out,
        output read, write, addr, data_in,
        import read_mem, write_mem
    );

    modport MEM_D (
        input clk, read, write, addr, data_in,
        output data_out
    );

endinterface : m_intf