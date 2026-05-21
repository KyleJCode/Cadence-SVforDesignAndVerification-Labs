///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : counter.sv
// Title       : Simple class
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Simple counter class
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

module counterclass;

// add counter class here    
class counter;
int count; 

function new(input int count = 0);
    this.count = count;
endfunction

function void load(input int count);
    this.count = count;
endfunction

function int getcount(); 
    return count;
endfunction

endclass

endmodule
