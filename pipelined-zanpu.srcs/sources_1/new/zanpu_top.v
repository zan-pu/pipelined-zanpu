`timescale 1ns / 1ps
`include "definitions.vh"

/*
 * Module: ZanPU Top Module
 *
 * Input:  .clk .rst
 * Output:
 */

module zanpu_top(
           input wire clk,
           input wire rst
       );

/*
 * Instantiate modules
 */

/* --- Stage 1: Instruction Fetch --- */

/* pc, npc and instruction_memory */

wire[31:0] pc;
wire[31:0] npc;
wire[31:0] instruction;
wire[3:0]  stall_C;
wire[1:0]  stall_op;

pc u_pc(
       .clk (clk ),
       .rst (rst ),
       .npc (npc ),
       .stall_C (stall_C),
       .pc  (pc  )
   );

instruction_memory u_instruction_memory(
                       .instruction_addr (pc[11:2]    ),
                       .instruction      (instruction )
                   );



/* id/id register */

wire[31:0] instruction_out;

reg_if_id u_reg_if_id(
              .clk              (clk              ),
              .rst              (rst              ),
              .instructions_in  (instruction      ),
              .stall_C          (stall_C          ),
              .instructions_out (instruction_out )
          );

/* --- Stage 2: Instruction Decode --- */

// Decode instruction type and function
wire[5:0] opcode;
wire[5:0] func;

// Decode registers
wire[4:0] rs;
wire[4:0] rt;
wire[4:0] rd;
wire[4:0] sa;

// Decode 16 bit and 26 bit immediates
wire[15:0] imm16;
wire[25:0] imm26;

// Assign decoded instruction to variables
assign opcode = instruction[31:26];
assign func   = instruction[5:0];
assign rs     = instruction[25:21];
assign rt     = instruction[20:16];
assign rd     = instruction[15:11];
assign sa     = instruction[10:6];
assign imm16  = instruction[15:0];
assign imm26  = instruction[25:0];

wire[4:0] write_reg_addr;
wire[31:0] write_data;
wire[31:0] reg1_data;
wire[31:0] reg2_data;

