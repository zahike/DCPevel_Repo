`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2022 04:19:59 PM
// Design Name: 
// Module Name: FFT4
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


(* keep_hierarchy = "yes" *)module FFT4(
input   clk,
input   rstn,
input   [31:0] Vin0 ,
input   [31:0] Vin1 ,
input   [31:0] Vin2 ,
input   [31:0] Vin3 ,

output [31:0] Vout0,
output [31:0] Vout1,
output [31:0] Vout2,
output [31:0] Vout3
    );
    
wire signed [15:0] VinR [0:3];    
wire signed [15:0] VinI [0:3];    

assign VinR[0] = Vin0[15: 0];    
assign VinR[1] = Vin2[15: 0];    
assign VinR[2] = Vin1[15: 0];    
assign VinR[3] = Vin3[15: 0];    
assign VinI[0] = Vin0[31:16];    
assign VinI[1] = Vin2[31:16];    
assign VinI[2] = Vin1[31:16];    
assign VinI[3] = Vin3[31:16];    

wire signed [15:0] coafiR[0:3];
wire signed [15:0] coafiI[0:3];

assign coafiR[0] = 16'h3FFF;
assign coafiR[1] = 16'h0000;
assign coafiR[2] = 16'hC001;
assign coafiR[3] = 16'h0000;
assign coafiI[0] = 16'h0000;
assign coafiI[1] = 16'hC001;
assign coafiI[2] = 16'h0000;
assign coafiI[3] = 16'h3FFF;

wire signed [15:0] FFT2outR[0:3];
wire signed [15:0] FFT2outI[0:3];
wire signed [31:0] MulloutR[0:3];
wire signed [31:0] MulloutI[0:3];
wire signed [15:0] Mull17R[0:3];
wire signed [15:0] Mull17I[0:3];
(* keep = "true" *) reg signed [16:0] SumR[0:3];
(* keep = "true" *) reg signed [16:0] SumI[0:3];


genvar i,j;
generate 
    for (i=0;i<2;i=i+1)begin
     FFT2 FFT2_inst
        (
            .clk(clk),
          
            .INar(VinR[2*i]),
            .INai(VinI[2*i]),
            .INbr(VinR[2*i+1]),
            .INbi(VinI[2*i+1]),
            
            .OUTsumr(FFT2outR[2*i]),  
            .OUTsumi(FFT2outI[2*i]),  
            .OUTsubr(FFT2outR[2*i+1]),
            .OUTsubi(FFT2outI[2*i+1])
        );
        for (j=0;j<2;j=j+1)begin
              FFT4multi FFT4multi(
              .clk(clk) ,
              .Select(2*i+j),
              
              .INar (FFT2outR[2+j]),
              .INai (FFT2outI[2+j]),
              .OUTar(Mull17R[2*i+j]),
              .OUTai(Mull17I[2*i+j])
                  );
        always@(posedge clk or negedge rstn)
            if (!rstn) SumR[2*i+j] <= 16'h0000;
             else SumR[2*i+j] <= Mull17R[2*i+j]+FFT2outR[j];
        always@(posedge clk or negedge rstn)
            if (!rstn) SumI[2*i+j] <= 16'h0000;
             else SumI[2*i+j] <= Mull17I[2*i+j]+FFT2outI[j];
        end 
    end 
endgenerate

assign Vout0 = {SumI[0][16:1],SumR[0][16:1]};
assign Vout1 = {SumI[1][16:1],SumR[1][16:1]};
assign Vout2 = {SumI[2][16:1],SumR[2][16:1]};
assign Vout3 = {SumI[3][16:1],SumR[3][16:1]};
    
endmodule
