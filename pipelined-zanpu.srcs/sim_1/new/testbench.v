`timescale 1ns / 1ps

/*
 * Testbench
 */

module testbench();
reg clk;
reg rst;
zanpu_top u_zanpu_top(
              .clk (clk ),
              .rst (rst )
          );

initial begin
    // Load instructions
    $readmemh("../../../pipelined-zanpu.tbcode/instructions.txt", u_zanpu_top.u_instruction_memory.im);
    // Load register initial values
    $readmemh("../../../pipelined-zanpu.tbcode/register.txt", u_zanpu_top.u_register_file.gpr);
    // Load memory data initial values
    $readmemh("../../../pipelined-zanpu.tbcode/data_memory.txt", u_zanpu_top.u_data_memory.dm);

    rst = 1;
    clk = 0;

    #30 rst = 0;
    // #80 $display("$10 value: %h", ZAN_TOP.ZAN_REG_FILE.gpr[10]);
    #500 $stop;
end

always
    #20 clk = ~clk;
endmodule
