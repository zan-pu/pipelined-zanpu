`timescale 1ns / 1ps

/*
 * Module: ZanPU Definition File
 */

/* --- Micellanenous --- */

// Instruction Memory Length
`define IM_LENGTH       1023
`define DM_LENGTH       1023

`define REG_31_ADDR     5'b11111

// Init reg/wire with zeros
`define INIT_4          4'b0000
`define INIT_5          5'b00000
`define INIT_16         16'h0000
`define INIT_32         32'h00000000

/* --- Instruction Decode --- */

// R-Type instructions
`define INST_R_TYPE     6'b000000  // R-Type opcode

// func code
`define FUNC_ADD        6'b100000  // ADD
`define FUNC_ADDU       6'b100001  // ADDU
`define FUNC_SUB        6'b100010  // SUB
`define FUNC_SUBU       6'b100011  // SUBU
`define FUNC_SLT        6'b101010  // SLT
`define FUNC_SLTU       6'b101011  // SLTU
`define FUNC_AND        6'b100100  // AND
`define FUNC_OR         6'b100101  // OR
`define FUNC_NOR        6'b100111  // NOR
`define FUNC_XOR        6'b100110  // XOR
`define FUNC_SLL        6'b000000  // SLL
`define FUNC_SRL        6'b000010  // SRL
`define FUNC_SRA        6'b000011  // SRA
`define FUNC_SLLV       6'b000100  // SLLV
`define FUNC_SRLV       6'b000110  // SRLV
`define FUNC_SRAV       6'b000111  // SRAV

`define FUNC_JR         6'b001000  // JR
`define FUNC_JALR       6'b001001  // JALR

// I-Type instructions
`define INST_ADDI       6'b001000  // ADDI
`define INST_ADDIU      6'b001001  // ADDIU
`define INST_SLTIU      6'b001011  // SLTIU
`define INST_ANDI       6'b001100  // ANDI
`define INST_ORI        6'b001101  // ORI
`define INST_XORI       6'b001110  // XORI
`define INST_LUI        6'b001111  // LUI
`define INST_LW         6'b100011  // LW
`define INST_SW         6'b101011  // SW
`define INST_BEQ        6'b000100  // BEQ
`define INST_BNE        6'b000101  // BNE

// J-Type instructions
`define INST_J          6'b000010  // J
`define INST_JAL        6'b000011  // JAL

/* --- Control Signals --- */

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
`define ALU_OP_LENGTH   4          // Length of signal ALUOp
`define ALU_OP_DEFAULT  4'b0000    // ALUOp default value
`define ALU_OP_ADD      4'b0001    // ALU add
`define ALU_OP_SUB      4'b0010    // ALU sub
`define ALU_OP_SLT      4'b0011    // ALU slt
`define ALU_OP_AND      4'b0100    // ALU and
`define ALU_OP_OR       4'b0101    // ALU or
`define ALU_OP_XOR      4'b0110    // ALU xor
`define ALU_OP_NOR      4'b0111    // ALU nor
`define ALU_OP_SLL      4'b1000    // ALU sll, with respect to sa
`define ALU_OP_SRL      4'b1001    // ALU srl, with respect to sa
`define ALU_OP_SRA      4'b1010    // ALU sra, with respect to sa
`define ALU_OP_SLLV     4'b1011    // ALU sllv, with respect to rs
`define ALU_OP_SRLV     4'b1100    // ALU srlv, with respect to rs
`define ALU_OP_SRAV     4'b1101    // ALU srav, with respect to rs

`define OVERFLOW_TRUE   1'b1
`define OVERFLOW_FALSE  1'b0

// Memory Write EN
`define MEM_WRITE_EN    1'b1       // Enable memory write
`define MEM_WRITE_DIS   1'b0       // Disable memory write

// RegSrc Control Signals
`define REG_SRC_LENGTH  3          // Length of signal RegSrc
`define REG_SRC_DEFAULT 3'b000     // Register default value
`define REG_SRC_ALU     3'b001     // Register write source: ALU
`define REG_SRC_MEM     3'b010     // Register write source: Data Memory
`define REG_SRC_IMM     3'b011     // Register write source: Extended immediate
`define REG_SRC_JMP_DST 3'b100     // Register write source: Jump destination

// RegDst Control Signals
`define REG_DST_LENGTH  2
`define REG_DST_DEFAULT 2'b00      // Register write destination: default
`define REG_DST_RT      2'b01      // Register write destination: rt
`define REG_DST_RD      2'b10      // Register write destination: rd
`define REG_DST_REG_31  2'b11      // Register write destination: 31 bit gpr

// NPCOp Control Signals
`define NPC_OP_LENGTH   3          // Length of NPCOp
`define NPC_OP_DEFAULT  3'b000     // NPCOp default value
`define NPC_OP_NEXT     3'b001     // Next instruction: {PC + 4}
`define NPC_OP_JUMP     3'b010     // Next instruction: {PC[31:28], instr_index, 2'b00}
`define NPC_OP_OFFSET   3'b011     // Next instruction: {PC + 4 + offset}
`define NPC_OP_RS       3'b100     // Next instruction: {rs}

// Branching signals
`define BRANCH_TRUE     1'b1       // Branch to true
`define BRANCH_FALSE    1'b0       // Branch to false

/* --- Hazard Control --- */

// Forward Control Signals
`define FORWARD_ONE_CYCLE 2'b10
`define FORWARD_TWO_CYCLE 2'b01

// Stall IN Signals
`define EXE_REGW          2'b01
`define MEM_REGW          2'b10
`define NON_REGW          2'b00

// Stall Control Signals
`define EXE_STALL         4'b0111
`define MEM_STALL         4'b1111
`define NON_STALL         4'b0000

// LW init
`define EN_LW_DEFAULT     1'b0