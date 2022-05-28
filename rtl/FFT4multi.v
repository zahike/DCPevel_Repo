`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2022 02:19:30 PM
// Design Name: 
// Module Name: FFT4multi
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


module FFT4multi(
input clk ,
input [1:0] Select,

input  signed [15:0] INar,
input  signed [15:0] INai,
output signed [15:0] OUTar,
output signed [15:0] OUTai
    );

wire signed [15:0] INar_n = 16'h0000 - INar;
wire signed [15:0] INai_n = 16'h0000 - INai;

assign OUTar = (Select == 2'b00) ? INar   :
               (Select == 2'b01) ? INai   :
               (Select == 2'b10) ? INar_n :
               (Select == 2'b11) ? INai_n : 16'h0000;
assign OUTai = (Select == 2'b00) ? INai   :
               (Select == 2'b01) ? INar_n :
               (Select == 2'b10) ? INai_n :
               (Select == 2'b11) ? INar   : 16'h0000;
    
endmodule
