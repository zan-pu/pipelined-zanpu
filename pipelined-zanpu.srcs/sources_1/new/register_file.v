`timescale 1ns / 1ps
`include "definitions.vh"

/*
 * Module: ZanPU Register File
 *
 * Input:
 * Output:
 */

module register_file(
           input  wire       clk,
           input  wire[4:0]  rs,
           input  wire[4:0]  rt,
           input  wire[4:0]  write_reg_addr, // rs or rd, defined in WB stage
           input  wire[31:0] write_data,

           input  wire       en_reg_write,

           output wire       zero,           // bigger than, smaller than or equal to zero
           output wire[31:0] reg1_data,
           output wire[31:0] reg2_data
       );

// Register file general purpose register
reg[31:0] gpr[31:0];

// Get register data from GPR
assign reg1_data = (rs == `INIT_5) ? `INIT_32 : gpr[rs];
assign reg2_data = (rt == `INIT_5) ? `INIT_32 : gpr[rt];

// Result of rs - rt, in order to calculate branching information
wire[31:0] diff;
reg[32:0]  temp;

assign diff = temp[31:0];
assign zero = (diff == 0) ? `BRANCH_TRUE : `BRANCH_FALSE;

// Calculate rs - rt
always @ (*) begin
    temp <= {reg1_data[31], reg1_data} - {reg2_data[31], reg2_data};
end

// Write data back to register
always @ (posedge clk) begin
    if (en_reg_write) begin
        gpr[write_reg_addr] = write_data;
    end
end
endmodule
