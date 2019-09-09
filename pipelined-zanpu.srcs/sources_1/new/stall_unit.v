`timescale 1ns / 1ps
`include "definitions.vh"

/*
 * Module: ZanPU Stall Unit
 *
 * Input:
 * Output:
 */

module stall_unit(
           input wire[1:0] stall_in,
           output wire[3:0] stall_C
       );

assign stall_C =
       (stall_in == `EXE_REGW) ? `EXE_STALL :
       (stall_in == `MEM_REGW) ? `MEM_STALL : `NON_STALL;

endmodule
