`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.10.2026 14:35:20
// Design Name: 
// Module Name: register_file
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


module register_file(
input logic [4:0] rs1_sel,
input logic [4:0] rs2_sel,
input logic [4:0] rd_sel,
input logic [31:0] wb_data,
input logic reg_write,
input logic clk,
input logic reset,
output logic [31:0] rs1_data,
output logic [31:0] rs2_data
 );
 logic [31:0] rf [31:0];
 
 //read logic
 //always_comb begin
 //rs1_data=rf[rs1_sel]
 //rs2_data=rf[rs2_sel]
 //end
always_comb begin
rs1_data=(rs1_sel==5'b0) ? 32'b0:rf[rs1_sel];
rs2_data=(rs2_sel==5'b0) ? 32'b0:rf[rs2_sel];
end
//write logic
always_ff @(posedge clk or posedge reset)  begin
if(reset) begin
rf<='{default:0};
end else begin
if((rd_sel !=0) & reg_write)
rf[rd_sel]<=wb_data;
end
end
endmodule