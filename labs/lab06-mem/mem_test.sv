///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : mem_test.sv
// Title       : Memory Testbench Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the Memory testbench module
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

// Template provided by Cadence, solution by Kyle Jeter

module mem_test ( input logic clk, 
                  output logic read, 
                  output logic write, 
                  output logic [4:0] addr, 
                  output logic [7:0] data_in,     // data TO memory
                  input  wire [7:0] data_out     // data FROM memory
                );
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: new data types - bit ,logic
bit debug = 1;
logic [7:0] rdata;      // stores data read from memory for checking

// Monitor Results
initial begin
	$timeformat ( -9, 0, " ns", 9 );
// SYSTEMVERILOG: Time Literals
	#40000ns $display ( "MEMORY TEST TIMEOUT" );
	$finish;
end

initial begin: memtest
  int error_status;

    error_status = 0;
    $display("Clear Memory Test");

    for (int i = 0; i< 32; i++)
      write_mem(i, 0, debug);
       // Write zero data to every address location
       
    for (int i = 0; i<32; i++)
      begin 
       // Read every address location
         read_mem (i, rdata, debug);
       // check each memory location for data = 'h00
         error_status += check_func(i, rdata, 8'h00);
      end

   // print results of test
   printstatus(error_status);
   error_status = 0;
    $display("Data = Address Test");

    for (int i = 0; i< 32; i++)
      write_mem (i, i, debug);
      // Write data = address to every address location
       
    for (int i = 0; i<32; i++)
      begin
       // Read every address location
         read_mem (i, rdata, debug);
       // check each memory location for data = address
         error_status += check_func(i, rdata, i);
      end

   // print results of test
    printstatus(error_status);
    $finish;

end : memtest

// add read_mem and write_mem tasks
task read_mem(input [4:0] rd_addr, output [7:0] rd_data, input debug = 0);
   @(negedge clk)
   read <= 1'b1;
   write <= 1'b0;
   addr <= rd_addr;
   @(negedge clk)
   read <= 1'b0;
   rd_data = data_out;
   if(debug) 
      $display("Debug Read: Addr Value = %0d, Data Value = %0h", rd_addr, rd_data);
endtask : read_mem

task write_mem(input [4:0] wr_addr, input [7:0] wr_data, input debug = 0);
   @(negedge clk)
   addr <= wr_addr;
   data_in <= wr_data;
   write <= 1'b1;
   read <= 1'b0;
   @(negedge clk) // wait for reflection of changes. 
   write <= 1'b0;
   if(debug) 
      $display("Debug Write: Addr Value = %0d, Data Value = %0h", wr_addr, wr_data);
endtask : write_mem

// add result print function
function void printstatus(input int status);
   if(status == 0)
      $display("All tests passed.");
   else
      $display("%0d Errors Occurred.", status);
endfunction : printstatus

function int check_func(input [4:0] address, input [7:0] actual, expected);
  if (actual !== expected) begin
     $display("ERROR:  Address:%h  Data:%h  Expected:%h", address, actual, expected);
     return 1;
  end
   return 0;
endfunction: check_func

endmodule
