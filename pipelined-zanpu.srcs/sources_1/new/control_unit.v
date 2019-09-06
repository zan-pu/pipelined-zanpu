`timescale 1ns / 1ps
`include "definitions.vh"

/*
 * Module: ZanPU Control Unit
 *
 * Input:
 * Output:
 */

module control_unit(
           input wire                         rst,
           input wire[31:0]                   instruction,
           input wire                         zero,

           output wire                        en_reg_write,
           output wire[`EXT_OP_LENGTH  - 1:0] cu_ext_op,
           output wire                        cu_alu_src,
           output wire[`ALU_OP_LENGTH  - 1:0] cu_alu_op,
           output wire                        en_mem_write,
           output wire[`REG_SRC_LENGTH - 1:0] cu_reg_src,
           output wire                        cu_reg_dst,
           output wire[`NPC_OP_LENGTH  - 1:0] cu_npc_op
       );
endmodule
