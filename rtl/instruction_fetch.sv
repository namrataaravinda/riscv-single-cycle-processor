`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2026 21:42:25
// Design Name: 
// Module Name: instruction_fetch
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

module instruction_fetch (
    input  logic        clk,
    input  logic        reset,
    input  logic        stall,
    input  logic        and_out,
    input  logic [31:0] pc_signed_offset,

    output logic [31:0] address
);

    logic [31:0] pc_next;
    logic [31:0] pc_new;
assign pc_new=address+32'h4;    
    
always_comb begin
if(and_out)
pc_next=pc_signed_offset;
else
pc_next=pc_new;
end

mux d1(pc_signed_offset, pc_new,and_out,address);

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        address <= 32'h8000_0000;
    else if (!stall)
        address <= pc_next;
end
endmodule