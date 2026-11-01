`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.10.2026 13:35:10
// Design Name: 
// Module Name: instruction_decode
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
module instruction_decode(
input logic [31:0] instruction,
output logic [4:0] rs1,
output logic [4:0] rs2,
output logic [4:0] rd,
output logic [6:0] opcode,
output logic [6:0] imm11_5,
output logic [2:0] fn3,
output logic [31:0] imm,    
output logic [19:0] imm_u,
output logic fn7_5);
//making signals as zero by default 
always_comb begin
    rd = 5'd0;
    fn3 = 3'd0;
    rs1 = 5'd0;
    rs2 = 5'd0;
    imm = 32'd0;
    imm_u = 20'd0;
    imm11_5 = 7'd0;
    fn7_5  = 1'b0;
    opcode = instruction[6:0];
    
    // r type
    if (opcode == 7'b0110011) begin
        rd = instruction[11:7];
        fn3 = instruction[14:12];
        rs1 = instruction[19:15];
        rs2 = instruction[24:20];
        fn7_5 = instruction[30];
        
    end
    //I type
    else if(opcode==7'b0010011) begin
        rd = instruction[11:7];
        fn3 = instruction[14:12];
        rs1 = instruction[19:15];
        imm = {{20{instruction[31]}}, instruction[31:20]}; // sign-extended
        
    end
    //s type
    else if(opcode==7'b0100011) begin
        fn3     = instruction[14:12];
        rs1     = instruction[19:15];
        rs2     = instruction[24:20];
        imm11_5 = instruction[31:25];
        imm     = {{20{instruction[31]}}, {instruction[31:25], instruction[11:7]}};
    end
    //b type
    else if(opcode==7'b1100011) begin
        fn3     = instruction[14:12];
        rs1     = instruction[19:15];
        rs2     = instruction[24:20];
        imm11_5 = instruction[31:25];
        imm     = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; 
    end
    //u type
    else if (opcode == 7'b0110111 || opcode == 7'b0010111) begin
        rd    = instruction[11:7];  
        imm_u = instruction[31:12]; 
    end
    //j type
    else if (opcode == 7'b1101111) begin
        rd  = instruction[11:7];                                                                
        imm = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};     
    end
end

endmodule