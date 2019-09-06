`timescale 1ns / 1ps
`include "definitions.vh"

/*
 * Module: ZanPU Multiplexers
 */

module reg_dst_mux(
           input  wire      cu_reg_dst,
           input  wire[4:0] rt,
           input  wire[4:0] rd,

           output wire[4:0] mux_out
       );

assign mux_out = (cu_reg_dst == `REG_DST_RT) ? rt : rd;
endmodule

module alu_src_mux(
           input  wire       cu_alu_src,
           input  wire[31:0] rt,
           input  wire[31:0] imm,

           output wire[31:0] mux_out
    );

assign mux_out = (cu_alu_src == `ALU_SRC_REG) ? rt : imm;
endmodule

module reg_src_mux(
           input  wire[`REG_SRC_LENGTH - 1:0] cu_reg_src,
           input  wire[31:0]                  alu_result,
           input  wire[31:0]                  read_mem_data,
           input  wire[31:0]                  extend_imm,

           output wire[31:0]                  mux_out
    );

assign mux_out = (cu_reg_src == `REG_SRC_ALU) ? alu_result :
       (cu_reg_src == `REG_SRC_MEM) ? read_mem_data :
       extend_imm;
endmodule
