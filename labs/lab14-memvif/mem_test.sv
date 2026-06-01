///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : mem_test.sv
// Title       : Memory Testbench Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the Memory interface testbench module  with class randomization
// Notes       :
// Memory Specification: 8x32 memory
//   Memory is 8-bits wide and address range is 0 to 31.
//   Memory access is synchronous.
//   The Memory is written on the positive edge of clk when "write" is high.
//   Memory data is driven onto the "data" bus when "read" is high.
//   The "read" and "write" signals should not be simultaneously high.
//
///////////////////////////////////////////////////////////////////////////

module mem_test ( 
                  mem_intf.tb mbus,
                  mem_intf.tb mbus2
                );
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

logic [7:0] rand_data; // stores data to write to memory
logic [7:0] rdata; // stores data read from memory for checking

bit ok; // stores return value from randomize

typedef enum bit[1:0] {ascii, uc, lc, uclc} control_t;

class mem_class;
  rand  bit [7:0] data;
  randc bit [4:0] addr;
  virtual  mem_intf.tb mbus;
  control_t cntrl;

  constraint datadist { cntrl == ascii -> data inside {[8'h20:8'h7F]};
                        cntrl == uc    -> data inside {[8'h41:8'h5A]};
                        cntrl == lc    -> data inside {[8'h61:8'h7A]};
                        cntrl == uclc  -> data dist {[8'h41:8'h5a]:=4, [8'h61:8'h7a]:=1};}

 function new (input int darg = 0, int aarg = 0, virtual mem_intf.tb bus = null);
  data = darg;
  addr = aarg;
  mbus = bus;
 endfunction

   // SYSTEMVERILOG: default task input argument values
  task write_mem (input [4:0] waddr, input [7:0] wdata, input debug);
    @(negedge mbus.clk);
    mbus.write <= 1;
    mbus.read  <= 0;
    mbus.addr  <= waddr;
    mbus.data_in  <= wdata;
    @(negedge mbus.clk);
    mbus.write <= 0;
    if (debug == 1)
      $display("Write - Address:%d  Data:%h %c", waddr, wdata, wdata);
  endtask
  
  // SYSTEMVERILOG: default task input argument values
  task read_mem (input [4:0] raddr, output [7:0] rdata, input debug);
     @(negedge mbus.clk);
     mbus.write <= 0;
     mbus.read  <= 1;
     mbus.addr  <= raddr;
     @(negedge mbus.clk);
     mbus.read <= 0;
     rdata = mbus.data_out;
     if (debug == 1) 
       $display("Read  - Address:%d  Data:%h %c", raddr, rdata, rdata);
  endtask

  task configure (input virtual mem_intf.tb bus);
    mbus = bus;
  endtask
endclass

mem_class memrnd;

// Monitor Results
  initial begin
      $timeformat ( -9, 0, " ns", 9 );
// SYSTEMVERILOG: Time Literals
      #40000ns $display ( "MEMORY TEST TIMEOUT" );
      $finish;
    end

initial begin: memtest
    int error_status;
    memrnd = new(0,0, mbus);

    $display("Random Data Test - ASCII");
    memrnd.cntrl = ascii;
    for (int i = 0; i< 32; i++)
    begin
      ok = memrnd.randomize();
       memrnd.write_mem (memrnd.addr, memrnd.data, 1);
       memrnd.read_mem  (memrnd.addr, rdata, 1);
       error_status = checkit (memrnd.addr, rdata, memrnd.data);
    end
    printstatus(error_status);

    $display("Random Data Test - Upper case");
    memrnd.cntrl = uc;
    for (int i = 0; i< 32; i++)
    begin
      ok = memrnd.randomize();
       memrnd.write_mem (memrnd.addr, memrnd.data, 1);
       memrnd.read_mem  (memrnd.addr, rdata, 1);
       error_status = checkit (memrnd.addr, rdata, memrnd.data);
    end
    printstatus(error_status);

    $display("Random Data Test Lower Case");
    memrnd.cntrl = lc;
    for (int i = 0; i< 32; i++)
    begin
      ok = memrnd.randomize();
       memrnd.write_mem (memrnd.addr, memrnd.data, 1);
       memrnd.read_mem  (memrnd.addr, rdata, 1);
       error_status = checkit (memrnd.addr, rdata, memrnd.data);
    end
    printstatus(error_status);

    $display("Random Data Test - Upper/Lower case distribution");
    memrnd.cntrl = uclc;
    for (int i = 0; i< 32; i++)
    begin
      ok = memrnd.randomize();
       memrnd.write_mem (memrnd.addr, memrnd.data, 1);
       memrnd.read_mem  (memrnd.addr, rdata, 1);
       error_status = checkit (memrnd.addr, rdata, memrnd.data);
    end
    printstatus(error_status);


    // Second mem test
    memrnd.configure(mbus2);
    $display("Random Data Test - ASCII");
    memrnd.cntrl = ascii;
    for (int i = 0; i< 32; i++)
    begin
      ok = memrnd.randomize();
       memrnd.write_mem (memrnd.addr, memrnd.data, 1);
       memrnd.read_mem  (memrnd.addr, rdata, 1);
       error_status = checkit (memrnd.addr, rdata, memrnd.data);
    end
    printstatus(error_status);

    $display("Random Data Test - Upper case");
    memrnd.cntrl = uc;
    for (int i = 0; i< 32; i++)
    begin
      ok = memrnd.randomize();
       memrnd.write_mem (memrnd.addr, memrnd.data, 1);
       memrnd.read_mem  (memrnd.addr, rdata, 1);
       error_status = checkit (memrnd.addr, rdata, memrnd.data);
    end
    printstatus(error_status);

    $display("Random Data Test Lower Case");
    memrnd.cntrl = lc;
    for (int i = 0; i< 32; i++)
    begin
      ok = memrnd.randomize();
       memrnd.write_mem (memrnd.addr, memrnd.data, 1);
       memrnd.read_mem  (memrnd.addr, rdata, 1);
       error_status = checkit (memrnd.addr, rdata, memrnd.data);
    end
    printstatus(error_status);

    $display("Random Data Test - Upper/Lower case distribution");
    memrnd.cntrl = uclc;
    for (int i = 0; i< 32; i++)
    begin
      ok = memrnd.randomize();
       memrnd.write_mem (memrnd.addr, memrnd.data, 1);
       memrnd.read_mem  (memrnd.addr, rdata, 1);
       error_status = checkit (memrnd.addr, rdata, memrnd.data);
    end
    printstatus(error_status);


    $finish;
  end

function int checkit (input [4:0] address,
                      input [7:0] actual, expected);
  static int error_status;   // static variable
  if (actual !== expected) begin
    $display("ERROR:  Address:%h  Data:%h  Expected:%h",
                address, actual, expected);
// SYSTEMVERILOG: post-increment
     error_status++;
   end
// SYSTEMVERILOG: function return
   return (error_status);
endfunction: checkit

// SYSTEMVERILOG: void function
function void printstatus(input int status);
if (status == 0)
   $display("Test Passed - No Errors!");
else
   $display("Test Failed with %d Errors", status);
endfunction

endmodule
