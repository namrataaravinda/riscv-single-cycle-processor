`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2026 14:30:48
// Design Name: 
// Module Name: alu
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
module alu (
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [4:0]  alu_ctrl,
    output logic [31:0] result,
    output logic        zero
);

    
    logic signed [31:0] a_signed = a;
    logic signed [31:0] b_signed = b;

    always_comb begin
        case (alu_ctrl)
            5'b00000: result = a + b; 
            5'b00001: result = a - b; 
            5'b00010: result = a ^ b; 
            5'b00011: result = a | b; 
            5'b00100: result = a & b; 
            5'b00101: result = a << b[4:0]; 
            5'b00110: result = a >> b[4:0]; 
            5'b00111: result = a_signed >>> b[4:0]; 
            5'b01000: result = (a_signed < b_signed) ? 32'd1 : 32'd0; 
            5'b01001: result = (a < b) ? 32'd1 : 32'd0;               
            
            5'b01010: result = (a == b) ? 32'd0 : 32'd1; 
            5'b01011: result = (a != b) ? 32'd0 : 32'd1; 
            5'b01100: result = (a_signed < b_signed) ? 32'd0 : 32'd1; 
            5'b01101: result = (a_signed >= b_signed) ? 32'd0 : 32'd1; 
            5'b01110: result = (a < b) ? 32'd0 : 32'd1; 
            5'b01111: result = (a >= b) ? 32'd0 : 32'd1; 
            
            default:  result = 32'd0;
        endcase
    end

    assign zero = (result == 32'd0);

endmodule