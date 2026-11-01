`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2026 15:20:00
// Design Name: 
// Module Name: alu_control
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
module alu_control (
    input  logic [2:0] aluop,
    input  logic [2:0] fn3,
    input  logic [6:0] imm11_5,
    input  logic       fn7_5,
    output logic [4:0] alu_ctrl_out
);

    always_comb begin
        alu_ctrl_out = 5'b00000; 

        case (aluop)
            3'b000: begin // R-Type
                case (fn3)
                    3'b000: alu_ctrl_out = fn7_5 ? 5'b00001 : 5'b00000; //sub and add
                    3'b001: alu_ctrl_out = 5'b00101; // SLL
                    3'b010: alu_ctrl_out = 5'b01000; // SLT
                    3'b011: alu_ctrl_out = 5'b01001; // SLTU
                    3'b100: alu_ctrl_out = 5'b00010; // XOR
                    3'b101: alu_ctrl_out = fn7_5 ? 5'b00111 : 5'b00110; // SRA and SRL
                    3'b110: alu_ctrl_out = 5'b00011; // OR
                    3'b111: alu_ctrl_out = 5'b00100; // AND
                    default: alu_ctrl_out = 5'b00000;
                endcase
            end

            3'b001: begin // I-Type ALU
                case (fn3)
                    3'b000: alu_ctrl_out = 5'b00000; // ADDI
                    3'b001: alu_ctrl_out = 5'b00101; // SLLI
                    3'b010: alu_ctrl_out = 5'b01000; // SLTI 
                    3'b011: alu_ctrl_out = 5'b01001; // SLTIU 
                    3'b100: alu_ctrl_out = 5'b00010; // XORI 
                    3'b110: alu_ctrl_out = 5'b00011; // ORI
                    3'b111: alu_ctrl_out = 5'b00100; // ANDI 
                    3'b101: alu_ctrl_out = (imm11_5 == 7'b0100000) ? 5'b00111 : 5'b00110; // SRAI and SRLI
                    default: alu_ctrl_out = 5'b00000;
                endcase
            end

            3'b010, 3'b011: begin // Load / Store 
                alu_ctrl_out = 5'b00000; 
            end

            3'b100: begin // Branch 
                case (fn3)
                    3'b000: alu_ctrl_out = 5'b01010; // BEQ
                    3'b001: alu_ctrl_out = 5'b01011; // BNE
                    3'b100: alu_ctrl_out = 5'b01100; // BLT
                    3'b101: alu_ctrl_out = 5'b01101; // BGE
                    3'b110: alu_ctrl_out = 5'b01110; // BLTU
                    3'b111: alu_ctrl_out = 5'b01111; // BGEU
                    default: alu_ctrl_out = 5'b00001;
                endcase
            end

            3'b110: begin // JAL / LUI / AUIPC 
                alu_ctrl_out = 5'b00000;
            end

            default: alu_ctrl_out = 5'b00000;
        endcase
    end

endmodule