wire                        zero;
wire                        en_reg_write;
wire[`EXT_OP_LENGTH  - 1:0] cu_ext_op;
wire                        cu_alu_src;
wire[`ALU_OP_LENGTH  - 1:0] cu_alu_op;
wire                        en_mem_write;
wire[`REG_SRC_LENGTH - 1:0] cu_reg_src;
wire[`REG_DST_LENGTH - 1:0] cu_reg_dst;
wire[`NPC_OP_LENGTH  - 1:0] cu_npc_op;
wire                        en_lw;

control_unit u_control_unit(
                 .rst          (rst          ),
                 .opcode       (opcode       ),
                 .sa           (sa           ),
                 .func         (func         ),
                 .zero         (zero         ),
                 .en_reg_write (en_reg_write ),
                 .cu_ext_op    (cu_ext_op    ),
                 .cu_alu_src   (cu_alu_src   ),
                 .cu_alu_op    (cu_alu_op    ),
                 .en_mem_write (en_mem_write ),
                 .cu_reg_src   (cu_reg_src   ),
                 .cu_reg_dst   (cu_reg_dst   ),
                 .cu_npc_op    (cu_npc_op    ),
                 .en_lw        (en_lw)
             );

wire[4:0] destination_reg_wb;
wire      en_reg_write_wb;
wire[4:0] destination_reg;
wire[4:0]  destination_reg_out;
wire                        en_reg_write_out;
wire                        en_reg_write_mem;
wire en_lw_id_ex_out;
wire en_lw_ex_mem_out;

register_file u_register_file(
                  .clk            (clk                ),
                  .rs             (rs                 ),
                  .rt             (rt                 ),
                  .write_reg_addr (destination_reg_wb ),
                  .write_data     (write_data         ),
                  .dst_reg_exe    (destination_reg    ),
                  .dst_reg_mem    (destination_reg_out),
                  .en_reg_write   (en_reg_write_wb    ),
                  .en_reg_write_exe(en_reg_write_out  ),
                  .en_reg_write_mem(en_reg_write_mem  ),
                  .en_lw_exe      (en_lw_id_ex_out    ),
                  .en_lw_mem      (en_lw_ex_mem_out   ),
                  .reg1_data      (reg1_data          ),
                  .reg2_data      (reg2_data          ),
                  .stall_signal   (stall_op           )
              );

wire[31:0] jmp_dst;

stall_unit u_stall_unit(
               .stall_in (stall_op ),
               .stall_C  (stall_C  )
           );

npc u_npc(
        .pc        (pc        ),
        .imm16     (imm16     ),
        .imm26     (imm26     ),
        .reg1_data (reg1_data ),
        .cu_npc_op (cu_npc_op ),
        .npc       (npc       ),
        .jmp_dst   (jmp_dst   )
    );

branch_judge u_branch_judge(
                 .reg1_data (reg1_data ),
                 .reg2_data (reg2_data ),
                 .zero      (zero      )
             );

wire[31:0]                  reg1_data_out;
wire[31:0]                  reg2_data_out;
wire[31:0]                  jmp_dst_out;
wire[4:0]                   rs_out;
wire[4:0]                   rt_out;
wire[4:0]                   rd_out;
wire[4:0]                   sa_out;
wire[15:0]                  imm16_out;
wire[`EXT_OP_LENGTH  - 1:0] cu_ext_op_out;
wire                        cu_alu_src_out;
wire[`ALU_OP_LENGTH  - 1:0] cu_alu_op_out;
wire                        en_mem_write_out;
wire[`REG_SRC_LENGTH - 1:0] cu_reg_src_out;
wire[`REG_DST_LENGTH - 1:0] cu_reg_dst_out;
wire[31:0]                  read_mem_data;
wire[31:0]                  read_mem_data_out;

reg_id_ex u_reg_id_ex(
              .clk              (clk              ),
              .rst              (rst              ),
              .reg1_data_in     (reg1_data        ),
              .reg2_data_in     (reg2_data        ),
              .jmp_dst_in       (jmp_dst          ),
              .rs_in            (rs               ),
              .rt_in            (rt               ),
              .rd_in            (rd               ),
              .sa_in            (sa               ),
              .imm16_in         (imm16            ),
              .en_reg_write_in  (en_reg_write     ),
              .en_lw_id_ex_in   (en_lw            ),
              .cu_ext_op_in     (cu_ext_op        ),
              .cu_alu_src_in    (cu_alu_src       ),
              .cu_alu_op_in     (cu_alu_op        ),
              .en_mem_write_in  (en_mem_write     ),
              .cu_reg_src_in    (cu_reg_src       ),
              .cu_reg_dst_in    (cu_reg_dst       ),
              .stall_C          (stall_C          ),
              .lw_stall_data    (read_mem_data    ),
              .lw_mem_addr      (destination_reg_out),
              .reg1_data_out    (reg1_data_out    ),
              .reg2_data_out    (reg2_data_out    ),
              .jmp_dst_out      (jmp_dst_out      ),
              .rs_out           (rs_out           ),
              .rt_out           (rt_out           ),
              .rd_out           (rd_out           ),
              .sa_out           (sa_out           ),
              .imm16_out        (imm16_out        ),
              .en_reg_write_out (en_reg_write_out ),
              .en_lw_id_ex_out  (en_lw_id_ex_out  ),
              .cu_ext_op_out    (cu_ext_op_out    ),
              .cu_alu_src_out   (cu_alu_src_out   ),
              .cu_alu_op_out    (cu_alu_op_out    ),
              .en_mem_write_out (en_mem_write_out ),
              .cu_reg_src_out   (cu_reg_src_out   ),
              .cu_reg_dst_out   (cu_reg_dst_out   )
          );

/* --- Stage 3: Execution --- */

wire[31:0] extended_imm;

extend u_extend(
           .imm16        (imm16_out     ),
           .cu_ext_op    (cu_ext_op_out ),
           .extended_imm (extended_imm  )
       );


reg_dst_mux u_reg_dst_mux(
                .cu_reg_dst (cu_reg_dst_out  ),
                .rt         (rt_out          ),
                .rd         (rd_out          ),
                .mux_out    (destination_reg )
            );

wire[31:0] alu_src_mux_out;
wire[31:0] alu_result;
wire[31:0] forward_mux_out_1;
wire[31:0] forward_mux_out_2;

alu_src_mux u_alu_src_mux(
                .cu_alu_src (cu_alu_src_out    ),
                .rt         (forward_mux_out_2 ),
                .imm        (extended_imm      ),
                .mux_out    (alu_src_mux_out   )
            );


alu u_alu(
        .alu_input_1 (forward_mux_out_1 ),
        .alu_input_2 (alu_src_mux_out   ),
        .sa          (sa_out            ),
        .cu_alu_op   (cu_alu_op_out     ),
        .alu_result  (alu_result        )
    );

wire[1:0] forward_A;
wire[1:0] forward_B;

// control signals to be forwarded to MEM stage
wire                        en_mem_write_mem;
wire[`REG_SRC_LENGTH - 1:0] cu_reg_src_mem;

