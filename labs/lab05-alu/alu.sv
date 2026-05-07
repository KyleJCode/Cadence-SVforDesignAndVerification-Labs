package typedefs;
    typedef enum logic [2:0] {HLT, SKZ, ADD, AND, XOR, LDA, STO, JMP} opcode_t;
endpackage : typedefs

module alu import typedefs::*;(
    input logic [7:0] accum, 
    input logic [7:0] data,
    input opcode_t opcode,
    input logic clk,
    output logic [7:0] out,
    output logic zero
);

timeunit 1ns;
timeprecision 100ps;

always_ff @(negedge clk) begin
    out <= accum;
    case(opcode)
        HLT: ;
        SKZ: ;
        ADD: out <= data + accum;
        AND: out <= data & accum;
        XOR: out <= data ^ accum;
        LDA: out <= data;
        STO: ;
        JMP: ;
        default: ;
    endcase
end

always_comb begin
    zero = (accum == '0);
end

endmodule