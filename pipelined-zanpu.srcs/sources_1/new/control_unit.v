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
           input wire[5:0]                    opcode, // Instruction opcode
           input wire[4:0]                    sa,     // Shift operation operand
           input wire[5:0]                    func,   // R-Type instruction function
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

wire type_r, lui, addiu, add, subu, lw, sw, beq, j;

// Whether instruction is R-Type
assign type_r    = (opcode == `INST_R_TYPE)       ? 1 : 0;
// R-Type instructions
assign add       = (type_r && func == `FUNC_ADD)  ? 1 : 0;
assign subu      = (type_r && func == `FUNC_SUBU) ? 1 : 0;

// I-Type Instructions
assign lui       = (opcode == `INST_LUI)          ? 1 : 0;
assign addiu     = (opcode == `INST_ADDIU)        ? 1 : 0;
assign lw        = (opcode == `INST_LW)           ? 1 : 0;
assign sw        = (opcode == `INST_SW)           ? 1 : 0;
assign beq       = (opcode == `INST_BEQ)          ? 1 : 0;

// J-Type Instructions
assign j         = (opcode == `INST_J)            ? 1 : 0;

// Determine control signals
assign cu_alu_op    = (add || addiu || lw || sw) ? `ALU_OP_ADD : // Addition in ALU
       (subu || beq) ? `ALU_OP_SUBU :                          // Subtraction in ALU
       `ALU_OP_DEFAULT;                                       // Default ALU operand (output the second ALU input)

// RegDst signal
assign cu_reg_dst   = (add || subu) ? 1 : 0;
// ALUSrc signal
assign cu_alu_src   = (addiu || lw || sw) ? 1 : 0;

// Write signals
assign en_reg_write = (lui || type_r || add || subu || addiu || lw) ? 1 : 0;
assign en_mem_write = (sw) ? 1 : 0;

assign cu_reg_src   = (lui) ? `REG_SRC_IMM :                      // Source: Extended immediate
       (addiu || add || subu) ? `REG_SRC_ALU :                 // Source: ALU result
       (lw) ? `REG_SRC_MEM : `REG_SRC_DEFAULT;                 // Source: Data memory

assign cu_ext_op    = (lui) ? `EXT_OP_SFT16 :                     // Extend module operation: shift left 16
       (addiu) ? `EXT_OP_SIGNED :                              // Extend module operation: signed extend
       (lw || sw) ? `EXT_OP_UNSIGNED :                         // Extend module operation: unsigned extend
       `EXT_OP_DEFAULT;                                        // Extend module operation: default operation (unsigned extend)

assign cu_npc_op    = (lui || addiu || add || subu || lw || sw) ? `NPC_OP_NEXT : // NPC: normal - next instruction
       (beq && !zero) ? `NPC_OP_NEXT :                                        // NPC: BEQ - normal - next instruction
       (beq && zero) ? `NPC_OP_OFFSET :                                       // NPC: BEQ - jump to target
       (j) ? `NPC_OP_JUMP : `NPC_OP_DEFAULT;                                  // NPC: J - just jump!
endmodule
