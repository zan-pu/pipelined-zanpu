`timescale 1ns / 1ps
`include "definitions.vh"

/*
 * Module: ZanPU Next Program Counter
 *
 * Input:  .clk .pc .imm16 .imm26 .en_npc_op
 * Output: .npc
 */

module npc(
           input  wire[31:0]                  pc,
           input  wire[15:0]                  imm16,     // 16 bit immediate
           input  wire[25:0]                  imm26,     // 26 bit immediate
           input  wire[31:0]                  reg1_data, // rs data

           input  wire[`NPC_OP_LENGTH  - 1:0] cu_npc_op, // NPC control signal

           output wire[31:0]                  npc,       // next program counter
           output wire[31:0]                  jmp_dst    // JAL, JAJR jump dst
       );

wire[31:0] pc_4;
assign pc_4 = pc + 32'h4;

assign jmp_dst = pc + 32'h8;

assign npc =
       (cu_npc_op == `NPC_OP_NEXT  ) ? pc_4 :                                       // pc + 4
       (cu_npc_op == `NPC_OP_JUMP  ) ? {pc[31:28], imm26, 2'b00} :                  // pc = target
       (cu_npc_op == `NPC_OP_OFFSET) ? {pc_4 + {{14{imm16[15]}}, {imm16, 2'b00}}} : // pc + 4 + offset
       (cu_npc_op == `NPC_OP_RS    ) ? reg1_data :                                  // pc = rs data
       pc_4;                                                                        // fallback mode: pc + 4
endmodule
