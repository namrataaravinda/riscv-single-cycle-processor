`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2026 09:29:05
// Design Name: 
// Module Name: control_unit
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

module control_unit (
    input  logic [6:0] opcode,
    output logic       reg_write,
    output logic       alu_src,
    output logic       mem_write,
    output logic       mem_read,
    output logic [2:0] aluop,
    output logic [1:0] mem_to_reg,
    output logic       branch
);

    always_comb begin
        reg_write  = 1'b0;
        alu_src    = 1'b0;
        mem_write  = 1'b0;
        mem_read   = 1'b0;
        aluop      = 3'b000; 
        mem_to_reg = 2'b00; 
        branch     = 1'b0;

        case (opcode)
            7'b0110011: begin // r-type
                reg_write  = 1'b1;
                mem_to_reg = 2'b00;
                aluop      = 3'b000;
            end
            7'b0010011: begin // I-type ALU
                reg_write  = 1'b1;
                alu_src    = 1'b1;
                mem_to_reg = 2'b00;
                aluop      = 3'b001;
            end
            7'b0000011: begin // I-type (load)
                reg_write  = 1'b1;
                alu_src    = 1'b1;
                mem_read   = 1'b1;
                mem_to_reg = 2'b01;
                aluop      = 3'b010;
            end
            7'b0100011: begin // S-type Store (sw)
                alu_src    = 1'b1;
                mem_write  = 1'b1;
                mem_to_reg = 2'b11;
                aluop      = 3'b011;
            end
            7'b1100011: begin // B-type (branch)
                branch     = 1'b1;
                mem_to_reg = 2'b00;
                aluop      = 3'b100;
            end
            7'b0110111, 7'b0010111: begin // U-type (lui, auipc)
                reg_write  = 1'b1;
                alu_src    = 1'b1;
                mem_to_reg = 2'b10;
                aluop      = 3'b110;
            end
            7'b1101111: begin // J-type (jal)
                reg_write  = 1'b1;
                alu_src    = 1'b1;
                mem_to_reg = 2'b10;
                aluop      = 3'b110;
            end
            7'b1100111: begin // J-type (jalr)
                reg_write  = 1'b1;
                alu_src    = 1'b1;
                mem_to_reg = 2'b10;
                aluop      = 3'b001;
            end
            default: ;
        endcase
    end
endmodule