`timescale 1ns / 1ps

/*
 * Module: ZanPU Definition File
 */

/* Micellanenous */

// Instruction Memory Length
`define IM_LENGTH      1023

// Init reg/wire with zeros
`define INIT_5         5'b00000
`define INIT_6         6'b000000
`define INIT_32        32'h00000000


/* Control Signals */

// Branching signals
`define BRANCH_LENGTH  2
`define BRANCH_DEFAULT 2'b00
`define BRANCH_TRUE    2'b01
`define BRANCH_EQUAL   2'b10
`define BRANCH_FALSE   2'b11

// NPCOp
`define NPC_OP_LENGTH  2
`define NPC_OP_DEFAULT 2'b00
`define NPC_OP_NORMAL  2'b01
`define NPC_OP_J       2'b10
`define NPC_OP_BEQ     2'b11
