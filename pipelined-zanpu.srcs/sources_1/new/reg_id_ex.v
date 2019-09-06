`timescale 1ns / 1ps
`include "definitions.v"

/*
 * Module: ZanPU ID/EX Register
 *
 * Input:
 * Output:
 */

module reg_id_ex(
           input wire        clk,
           input wire        rst,
           input wire[31:0]  reg1_data_in,
           input wire[31:0]  reg2_data_in,
           input wire[4:0]   rt_in,
           input wire[4:0]   rd_in,
           input wire[15:0]  imm16_in,

           output wire[31:0] reg1_data_out,
           output wire[31:0] reg2_data_out,
           output wire[4:0]  rt_out,
           output wire[4:0]  rd_out,
           output wire[15:0] imm16_out
       );
endmodule
