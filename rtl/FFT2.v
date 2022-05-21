`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2022 04:13:35 PM
// Design Name: 
// Module Name: FFT2
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


module FFT2(
input clk,
      
input signed [15:0] INar,
input signed [15:0] INai,
input signed [15:0] INbr,
input signed [15:0] INbi,
              
output signed [16:0] OUTsumr,
output signed [16:0] OUTsumi,
output signed [16:0] OUTsubr,
output signed [16:0] OUTsubi
    );
assign OUTsumr = INar + INbr;
assign OUTsumi = INai + INbi;
assign OUTsubr = INar - INbr;
assign OUTsubi = INai - INbi;
endmodule
