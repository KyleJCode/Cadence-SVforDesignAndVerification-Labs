///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : control.sv
// Title       : Control Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the Control module
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

// import SystemVerilog package for opcode_t and state_t

// Template provided by Cadence, everything else written by KyleJCode

module control import typedefs::*;(
    output logic load_ac,
    output logic mem_rd,
    output logic mem_wr,
    output logic inc_pc,
    output logic load_pc,
    output logic load_ir,
    output logic halt,
    input  opcode_t opcode, // opcode type name must be opcode_t
    input zero,
    input clk,
    input rst_   
);
// SystemVerilog: time units and time precision specification
timeunit 1ns;
timeprecision 100ps;

state_t state, next_state;

always_ff @(posedge clk or negedge rst_)
	// initial state code
	if (!rst_) 
		state <= INST_ADDR;
  	else 
		state <= next_state;
// <add code for output decode>

always_comb begin
	{mem_rd, load_ir, halt, inc_pc, load_ac, load_pc, mem_wr} = '0;
	next_state = INST_ADDR;
	unique case(state)
		INST_ADDR: begin
			next_state = INST_FETCH;
		end
		INST_FETCH: begin
			mem_rd = 1'b1;	
			next_state = INST_LOAD;
		end
		INST_LOAD: begin
			mem_rd = 1'b1;	
			load_ir = 1'b1;
			next_state = IDLE;			
		end
		IDLE: begin
			mem_rd = 1'b1;	
			load_ir = 1'b1;
			next_state = OP_ADDR;			
		end
		OP_ADDR: begin
			halt = logic'(opcode == HLT);
			inc_pc = 1'b1;
			next_state = OP_FETCH;
		end
		OP_FETCH: begin
			mem_rd = logic'((opcode == ADD) || (opcode == AND) || (opcode == XOR) || (opcode == LDA));
			next_state = ALU_OP;
		end
		ALU_OP: begin
			mem_rd = logic'((opcode == ADD) || (opcode == AND) || (opcode == XOR) || (opcode == LDA));
			inc_pc = logic'((opcode == SKZ) && (zero == 1'b1));	
			load_ac = logic'((opcode == ADD) || (opcode == AND) || (opcode == XOR) || (opcode == LDA));
			load_pc = logic'(opcode == JMP);
			next_state = STORE;
		end
		STORE: begin
			mem_rd = logic'((opcode == ADD) || (opcode == AND) || (opcode == XOR) || (opcode == LDA));
			inc_pc = logic'(opcode == JMP);
			load_ac = logic'((opcode == ADD) || (opcode == AND) || (opcode == XOR) || (opcode == LDA));
			load_pc = logic'(opcode == JMP);
			mem_wr = logic'(opcode == STO);
			next_state = INST_ADDR;
		end
		default: begin
			next_state = INST_ADDR;
		end

	endcase
end
endmodule
