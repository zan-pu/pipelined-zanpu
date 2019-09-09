`timescale 1ns / 1ps
`include "definitions.vh"

/*
 * Module: ZanPU PC
 *
 * Input:  .clk .rst .npc
 * Output: .pc
 */

module pc(
           input  wire       clk,
           input  wire       rst,
           input  wire[31:0] npc,

           input  wire[3:0]  stall_C,

           output reg[31:0]  pc
       );

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        pc <= `INIT_32;
    end
    else if(stall_C[0] == 0) begin
        pc <= npc;
    end
    else begin

    end
end
endmodule
