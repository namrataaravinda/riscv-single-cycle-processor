`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2026 15:18:36
// Design Name: 
// Module Name: single_cycle_riscv
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module single_cycle_riscv (
    input  logic        clk,
    input  logic        reset,
    input  logic        stall,
    input  logic [31:0] instruction,   
    input  logic [31:0] mem_out,       
    output logic [31:0] rs2_data,     
    output logic [31:0] alu_out,       
    output logic        mem_write,
    output logic        mem_read,
    output logic [2:0]  fn3,           
    output logic [6:0]  opcode,        
    output logic [31:0] address        
);

   //internal wires
    logic [31:0] pc_signed_offset;
    logic        branch_taken;
    logic [31:0] rs1_data;
    logic [31:0] imm_out;
    logic [4:0]  rd;
    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic        fn7_5;
    logic [6:0]  imm11_5;
    logic        reg_write;
    logic        alu_src;
    logic [2:0]  aluop;
    logic [1:0]  mem_to_reg;
    logic        mux_inp;       
    logic [31:0] pc_ex_out;
    logic [31:0] wb_data;
    logic [31:0] return_addr;     // PC + 4 from instruction fetch

    // 1. Instruction Fetch Stage
    instruction_fetch u_if_stage (
        .clk              (clk),
        .reset            (reset),
        .stall            (stall),
        .and_out          (branch_taken),
        .pc_signed_offset (pc_ex_out),
        .address          (address)
    );

    // Calculate PC + 4 for return address 
    assign return_addr = address + 32'h4;

    // 2. Instruction Decode Stage
    decode_stage_top u_id_stage (
        .clk        (clk),
        .reset      (reset),
        .instruction(instruction),
        .wb_rd_sel  (rd),
        .wb_data    (wb_data),
        .rs1_data   (rs1_data),
        .rs2_data   (rs2_data),
        .imm_out    (imm_out),
        .rd         (rd),
        .rs1        (rs1),
        .rs2        (rs2),
        .fn3        (fn3),
        .fn7_5      (fn7_5),
        .imm11_5    (imm11_5),
        .reg_write  (reg_write),
        .alu_src    (alu_src),
        .mem_write  (mem_write),
        .mem_read   (mem_read),
        .aluop      (aluop),
        .mem_to_reg (mem_to_reg),
        .branch     (branch_taken)
    );

  
    assign mux_inp = (opcode == 7'b1100111); // JALR opcode check

    // 3. Execution Stage
    ex_stage u_ex_stage (
        .rs1_data     (rs1_data),
        .rs2_data     (rs2_data),
        .imm_out      (imm_out),
        .address      (address),
        .branch       (branch_taken),
        .alu_src      (alu_src),
        .fn7_5        (fn7_5),
        .mux_inp      (mux_inp),
        .fn3          (fn3),
        .imm11_5      (imm11_5),
        .aluop        (aluop),
        .opcode       (opcode),
        .and_out_ex   (branch_taken),
        .alu_out      (alu_out),
        .pc_ex_out    (pc_ex_out)
    );

    // 4. Write-Back Stage
    wb_stage u_wb_stage (
        .mem_out          (mem_out),
        .alu_out          (alu_out),
        .return_addr      (return_addr),
        .imm_out          (imm_out),
        .pc_signed_offset (pc_ex_out),
        .memtoreg         (mem_to_reg),
        .opcode_out_d     (opcode),
        .wb_data          (wb_data)
    );

endmodule