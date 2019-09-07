`timescale 1ns / 1ps
`include "definitions.vh"

/*
 * Module: ZanPU ID/EX Register
 *
 * Input:
 * Output:
 */

module reg_id_ex(
           input  wire                       clk,
           input  wire                       rst,
           input  wire[31:0]                 reg1_data_in,
           input  wire[31:0]                 reg2_data_in,
           input  wire[4:0]                  rt_in,
           input  wire[4:0]                  rd_in,
           input  wire[4:0]                  sa_in,
           input  wire[15:0]                 imm16_in,

           input wire                        en_reg_write_in,
           input wire[`EXT_OP_LENGTH  - 1:0] cu_ext_op_in,
           input wire                        cu_alu_src_in,
           input wire[`ALU_OP_LENGTH  - 1:0] cu_alu_op_in,
           input wire                        en_mem_write_in,
           input wire[`REG_SRC_LENGTH - 1:0] cu_reg_src_in,
           input wire                        cu_reg_dst_in,

           output reg[31:0]                  reg1_data_out,
           output reg[31:0]                  reg2_data_out,
           output reg[4:0]                   rt_out,
           output reg[4:0]                   rd_out,
           output reg[4:0]                   sa_out,
           output reg[15:0]                  imm16_out,

           output reg                        en_reg_write_out,
           output reg[`EXT_OP_LENGTH  - 1:0] cu_ext_op_out,
           output reg                        cu_alu_src_out,
           output reg[`ALU_OP_LENGTH  - 1:0] cu_alu_op_out,
           output reg                        en_mem_write_out,
           output reg[`REG_SRC_LENGTH - 1:0] cu_reg_src_out,
           output reg                        cu_reg_dst_out
       );

// if rst/halt, zeroize all registers
wire zeroize;
assign zeroize = rst;

always @(posedge clk) begin
    if (zeroize) begin
        reg1_data_out    <= `INIT_32;
        reg2_data_out    <= `INIT_32;
        rt_out           <= `INIT_5;
        rd_out           <= `INIT_5;
        sa_out           <= `INIT_5;
        imm16_out        <= `INIT_16;

        en_reg_write_out <= `REG_WRITE_DIS;
        cu_ext_op_out    <= `EXT_OP_DEFAULT;
        cu_alu_src_out   <= `ALU_SRC_REG;
        cu_alu_op_out    <= `ALU_OP_DEFAULT;
        en_mem_write_out <= `MEM_WRITE_DIS;
        cu_reg_src_out   <= `REG_SRC_DEFAULT;
        cu_reg_dst_out   <= `REG_DST_RT;
    end
    else begin
        reg1_data_out    <= reg1_data_in;
        reg2_data_out    <= reg2_data_in;
        rt_out           <= rt_in;
        rd_out           <= rd_in;
        sa_out           <= sa_in;
        imm16_out        <= imm16_in;

        en_reg_write_out <= en_reg_write_in;
        cu_ext_op_out    <= cu_ext_op_in;
        cu_alu_src_out   <= cu_alu_src_in;
        cu_alu_op_out    <= cu_alu_op_in;
        en_mem_write_out <= en_mem_write_in;
        cu_reg_src_out   <= cu_reg_src_in;
        cu_reg_dst_out   <= cu_reg_dst_in;
    end
end
endmodule
