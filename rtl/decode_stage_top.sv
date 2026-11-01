`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2026 15:08:39
// Design Name: 
// Module Name: decode_stage_top
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

module decode_stage_top (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] instruction,
    input  logic [4:0]  wb_rd_sel,
    input  logic [31:0] wb_data,
    
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data,
    output logic [31:0] imm_out,
    output logic [4:0]  rd,
    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [2:0]  fn3,
    output logic        fn7_5,
    output logic [6:0]  imm11_5,
    
    output logic        reg_write,
    output logic        alu_src,
    output logic        mem_write,
    output logic        mem_read,
    output logic [2:0]  aluop,
    output logic [1:0]  mem_to_reg,
    output logic        branch
);

    logic [6:0]  opcode;
    logic [31:0] decoder_imm_wire;
    logic [19:0] imm_u_wire;
    logic [11:0] imm_12_mux;

    // 1. Decoder
    instruction_decode u_decoder (
        .instruction (instruction),
        .rs1         (rs1),
        .rs2         (rs2),
        .rd          (rd),
        .opcode      (opcode),
        .imm11_5     (imm11_5),
        .fn3         (fn3),
        .imm         (decoder_imm_wire),
        .imm_u       (imm_u_wire),
        .fn7_5       (fn7_5)
    );

    // 2. Register File
    register_file u_reg_file (
        .rs1_sel   (rs1),
        .rs2_sel   (rs2),
        .rd_sel    (wb_rd_sel),
        .wb_data   (wb_data),
        .reg_write (reg_write),
        .clk       (clk),
        .reset     (reset),
        .rs1_data  (rs1_data),
        .rs2_data  (rs2_data)
    );

    // 3. Control Unit
    control_unit u_control (
        .opcode     (opcode),
        .reg_write  (reg_write),
        .alu_src    (alu_src),
        .mem_write  (mem_write),
        .mem_read   (mem_read),
        .aluop      (aluop),
        .mem_to_reg (mem_to_reg),
        .branch     (branch)
    );
    assign imm_12_mux = (opcode == 7'b0100011) ? {instruction[31:25], instruction[11:7]} 
                                               : decoder_imm_wire[11:0];
                                               
    // 4. Imm Gen
    imm_gen u_imm_gen (
        .imm_input    (imm_12_mux),
        .fn3          (fn3),
        .opcode       (opcode),
        .imm_input_uj (imm_u_wire),
        .imm_output   (imm_out)
    );
endmodule