`timescale 1ns / 1ps
`include "definitions.v"

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

           output reg[31:0]  pc
       );

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        pc <= `INIT_32;
    end
    else begin
        pc <= npc;
    end
end
endmodule
