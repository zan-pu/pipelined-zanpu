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
           input  wire[31:0]                 jmp_dst_in,
           input  wire[4:0]                  rs_in,
           input  wire[4:0]                  rt_in,
           input  wire[4:0]                  rd_in,
           input  wire[4:0]                  sa_in,
           input  wire[15:0]                 imm16_in,

           input wire                        en_reg_write_in,
           input wire                        en_lw_id_ex_in,
           input wire[`EXT_OP_LENGTH  - 1:0] cu_ext_op_in,
           input wire                        cu_alu_src_in,
           input wire[`ALU_OP_LENGTH  - 1:0] cu_alu_op_in,
           input wire                        en_mem_write_in,
           input wire[`REG_SRC_LENGTH - 1:0] cu_reg_src_in,
           input wire[`REG_DST_LENGTH - 1:0] cu_reg_dst_in,
           input wire[3:0]                   stall_C,
           input wire[31:0]                  lw_stall_data,
           input wire[4:0]                   lw_mem_addr,

           output reg[31:0]                  reg1_data_out,
           output reg[31:0]                  reg2_data_out,
           output reg[31:0]                  jmp_dst_out,
           output reg[4:0]                   rs_out,
           output reg[4:0]                   rt_out,
           output reg[4:0]                   rd_out,
           output reg[4:0]                   sa_out,
           output reg[15:0]                  imm16_out,

           output reg                        en_reg_write_out,
           output reg                        en_lw_id_ex_out,
           output reg[`EXT_OP_LENGTH  - 1:0] cu_ext_op_out,
           output reg                        cu_alu_src_out,
           output reg[`ALU_OP_LENGTH  - 1:0] cu_alu_op_out,
           output reg                        en_mem_write_out,
           output reg[`REG_SRC_LENGTH - 1:0] cu_reg_src_out,
           output reg[`REG_DST_LENGTH - 1:0] cu_reg_dst_out
       );

// if rst/halt, zeroize all registers
wire zeroize;
assign zeroize = rst;

// state machine for stalling
reg[1:0] temp_state;
reg[31:0] tempdata_1;
reg[31:0] tempdata_2;

always @ (posedge clk) begin
    if (stall_C[2] == 1 && stall_C[3] == 1 && lw_mem_addr == rs_in) begin
        tempdata_1 <= lw_stall_data;
        temp_state <= 2'b01;
    end
    if (stall_C[2] == 1 && stall_C[3] == 1 && lw_mem_addr == rt_in) begin
        tempdata_2 <= lw_stall_data;
        temp_state <= 2'b10;
    end

    if (zeroize) begin
        reg1_data_out    <= `INIT_32;
        reg2_data_out    <= `INIT_32;
        jmp_dst_out      <= `INIT_32;
        rs_out           <= `INIT_5;
        rt_out           <= `INIT_5;
        rd_out           <= `INIT_5;
        sa_out           <= `INIT_5;
        imm16_out        <= `INIT_16;

        en_reg_write_out <= `REG_WRITE_DIS;
        en_lw_id_ex_out  <= `EN_LW_DEFAULT;
        cu_ext_op_out    <= `EXT_OP_DEFAULT;
        cu_alu_src_out   <= `ALU_SRC_REG;
        cu_alu_op_out    <= `ALU_OP_DEFAULT;
        en_mem_write_out <= `MEM_WRITE_DIS;
        cu_reg_src_out   <= `REG_SRC_DEFAULT;
        cu_reg_dst_out   <= `REG_DST_DEFAULT;
        tempdata_1       <= `INIT_32;
        tempdata_2       <= `INIT_32;
        temp_state       <= 2'b00;
    end
    else if(stall_C[2] == 0) begin
        if (temp_state == 2'b01) begin
            reg1_data_out <= tempdata_1;
            reg2_data_out <= reg2_data_in;
            temp_state    <= 2'b00;
        end
        else if(temp_state == 2'b10) begin
            reg1_data_out <= reg1_data_in;
            reg2_data_out <= tempdata_2;
            temp_state    <= 2'b00;
        end
        else begin
            reg1_data_out <= reg1_data_in;
            reg2_data_out <= reg2_data_in;
        end

        jmp_dst_out      <= jmp_dst_in;
        rs_out           <= rs_in;
        rt_out           <= rt_in;
        rd_out           <= rd_in;
        sa_out           <= sa_in;
        imm16_out        <= imm16_in;

        en_reg_write_out <= en_reg_write_in;
        en_lw_id_ex_out  <= en_lw_id_ex_in;
        cu_ext_op_out    <= cu_ext_op_in;
        cu_alu_src_out   <= cu_alu_src_in;
        cu_alu_op_out    <= cu_alu_op_in;
        en_mem_write_out <= en_mem_write_in;
        cu_reg_src_out   <= cu_reg_src_in;
        cu_reg_dst_out   <= cu_reg_dst_in;
    end
    else if(stall_C[2] == 1 && stall_C[3] == 0) begin
        reg1_data_out    <= `INIT_32;
        reg2_data_out    <= `INIT_32;
        jmp_dst_out      <= `INIT_32;
        rs_out           <= `INIT_5;
        rt_out           <= `INIT_5;
        rd_out           <= `INIT_5;
        sa_out           <= `INIT_5;
        imm16_out        <= `INIT_16;

        en_reg_write_out <= `REG_WRITE_DIS;
        en_lw_id_ex_out  <= `EN_LW_DEFAULT;
        cu_ext_op_out    <= `EXT_OP_DEFAULT;
        cu_alu_src_out   <= `ALU_SRC_REG;
        cu_alu_op_out    <= `ALU_OP_DEFAULT;
        en_mem_write_out <= `MEM_WRITE_DIS;
        cu_reg_src_out   <= `REG_SRC_DEFAULT;
        cu_reg_dst_out   <= `REG_DST_DEFAULT;
    end
    else begin
        // do nothing
    end
end

endmodule
