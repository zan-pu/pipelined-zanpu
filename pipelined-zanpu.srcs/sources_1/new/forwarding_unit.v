`timescale 1ns / 1ps
`include "definitions.vh"

/*
 * Module: ZanPU Forwarding Unit
 *
 * Input:
 * Output:
 */

module forwarding_unit(
           input  wire      en_ex_mem_regwrite,
           input  wire[4:0] ex_mem_regdes,
           input  wire[4:0] id_ex_rs,
           input  wire[4:0] id_ex_rt,
           input  wire      en_mem_wb_regwrite,
           input  wire[4:0] mem_wb_regdes,

           output wire[1:0] forward_A,
           output wire[1:0] forward_B
       );

assign forward_A = (en_ex_mem_regwrite == 1 && ex_mem_regdes == id_ex_rs) ? 2'b10:
       (en_mem_wb_regwrite == 1 && mem_wb_regdes == id_ex_rs &&
       (ex_mem_regdes != id_ex_rs || en_ex_mem_regwrite == 0)) ? 2'b01 : 2'b00;

assign forward_B = (en_ex_mem_regwrite == 1 && ex_mem_regdes == id_ex_rt) ? 2'b10:
       (en_mem_wb_regwrite == 1 && mem_wb_regdes == id_ex_rt &&
       (ex_mem_regdes != id_ex_rt || en_ex_mem_regwrite == 0)) ? 2'b01 : 2'b00;

endmodule
