`timescale 1ns / 1ps
`include "definitions.vh"

/*
 * Module: ZanPU ALU
 *
 * Input:  .alu_in_1 .alu_in_2 .cu_alu_op
 * Output: .alu_result
 */

module alu(
           input  wire[31:0]                   alu_input_1,
           input  wire[31:0]                   alu_input_2,
           input  wire[4:0]                    sa,
           input  wire[`ALU_OP_LENGTH  - 1:0]  cu_alu_op,

           output wire[31:0]                   alu_result
       );

assign alu_result =
       (cu_alu_op == `ALU_OP_ADD)  ? {alu_input_1[31], alu_input_1} + {alu_input_2[31], alu_input_2} :
       (cu_alu_op == `ALU_OP_SUBU) ? {alu_input_1[31], alu_input_1} - {alu_input_2[31], alu_input_2} :
       {alu_input_2[31], alu_input_2};
endmodule
