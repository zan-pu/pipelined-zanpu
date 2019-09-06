`timescale 1ns / 1ps
`include "definitions.vh"

/*
 * Module: ZanPU Branch Judge
 *
 * Input:  .reg1_data .reg2_data
 * Output: .zero
 */

module branch_judge(
           input  wire[31:0] reg1_data,
           input  wire[31:0] reg2_data,

           output wire       zero       // Calculate whether rs - rt is zero
       );

// rs - rt = diff
wire[32:0] diff;

assign diff = {reg1_data[31], reg1_data} - {reg2_data[31], reg2_data};
assign zero = (diff == 0) ? `BRANCH_TRUE : `BRANCH_FALSE;
endmodule