wire[31:0] alu_result_out;
wire[31:0] reg2_data_mem;
wire[31:0] extended_imm_out;

forwarding_unit u_forwarding_unit(
                    .en_ex_mem_regwrite (en_reg_write_mem    ),
                    .ex_mem_regdes      (destination_reg_out ),
                    .id_ex_rs           (rs_out              ),
                    .id_ex_rt           (rt_out              ),
                    .en_mem_wb_regwrite (en_reg_write_wb     ),
                    .mem_wb_regdes      (destination_reg_wb  ),
                    .forward_A          (forward_A           ),
                    .forward_B          (forward_B           )
                );

forward_mux u_forward_mux_1(
                .forward_C  (forward_A         ),
                .rs_rt_imm  (reg1_data_out     ),
                .write_data (write_data        ),
                .alu_result (alu_result_out    ),
                .mux_out    (forward_mux_out_1 )
            );

forward_mux u_forward_mux_2(
                .forward_C  (forward_B         ),
                .rs_rt_imm  (reg2_data_out     ),
                .write_data (write_data        ),
                .alu_result (alu_result_out    ),
                .mux_out    (forward_mux_out_2 )
            );

wire[31:0] jmp_dst_mem;

reg_ex_mem u_reg_ex_mem(
               .clk                 (clk                 ),
               .rst                 (rst                 ),
               .alu_result_in       (alu_result          ),
               .reg2_data_in        (reg2_data_out       ),
               .jmp_dst_in          (jmp_dst_out         ),
               .extended_imm_in     (extended_imm        ),
               .destination_reg_in  (destination_reg     ),
               .en_mem_write_in     (en_mem_write        ),
               .cu_reg_src_in       (cu_reg_src_out      ),
               .en_reg_write_in     (en_reg_write_out    ),
               .en_lw_ex_mem_in     (en_lw_id_ex_out     ),
               .stall_C             (stall_C             ),
               .alu_result_out      (alu_result_out      ),
               .reg2_data_out       (reg2_data_mem       ),
               .jmp_dst_out         (jmp_dst_mem         ),
               .extended_imm_out    (extended_imm_out    ),
               .destination_reg_out (destination_reg_out ),
               .en_mem_write_out    (en_mem_write_mem    ),
               .cu_reg_src_out      (cu_reg_src_mem      ),
               .en_reg_write_out    (en_reg_write_mem    ),
               .en_lw_ex_mem_out    (en_lw_ex_mem_out    )
           );

/* --- Stage 4: Memory --- */

data_memory u_data_memory(
                .clk            (clk                  ),
                .en_mem_write   (en_mem_write_mem     ),
                .mem_addr       (alu_result_out[11:2] ),
                .write_mem_data (reg2_data_mem        ),
                .read_mem_data  (read_mem_data        )
            );

wire[31:0]                  alu_result_wb;
wire[31:0]                  extended_imm_wb;
wire[`REG_SRC_LENGTH - 1:0] cu_reg_src_wb;

wire[31:0]                  jmp_dst_wb;
wire en_lw_mem_wb_out;

reg_mem_wb u_reg_mem_wb(
               .clk                 (clk                 ),
               .rst                 (rst                 ),
               .alu_result_in       (alu_result_out      ),
               .read_mem_data_in    (read_mem_data       ),
               .jmp_dst_in          (jmp_dst_mem         ),
               .extended_imm_in     (extended_imm_out    ),
               .destination_reg_in  (destination_reg_out ),
               .en_lw_mem_wb_in     (en_lw_ex_mem_out     ),
               .cu_reg_src_in       (cu_reg_src_mem      ),
               .en_reg_write_in     (en_reg_write_mem    ),
               .alu_result_out      (alu_result_wb       ),
               .read_mem_data_out   (read_mem_data_out   ),
               .jmp_dst_out         (jmp_dst_wb          ),
               .extended_imm_out    (extended_imm_wb     ),
               .destination_reg_out (destination_reg_wb  ),
               .cu_reg_src_out      (cu_reg_src_wb       ),
               .en_reg_write_out    (en_reg_write_wb     ),
               .en_lw_mem_wb_out    (en_lw_mem_wb_out    )
           );

/* --- Stage 5: Writeback --- */

reg_src_mux u_reg_src_mux(
                .cu_reg_src    (cu_reg_src_wb     ),
                .alu_result    (alu_result_wb     ),
                .read_mem_data (read_mem_data_out ),
                .extend_imm    (extended_imm_wb   ),
                .jmp_dst       (jmp_dst_wb        ),
                .mux_out       (write_data        )
            );
endmodule
