`timescale 1ns / 1ps
`include "definitions.vh"

/*
 * Module: ZanPU ALU
 *
 * Input:  .alu_input_1 .alu_input_2 .cu_alu_op
 * Output: .alu_result
 */

module alu(
           input  wire[31:0]                   alu_input_1,
           input  wire[31:0]                   alu_input_2,
           input  wire[4:0]                    sa,
           input  wire[`ALU_OP_LENGTH  - 1:0]  cu_alu_op,

           output wire[31:0]                   alu_result,
           output wire                         overflow
       );

reg[32:0] alu_temp_result;
assign alu_result = alu_temp_result[31:0];

// detect overflow
assign overflow = (alu_temp_result[32] != alu_temp_result[31]) ? `OVERFLOW_TRUE : `OVERFLOW_FALSE;

// displacement defined by sa or rs
wire[4:0] displacement;
assign displacement =
       (cu_alu_op == `ALU_OP_SLL ||
        cu_alu_op == `ALU_OP_SRL ||
        cu_alu_op == `ALU_OP_SRA) ? sa : alu_input_1[4:0];

// compare rs and rt
wire[31:0] diff;
assign diff = (alu_input_1 < alu_input_2) ? 32'h00000001 : 32'h00000000;

always @ (*) begin
    case (cu_alu_op)
        // normal arithmetic operations
        `ALU_OP_ADD:
            alu_temp_result <= {alu_input_1[31], alu_input_1} + {alu_input_2[31], alu_input_2};
        `ALU_OP_SUB:
            alu_temp_result <= {alu_input_1[31], alu_input_1} - {alu_input_2[31], alu_input_2};

        `ALU_OP_SLT:
            alu_temp_result <= diff;

        // bit operations
        `ALU_OP_AND:
            alu_temp_result <= {alu_input_1[31], alu_input_1} & {alu_input_2[31], alu_input_2};
        `ALU_OP_OR :
            alu_temp_result <= {alu_input_1[31], alu_input_1} | {alu_input_2[31], alu_input_2};
        `ALU_OP_NOR:
            alu_temp_result <= (({alu_input_1[31], alu_input_1} & ~{alu_input_2[31], alu_input_2}) |
                                (~{alu_input_1[31], alu_input_1} & {alu_input_2[31], alu_input_2}));
        `ALU_OP_XOR:
            alu_temp_result <= {alu_input_1[31], alu_input_1} ^ {alu_input_2[31], alu_input_2};

        // shift left logically
        `ALU_OP_SLL:
            alu_temp_result <= {alu_input_2[31], alu_input_2} << displacement;
        `ALU_OP_SLLV:
            alu_temp_result <= {alu_input_2[31], alu_input_2} << displacement;

        // shift right logically
        `ALU_OP_SRL:
            alu_temp_result <= {alu_input_2[31], alu_input_2} >> displacement;
        `ALU_OP_SRLV:
            alu_temp_result <= {alu_input_2[31], alu_input_2} >> displacement;

        // shift right arithmetically
        `ALU_OP_SRA:
            alu_temp_result <= ({{31{alu_input_2[31]}}, 1'b0} << (~displacement)) | (alu_input_2 >> displacement);
        `ALU_OP_SRAV:
            alu_temp_result <= ({{31{alu_input_2[31]}}, 1'b0} << (~displacement)) | (alu_input_2 >> displacement);

        `ALU_OP_DEFAULT:
            alu_temp_result <= {alu_input_2[31], alu_input_2};
    endcase
end
endmodule
