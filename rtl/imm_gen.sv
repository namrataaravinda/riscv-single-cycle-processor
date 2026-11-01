`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2026 14:25:16
// Design Name: 
// Module Name: imm_gen
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


module imm_gen (input  logic [11:0] imm_input,   
input  logic [2:0]  fn3,           
input  logic [6:0]  opcode,        
input  logic [19:0] imm_input_uj,  
output logic [31:0] imm_output);

always_comb begin
case (opcode)
// I-type ALU
7'b0010011: 
begin
if (fn3 == 3'b001 || fn3 == 3'b101) begin
// shift instructions
imm_output = {27'b0, imm_input[4:0]};
end 
else begin
//I-type (non shift)
imm_output = {{20{imm_input[11]}}, imm_input};
end
end
// Load and jalr
7'b0000011, 7'b1100111: begin
imm_output = {{20{imm_input[11]}}, imm_input};
end
// S-type
 7'b0100011: begin
 imm_output = {{20{imm_input[11]}}, imm_input};
 end
// B-type 
7'b1100011: begin
imm_output = {{19{imm_input[11]}}, imm_input, 1'b0};
end
7'b0110111, 7'b0010111: begin
imm_output = {imm_input_uj, 12'b0};
end
// J-type
7'b1101111: begin
imm_output = {{11{imm_input_uj[19]}}, imm_input_uj, 1'b0};
end 
default: begin
imm_output = 32'd0;
end
endcase
end
endmodule
