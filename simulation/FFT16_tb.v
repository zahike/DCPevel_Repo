`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2022 06:30:58 PM
// Design Name: 
// Module Name: FFT16_tb
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


module FFT16_tb();
reg clk;
reg rstn;
initial begin 
clk = 1'b0;
rstn = 1'b0;
#100;
rstn = 1'b1;
end
always #5 clk = ~clk;

wire [19:0] FFToutR[0:15]; 
wire [19:0] FFToutI[0:15]; 

FFT16 FFT16_inst(
.clk(clk),
.rstn(rstn)  ,

.Vin0  (32'h00000000),
.Vin1  (32'h0000187D),
.Vin2  (32'h00002D40),
.Vin3  (32'h00003B1F),
.Vin4  (32'h00003FFF),
.Vin5  (32'h00003B1F),
.Vin6  (32'h00002D40),
.Vin7  (32'h0000187D),
.Vin8  (32'h00000000),
.Vin9  (32'h0000E783),
.Vin10 (32'h0000D2C0),
.Vin11 (32'h0000C4E1),
.Vin12 (32'h0000C001),
.Vin13 (32'h0000C4E1),
.Vin14 (32'h0000D2C0),
.Vin15 (32'h0000E783),

.Vout0  ({FFToutI[0 ],FFToutR[0 ]}), 
.Vout1  ({FFToutI[1 ],FFToutR[1 ]}), 
.Vout2  ({FFToutI[2 ],FFToutR[2 ]}), 
.Vout3  ({FFToutI[3 ],FFToutR[3 ]}), 
.Vout4  ({FFToutI[4 ],FFToutR[4 ]}), 
.Vout5  ({FFToutI[5 ],FFToutR[5 ]}), 
.Vout6  ({FFToutI[6 ],FFToutR[6 ]}), 
.Vout7  ({FFToutI[7 ],FFToutR[7 ]}), 
.Vout8  ({FFToutI[8 ],FFToutR[8 ]}), 
.Vout9  ({FFToutI[9 ],FFToutR[9 ]}), 
.Vout10 ({FFToutI[10],FFToutR[10]}),
.Vout11 ({FFToutI[11],FFToutR[11]}),
.Vout12 ({FFToutI[12],FFToutR[12]}),
.Vout13 ({FFToutI[13],FFToutR[13]}),
.Vout14 ({FFToutI[14],FFToutR[14]}),
.Vout15 ({FFToutI[15],FFToutR[15]})
    );

endmodule
