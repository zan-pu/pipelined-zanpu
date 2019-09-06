`timescale 1ns / 1ps

/*
 * Module: ZanPU Definition File
 */

/* Micellanenous */

// Instruction Memory Length
`define IM_LENGTH       1023

// Init reg/wire with zeros
`define INIT_5          5'b00000
`define INIT_6          6'b000000
`define INIT_32         32'h00000000

/* Control Signals */

// Register Write EN
`define REG_WRITE_EN    1'b1       // Enable register write 
`define REG_WRITE_DIS   1'b0       // Disable register write

// ExtOp Control Signals
`define EXT_OP_LENGTH   2          // Length of Signal ExtOp
`define EXT_OP_DEFAULT  2'b00      // ExtOp default value
`define EXT_OP_SFT16    2'b01      // LUI: Shift Left 16
`define EXT_OP_SIGNED   2'b10      // ADDIU: `imm16` signed extended to 32 bit
`define EXT_OP_UNSIGNED 2'b11      // LW, SW: `imm16` unsigned extended to 32 bit

// ALUSrc Control Signals
`define ALU_SRC_REG     1'b0       // ALU source: register file
`define ALU_SRC_IMM     1'b1       // ALU Source: immediate

// ALU Control Signals
`define ALU_OP_LENGTH   3          // Length of signal ALUOp
`define ALU_OP_DEFAULT  3'b000     // ALUOp default value
`define ALU_OP_ADD      3'b001     // ALUOp ADD
`define ALU_OP_SUB      3'b010     // ALUOp SUB

// Memory Write EN
`define MEM_WRITE_EN    1'b1       // Enable memory write
`define MEM_WRITE_DIS   1'b0       // Disable memory write

// RegSrc Control Signals
`define REG_SRC_LENGTH  2          // Length of signal RegSrc
`define REG_SRC_DEFAULT 2'b00      // Register default value
`define REG_SRC_ALU     2'b01      // Register write source: ALU
`define REG_SRC_MEM     2'b10      // Register write source: Data Memory
`define REG_SRC_IMM     2'b11      // Register write source: Extended immediate

// RegDst Control Signals
`define REG_DST_RT      1'b0       // Register write destination: rt
`define REG_DST_RD      1'b1       // Register write destination: rd

// NPCOp Control Signals
`define NPC_OP_LENGTH   3          // Length of NPCOp
`define NPC_OP_DEFAULT  3'b000     // NPCOp default value
`define NPC_OP_NEXT     3'b001     // Next instruction: normal
`define NPC_OP_JUMP     3'b010     // Next instruction: J
`define NPC_OP_OFFSET   3'b011     // Next instruction: BEQ

// Branching signals
`define BRANCH_TRUE     1'b1       // Branch to true
`define BRANCH_FALSE    1'b0       // Branch to false
