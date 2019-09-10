`timescale 1ns / 1ps


module soc(
    input wire clk,
    input wire rst,
    
    input wire[3:0] btn_key
    );
    
    /*
    vga
    0xffff_0000
    0xffff_0004
    ...
    0xffff_003c
    
    btn
    0ffff_f000
    **/
    
    wire[3:0] btn_key_t;
    assign btn_key_t = btn_key;
    
    wire vga_wen;
    wire[31:0] vga_wdata;
    wire[3:0] vga_addr;
    wire[31:0] vga_rdata;
    
    wire[31:0] io_addr;
    wire[31:0] io_rdata;
    wire io_wen;
    wire[31:0] io_wdata;
    assign io_rdata = (io_addr[31:6] == 26'b1111_1111_1111_1111_0000_0000_00) ? vga_rdata : {27'b0, btn_key_t};
    
    assign vga_wen = io_wen;
    assign vga_wdata = io_wdata;
    assign vga_addr = io_addr[5:2];
    
    vga vga0(
        .wen(vga_wen),
        .wdata(vga_wdata),
        .addr(vga_addr),
        .rdata(vga_rdata)
    );
    
    
    zanpu_top(
        .clk(clk),
        .rst(rst),
        .io_wen(io_wen),
        .io_addr(io_addr),
        .io_wdata(io_wdata),
        .io_rdata(io_rdata) 
    );
endmodule
