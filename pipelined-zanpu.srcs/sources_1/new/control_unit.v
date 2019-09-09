`timescale 1ns / 1ps
`include "definitions.vh"

/*
 * Module: ZanPU Control Unit
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
           output wire[`REG_DST_LENGTH - 1:0] cu_reg_dst,
           output wire[`NPC_OP_LENGTH  - 1:0] cu_npc_op,
           output wire                        en_lw
       );

// Init instruction signals
wire type_r, inst_add, inst_addu, inst_sub, inst_subu, inst_slt;
wire inst_sltu, inst_and, inst_or, inst_nor, inst_xor, inst_sll;
wire inst_srl, inst_sra, inst_sllv, inst_srlv, inst_srav, inst_jr;
wire inst_jalr, inst_addi, inst_addiu, inst_sltiu;
wire inst_andi, inst_ori, inst_xori, inst_lui, inst_lw, inst_sw;
wire inst_beq, inst_bne, inst_j, inst_jal;

/* --- Decode instructions --- */

// Whether instruction is R-Type
assign type_r         = (opcode == `INST_R_TYPE       ) ? 1 : 0;
// R-Type instructions
assign inst_add       = (type_r && func == `FUNC_ADD  ) ? 1 : 0;
assign inst_addu      = (type_r && func == `FUNC_ADDU ) ? 1 : 0;
assign inst_sub       = (type_r && func == `FUNC_SUB  ) ? 1 : 0;
assign inst_subu      = (type_r && func == `FUNC_SUBU ) ? 1 : 0;
assign inst_slt       = (type_r && func == `FUNC_SLT  ) ? 1 : 0;
assign inst_sltu      = (type_r && func == `FUNC_SLTU ) ? 1 : 0;
assign inst_and       = (type_r && func == `FUNC_AND  ) ? 1 : 0;
assign inst_or        = (type_r && func == `FUNC_OR   ) ? 1 : 0;
assign inst_nor       = (type_r && func == `FUNC_NOR  ) ? 1 : 0;
assign inst_xor       = (type_r && func == `FUNC_XOR  ) ? 1 : 0;
assign inst_sll       = (type_r && func == `FUNC_SLL  ) ? 1 : 0;
assign inst_srl       = (type_r && func == `FUNC_SRL  ) ? 1 : 0;
assign inst_sra       = (type_r && func == `FUNC_SRA  ) ? 1 : 0;
assign inst_sllv      = (type_r && func == `FUNC_SLLV ) ? 1 : 0;
assign inst_srlv      = (type_r && func == `FUNC_SRLV ) ? 1 : 0;
assign inst_srav      = (type_r && func == `FUNC_SRAV ) ? 1 : 0;
assign inst_jr        = (type_r && func == `FUNC_JR   ) ? 1 : 0;
assign inst_jalr      = (type_r && func == `FUNC_JALR ) ? 1 : 0;

// I-Type Instructions
assign inst_addi      = (opcode == `INST_ADDI  ) ? 1 : 0;
assign inst_addiu     = (opcode == `INST_ADDIU ) ? 1 : 0;
assign inst_sltiu     = (opcode == `INST_SLTIU ) ? 1 : 0;
assign inst_andi      = (opcode == `INST_ANDI  ) ? 1 : 0;
assign inst_ori       = (opcode == `INST_ORI   ) ? 1 : 0;
assign inst_xori      = (opcode == `INST_XORI  ) ? 1 : 0;
assign inst_lui       = (opcode == `INST_LUI   ) ? 1 : 0;
assign inst_lw        = (opcode == `INST_LW    ) ? 1 : 0;
assign inst_sw        = (opcode == `INST_SW    ) ? 1 : 0;
assign inst_beq       = (opcode == `INST_BEQ   ) ? 1 : 0;
assign inst_bne       = (opcode == `INST_BNE   ) ? 1 : 0;

// J-Type Instructions
assign inst_j         = (opcode == `INST_J     ) ? 1 : 0;
assign inst_jal       = (opcode == `INST_JAL   ) ? 1 : 0;

/* --- Determine control signals --- */

// LW
assign en_lw = inst_lw ? 1 : 0;

// ALUOp
assign cu_alu_op =
       (inst_addi || inst_addiu || inst_add ||
        inst_addu || inst_lw    || inst_sw    ) ? `ALU_OP_ADD  : // ADD
       (inst_sub  || inst_subu  || inst_beq   ) ? `ALU_OP_SUB  : // SUB
       (inst_slt  || inst_sltu  || inst_sltiu ) ? `ALU_OP_SLT  : // SLT
       (inst_and  || inst_andi                ) ? `ALU_OP_AND  : // AND
       (inst_or   || inst_ori                 ) ? `ALU_OP_OR   : // OR
       (inst_xor  || inst_xori                ) ? `ALU_OP_XOR  : // XOR
       (inst_nor                              ) ? `ALU_OP_NOR  : // NOR
       (inst_sll                              ) ? `ALU_OP_SLL  : // SLL
       (inst_srl                              ) ? `ALU_OP_SRL  : // SRL
       (inst_sra                              ) ? `ALU_OP_SRA  : // SRA
       (inst_sllv                             ) ? `ALU_OP_SLLV : // SLLV
       (inst_srlv                             ) ? `ALU_OP_SRLV : // SRLV
       (inst_srav                             ) ? `ALU_OP_SRAV : // SRAV
       `ALU_OP_DEFAULT;  // Default ALU operand (output the second ALU input)

