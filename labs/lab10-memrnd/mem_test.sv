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

module mem_test (m_intf.TB bus);
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: new data types - bit ,logic
bit         debug = 1;
logic [7:0] rdata;      // stores data read from memory for checking
logic [7:0] rand_data;
logic [7:0] expected [0:31];
// Monitor Results
  initial begin
      $timeformat ( -9, 0, " ns", 9 );
// SYSTEMVERILOG: Time Literals
      #40000ns $display ( "MEMORY TEST TIMEOUT" );
      $finish;
    end

initial
  begin: memtest
  int error_status;
  error_status = 0;

    $display("Clear Memory Test");
// SYSTEMVERILOG: enhanced for loop
    for (int i = 0; i< 32; i++)
       bus.write_mem (i, 0, debug);
    for (int i = 0; i<32; i++)
      begin 
       bus.read_mem (i, rdata, debug);
       // check each memory location for data = 'h00
       error_status += checkit (i, rdata, 8'h00);
      end
// SYSTEMVERILOG: void function
    printstatus(error_status);


// SYSTEMVERILOG: void function
   error_status = 0; 
   $display("Random Data Test");
   
   for(int i=0; i<32; i++) begin
      if(!std::randomize(rand_data) with { rand_data dist {[8'h41:8'h5a] := 80, [8'h61:8'h7a]:= 20}; })
      begin
         $display("Randomization Error Occurred.");
      end

      expected[i] = rand_data;
      bus.write_mem(i, rand_data, debug);
   end
   for(int i=0; i<32; i++) begin
      bus.read_mem(i, rdata, debug);
      error_status += checkit(i, rdata, expected[i]);
   end
   printstatus(error_status);

   $finish;
  end

function int checkit (input [4:0] address,
                      input [7:0] actual, expected);
  if (actual !== expected) begin
    $display("ERROR:  Address:%h  Data:%h  Expected:%h",
                address, actual, expected);
      return 1;
   end
   return 0;
// SYSTEMVERILOG: function return
endfunction: checkit

// SYSTEMVERILOG: void function
function void printstatus(input int status);
if (status == 0)
   $display("Test Passed - No Errors!");
else
   $display("Test Failed with %d Errors", status);
endfunction

endmodule
