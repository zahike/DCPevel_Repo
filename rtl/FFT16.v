`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2022 07:40:11 PM
// Design Name: 
// Module Name: FFT16
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


(* keep_hierarchy = "yes" *)module FFT16(
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
input   [31:0] Vin8 ,
input   [31:0] Vin9 ,
input   [31:0] Vin10 ,
input   [31:0] Vin11 ,
input   [31:0] Vin12 ,
input   [31:0] Vin13 ,
input   [31:0] Vin14 ,
input   [31:0] Vin15 ,

output [31:0] Vout0 , 
output [31:0] Vout1 , 
output [31:0] Vout2 , 
output [31:0] Vout3 , 
output [31:0] Vout4 , 
output [31:0] Vout5 , 
output [31:0] Vout6 , 
output [31:0] Vout7 , 
output [31:0] Vout8 , 
output [31:0] Vout9 , 
output [31:0] Vout10 ,
output [31:0] Vout11 ,
output [31:0] Vout12 ,
output [31:0] Vout13 ,
output [31:0] Vout14 ,
output [31:0] Vout15 
    );
wire signed [31:0] Vin [0:15];    
    
    assign Vin[0 ] = Vin0;    
    assign Vin[1 ] = Vin2;    
    assign Vin[2 ] = Vin4;    
    assign Vin[3 ] = Vin6;    
    assign Vin[4 ] = Vin8;    
    assign Vin[5 ] = Vin10;    
    assign Vin[6 ] = Vin12;    
    assign Vin[7 ] = Vin14;    
    assign Vin[8 ] = Vin1;    
    assign Vin[9 ] = Vin3;    
    assign Vin[10] = Vin5;    
    assign Vin[11] = Vin7;    
    assign Vin[12] = Vin9;    
    assign Vin[13] = Vin11;    
    assign Vin[14] = Vin13;    
    assign Vin[15] = Vin15;    

wire signed [15:0] coafiR[0:15];
wire signed [15:0] coafiI[0:15];

assign coafiR[0]  = 16'h3FFF;
assign coafiR[1]  = 16'h3B1F;
assign coafiR[2]  = 16'h2D40;
assign coafiR[3]  = 16'h187D;
assign coafiR[4]  = 16'h0000;
assign coafiR[5]  = 16'hE783;
assign coafiR[6]  = 16'hD2C0;
assign coafiR[7]  = 16'hC4E1;
assign coafiR[8]  = 16'hC001;
assign coafiR[9]  = 16'hC4E1;
assign coafiR[10] = 16'hD2C0;
assign coafiR[11] = 16'hE783;
assign coafiR[12] = 16'h0000;
assign coafiR[13] = 16'h187D;
assign coafiR[14] = 16'h2D40;
assign coafiR[15] = 16'h3B1F;

assign coafiI[0]  = 16'h0000;
assign coafiI[1]  = 16'hE783;
assign coafiI[2]  = 16'hD2C0;
assign coafiI[3]  = 16'hC4E1;
assign coafiI[4]  = 16'hC001;
assign coafiI[5]  = 16'hC4E1;
assign coafiI[6]  = 16'hD2C0;
assign coafiI[7]  = 16'hE783;
assign coafiI[8]  = 16'h0000;
assign coafiI[9]  = 16'h187D;
assign coafiI[10] = 16'h2D40;
assign coafiI[11] = 16'h3B1F;
assign coafiI[12] = 16'h3FFF;
assign coafiI[13] = 16'h3B1F;
assign coafiI[14] = 16'h2D40;
assign coafiI[15] = 16'h187D;

wire signed [15:0] FFT2outR[0:15];
wire signed [15:0] FFT2outI[0:15];
wire signed [31:0] MulloutR[0:15];
wire signed [31:0] MulloutI[0:15];
wire signed [15:0] TempR[0:15];
wire signed [15:0] TempI[0:15];
reg signed [16:0] SumR[0:15];
reg signed [16:0] SumI[0:15];

genvar i,j;

generate 
    for (i=0;i<2;i=i+1)begin
(* keep_hierarchy = "yes" *)     FFT8 FFT8_inst
        (
            .clk(clk),
            .rstn(rstn),
            .Vin0 (Vin[8*i+0]),
            .Vin1 (Vin[8*i+1]),
            .Vin2 (Vin[8*i+2]),
            .Vin3 (Vin[8*i+3]),
            .Vin4 (Vin[8*i+4]),
            .Vin5 (Vin[8*i+5]),
            .Vin6 (Vin[8*i+6]),
            .Vin7 (Vin[8*i+7]),
            
            .Vout0({FFT2outI[8*i+0],FFT2outR[8*i+0]}),
            .Vout1({FFT2outI[8*i+1],FFT2outR[8*i+1]}),
            .Vout2({FFT2outI[8*i+2],FFT2outR[8*i+2]}),
            .Vout3({FFT2outI[8*i+3],FFT2outR[8*i+3]}),
            .Vout4({FFT2outI[8*i+4],FFT2outR[8*i+4]}),
            .Vout5({FFT2outI[8*i+5],FFT2outR[8*i+5]}),
            .Vout6({FFT2outI[8*i+6],FFT2outR[8*i+6]}),
            .Vout7({FFT2outI[8*i+7],FFT2outR[8*i+7]})
        );
        for (j=0;j<8;j=j+1)begin        
            ComplexMull 
            #(
                .AWIDTH(16),  // size of 1st input of multiplier
                .BWIDTH(16)  // size of 2nd input of multiplier
            )ComplexMull_inst(
                .clk(clk),               // Clock
                .rstn(1'b1),
                .ar(coafiR[8*i+j]),  // 1st inputs real and imaginary parts
                .ai(coafiI[8*i+j]),  // 1st inputs real and imaginary parts
                .br(FFT2outR[8+j]),  // 2nd inputs real and imaginary parts
                .bi(FFT2outI[8+j]),  // 2nd inputs real and imaginary parts
                .pr(MulloutR[8*i+j]),  // output signal
                .pi(MulloutI[8*i+j])   // output signal    
            );    
            assign TempR[8*i+j] = MulloutR[8*i+j][29:14];
            assign TempI[8*i+j] = MulloutI[8*i+j][29:14];
            // assign SumR [8*i+j] = TempR[8*i+j]+FFT2outR[j];
            // assign SumI [8*i+j] = TempI[8*i+j]+FFT2outI[j];
       always@(posedge clk or negedge rstn)
           if (!rstn) SumR[8*i+j] <= 16'h0000;
            else SumR[8*i+j] <= TempR[8*i+j]+FFT2outR[j];
       always@(posedge clk or negedge rstn)
           if (!rstn) SumI[8*i+j] <= 16'h0000;
            else SumI[8*i+j] <= TempI[8*i+j]+FFT2outI[j];
        end 
    end 
endgenerate

assign Vout0  = {SumI[0 ][16:1],SumR[0 ][16:1]};
assign Vout1  = {SumI[1 ][16:1],SumR[1 ][16:1]};
assign Vout2  = {SumI[2 ][16:1],SumR[2 ][16:1]};
assign Vout3  = {SumI[3 ][16:1],SumR[3 ][16:1]};
assign Vout4  = {SumI[4 ][16:1],SumR[4 ][16:1]};
assign Vout5  = {SumI[5 ][16:1],SumR[5 ][16:1]};
assign Vout6  = {SumI[6 ][16:1],SumR[6 ][16:1]};
assign Vout7  = {SumI[7 ][16:1],SumR[7 ][16:1]};
assign Vout8  = {SumI[8 ][16:1],SumR[8 ][16:1]};
assign Vout9  = {SumI[9 ][16:1],SumR[9 ][16:1]};
assign Vout10 = {SumI[10][16:1],SumR[10][16:1]};
assign Vout11 = {SumI[11][16:1],SumR[11][16:1]};
assign Vout12 = {SumI[12][16:1],SumR[12][16:1]};
assign Vout13 = {SumI[13][16:1],SumR[13][16:1]};
assign Vout14 = {SumI[14][16:1],SumR[14][16:1]};
assign Vout15 = {SumI[15][16:1],SumR[15][16:1]};
    
endmodule