// RegDst
assign cu_reg_dst =
       (inst_add   || inst_addu  || inst_sub   || inst_subu  ||
        inst_slt   || inst_sltu  || inst_and   || inst_or    ||
        inst_nor   || inst_xor   || inst_sll   || inst_srl   ||
        inst_sra   || inst_sllv  || inst_srlv  || inst_srav  ||
        inst_jalr                                            ) ? `REG_DST_RD :
       (inst_lui   || inst_addi  || inst_addiu || inst_sltiu ||
        inst_andi  || inst_ori   || inst_xori  || inst_lw    ) ? `REG_DST_RT :
       (inst_jal) ? `REG_DST_REG_31 : `REG_DST_DEFAULT;
// ALUSrc
assign cu_alu_src =
       (inst_addi  || inst_addiu || inst_sltiu || inst_andi ||
        inst_ori   || inst_xori  || inst_lw    || inst_sw   ) ? 1 : 0;

// RegWrite
assign en_reg_write =
       (inst_lui   || type_r     || inst_addi  || inst_addiu ||
        inst_sltiu || inst_andi  || inst_ori   || inst_xori  ||
        inst_add   || inst_addu  || inst_sub   || inst_subu  ||
        inst_slt   || inst_sltu  || inst_and   || inst_or    ||
        inst_nor   || inst_xor   || inst_sll   || inst_srl   ||
        inst_sra   || inst_sllv  || inst_srlv  || inst_srav  ||
        inst_lw    || inst_jal   || inst_jalr                ) ? 1 : 0;

// MemWrite
assign en_mem_write = (inst_sw) ? 1 : 0;

// RegSrc
assign cu_reg_src =
       // Extended immediate
       (inst_lui                                             ) ? `REG_SRC_IMM :

       // ALU result
       (inst_addi  || inst_addiu || inst_sltiu || inst_andi  ||
        inst_ori   || inst_xori  || inst_add   || inst_addu  ||
        inst_sub   || inst_subu  || inst_slt   || inst_sltu  ||
        inst_and   || inst_or    || inst_nor   || inst_xor   ||
        inst_sll   || inst_srl   || inst_sra   || inst_sllv  ||
        inst_srlv  || inst_srav                              ) ? `REG_SRC_ALU :

       // Data memory
       (inst_lw                                              ) ? `REG_SRC_MEM : 
       (inst_jal   || inst_jalr                              ) ? `REG_SRC_JMP_DST : `REG_SRC_DEFAULT;

// ExtOp
assign cu_ext_op =
       // shift left 16
       (inst_lui                               ) ? `EXT_OP_SFT16 :
       // signed extend
       (inst_add   || inst_addiu || inst_sltiu ) ? `EXT_OP_SIGNED :
       // unsigned extend
       (inst_andi  || inst_ori   || inst_xori  ||
        inst_lw    || inst_sw                  ) ? `EXT_OP_UNSIGNED : `EXT_OP_DEFAULT;

// NPCOp
assign cu_npc_op =
       // normal: next instruction
       (inst_lui   || inst_lw    || inst_sw    || inst_addi  ||
        inst_addiu || inst_sltiu || inst_andi  || inst_ori   ||
        inst_xori  || inst_add   || inst_addu  || inst_sub   ||
        inst_subu  || inst_slt   || inst_sltu  || inst_and   ||
        inst_or    || inst_nor   || inst_xor   || inst_sll   ||
        inst_srl   || inst_sra   || inst_sllv  || inst_srlv  ||
        inst_srav                                            ) ? `NPC_OP_NEXT :

       // BEQ
       // normal: next instruction
       (inst_beq && !zero) ? `NPC_OP_NEXT :
       // jump to target
       (inst_beq &&  zero) ? `NPC_OP_OFFSET :

       // BNE
       // normal: next instruction
       (inst_bne &&  zero) ? `NPC_OP_NEXT :
       // jump to target
       (inst_bne && !zero) ? `NPC_OP_OFFSET :

       // jump to instr_index
       (inst_j   || inst_jal)  ? `NPC_OP_JUMP :
       // jump to rs data
       (inst_jr  || inst_jalr) ? `NPC_OP_RS : `NPC_OP_DEFAULT;
endmodule
