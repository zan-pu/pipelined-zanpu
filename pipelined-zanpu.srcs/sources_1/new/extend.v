`timescale 1ns / 1ps
`include "definitions.vh"

/*
 * Module: ZanPU Extend
 *
 * Input:  .imm16 .cu_ext_op
 * Output: .extended_imm
 */

module extend(
           input  wire[15:0]                  imm16,
           input  wire[`EXT_OP_LENGTH  - 1:0] cu_ext_op,

           output wire[31:0]                  extended_imm
       );

assign extended_imm =
       (cu_ext_op == `EXT_OP_SFT16) ? {imm16, 16'b0} :            // LUI: shift left 16
       (cu_ext_op == `EXT_OP_SIGNED) ? {{16{imm16[15]}}, imm16} : // ADDIU: signed sign extend of imm16
       {16'b0, imm16};                                            // LW, SW: unsigned sign extend of imm16
endmodule
