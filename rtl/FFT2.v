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
              
output signed [15:0] OUTsumr,
output signed [15:0] OUTsumi,
output signed [15:0] OUTsubr,
output signed [15:0] OUTsubi
    );
wire [16:0] Sumr = INar + INbr;
wire [16:0] Sumi = INai + INbi;
wire [16:0] Subr = INar - INbr;
wire [16:0] Subi = INai - INbi;
    
assign OUTsumr = Sumr[16:1];
assign OUTsumi = Sumi[16:1];
assign OUTsubr = Subr[16:1];
assign OUTsubi = Subi[16:1];

endmodule
