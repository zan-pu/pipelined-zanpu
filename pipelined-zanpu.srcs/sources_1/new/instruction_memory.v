`timescale 1ns / 1ps
`include "definitions.vh"

/*
 * Module: ZanPU Instruction Memory
 *
 * Input:  .instruction_addr
 * Output: .instruction
 */

module instruction_memory(
           input  wire[11:2] instruction_addr, // PC fetch instruction address

           output wire[31:0] instruction       // IM fetch instruction from register
       );

reg[31:0] im[`IM_LENGTH:0];
assign instruction = im[instruction_addr];
endmodule
