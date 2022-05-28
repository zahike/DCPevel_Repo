`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2022 08:53:40 PM
// Design Name: 
// Module Name: FFT8
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


(* keep_hierarchy = "yes" *)module FFT8(
input   clk,
input   rstn,
input   [31:0] Vin0 ,
input   [31:0] Vin1 ,
input   [31:0] Vin2 ,
input   [31:0] Vin3 ,
input   [31:0] Vin4 ,
input   [31:0] Vin5 ,
input   [31:0] Vin6 ,
input   [31:0] Vin7 ,

output [31:0] Vout0,
output [31:0] Vout1,
output [31:0] Vout2,
output [31:0] Vout3,
output [31:0] Vout4,
output [31:0] Vout5,
output [31:0] Vout6,
output [31:0] Vout7
    );

wire signed [31:0] Vin [0:7];    

assign Vin[0] = Vin0;    
assign Vin[1] = Vin2;    
assign Vin[2] = Vin4;    
assign Vin[3] = Vin6;    
assign Vin[4] = Vin1;    
assign Vin[5] = Vin3;    
assign Vin[6] = Vin5;    
assign Vin[7] = Vin7;    

wire signed [15:0] coafiR[0:7];
wire signed [15:0] coafiI[0:7];

assign coafiR[0] = 16'h3FFF;
assign coafiR[1] = 16'h2D40;
assign coafiR[2] = 16'h0000;
assign coafiR[3] = 16'hD2C0;
assign coafiR[4] = 16'hC001;
assign coafiR[5] = 16'hD2C0;
assign coafiR[6] = 16'h0000;
assign coafiR[7] = 16'h2D40;

assign coafiI[0] = 16'h0000;
assign coafiI[1] = 16'hD2C0;
assign coafiI[2] = 16'hC001;
assign coafiI[3] = 16'hD2C0;
assign coafiI[4] = 16'h0000;
assign coafiI[5] = 16'h2D40;
assign coafiI[6] = 16'h3FFF;
assign coafiI[7] = 16'h2D40;

wire signed [15:0] FFT2outR[0:7];
wire signed [15:0] FFT2outI[0:7];
wire signed [31:0] MulloutR[0:7];
wire signed [31:0] MulloutI[0:7];
wire signed [15:0] TempR[0:7];
wire signed [15:0] TempI[0:7];
// wire signed [16:0] SumR[0:7];
// wire signed [16:0] SumI[0:7];
reg signed [16:0] SumR[0:7];
reg signed [16:0] SumI[0:7];

genvar i,j;
generate 
    for (i=0;i<2;i=i+1)begin
(* keep_hierarchy = "yes" *)     FFT4 FFT4_inst
        (
            .clk(clk),
            .rstn(rstn),
            
            .Vin0 (Vin[4*i+0]),
            .Vin1 (Vin[4*i+1]),
            .Vin2 (Vin[4*i+2]),
            .Vin3 (Vin[4*i+3]),
            
            .Vout0({FFT2outI[4*i+0],FFT2outR[4*i+0]}),
            .Vout1({FFT2outI[4*i+1],FFT2outR[4*i+1]}),
            .Vout2({FFT2outI[4*i+2],FFT2outR[4*i+2]}),
            .Vout3({FFT2outI[4*i+3],FFT2outR[4*i+3]})
        );
        for (j=0;j<4;j=j+1)begin
        
            ComplexMull 
            #(
                .AWIDTH(16),  // size of 1st input of multiplier
                .BWIDTH(16)  // size of 2nd input of multiplier
            )ComplexMull_inst(
                .clk(clk),               // Clock
                .rstn(1'b1),
                .ar(coafiR[4*i+j]),  // 1st inputs real and imaginary parts
                .ai(coafiI[4*i+j]),  // 1st inputs real and imaginary parts
                .br(FFT2outR[4+j]),  // 2nd inputs real and imaginary parts
                .bi(FFT2outI[4+j]),  // 2nd inputs real and imaginary parts
                .pr(MulloutR[4*i+j]),  // output signal
                .pi(MulloutI[4*i+j])   // output signal    
            );    
            assign TempR[4*i+j] = MulloutR[4*i+j][29:14];
            assign TempI[4*i+j] = MulloutI[4*i+j][29:14];
            // assign SumR[4*i+j] = TempR[4*i+j]+FFT2outR[j];
            // assign SumI[4*i+j] = TempI[4*i+j]+FFT2outI[j];
       always@(posedge clk or negedge rstn)
           if (!rstn) SumR[4*i+j] <= 16'h0000;
            else SumR[4*i+j] <= TempR[4*i+j]+FFT2outR[j];
       always@(posedge clk or negedge rstn)
           if (!rstn) SumI[4*i+j] <= 16'h0000;
            else SumI[4*i+j] <= TempI[4*i+j]+FFT2outI[j];
        end 
    end 
endgenerate

assign Vout0 = {SumI[0][16:1],SumR[0][16:1]};
assign Vout1 = {SumI[1][16:1],SumR[1][16:1]};
assign Vout2 = {SumI[2][16:1],SumR[2][16:1]};
assign Vout3 = {SumI[3][16:1],SumR[3][16:1]};
assign Vout4 = {SumI[4][16:1],SumR[4][16:1]};
assign Vout5 = {SumI[5][16:1],SumR[5][16:1]};
assign Vout6 = {SumI[6][16:1],SumR[6][16:1]};
assign Vout7 = {SumI[7][16:1],SumR[7][16:1]};
      
endmodule
