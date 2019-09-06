`timescale 1ns / 1ps
`include "definitions.vh"

/*
 * Module: ZanPU NPC
 *
 * Input:  .clk .pc .imm16 .imm26 .en_npc_op
 * Output: .npc
 */

module npc(
    input  wire clk,
    input  wire[31:0] pc,
    input  wire[15:0] imm16,
    input  wire[25:0] imm26,

    input  wire en_npc_op,

    output wire[31:0] npc
    );

endmodule
