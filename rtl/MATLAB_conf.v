`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2022 04:59:55 PM
// Design Name: 
// Module Name: MATLAB_conf
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


module MATLAB_conf(
input         S_APB_aclk   ,
input         S_APB_aresetn ,

input  [31:0] S_APB_paddr   ,
input         S_APB_penable ,
output [31:0] S_APB_prdata  ,
output [0:0]  S_APB_pready  ,
input  [0:0]  S_APB_psel    ,
output [0:0]  S_APB_pslverr ,
input  [31:0] S_APB_pwdata  ,
input         S_APB_pwrite  ,

output Start,
output [1:0] MATLABconf,
output [11:0] MATLABLength,
input Valid
    );
    
reg Reg_Start;
always @(posedge S_APB_aclk or negedge S_APB_aresetn)
    if (!S_APB_aresetn) Reg_Start <= 1'b0;
     else if (Reg_Start) Reg_Start <= 1'b0;
     else if (S_APB_penable && S_APB_psel && S_APB_pwrite && (S_APB_paddr[11:0] == 12'h000)) Reg_Start <= S_APB_pwdata[0];
assign Start = Reg_Start;

reg [1:0] DevValid;
always @(posedge S_APB_aclk or negedge S_APB_aresetn)
    if (!S_APB_aresetn) DevValid <= 2'b00;
     else DevValid <= {DevValid[0],Valid};

reg Reg_Busy;
always @(posedge S_APB_aclk or negedge S_APB_aresetn)
    if (!S_APB_aresetn) Reg_Busy <= 1'b0;
     else if (Reg_Start) Reg_Busy <= 1'b1;
     else if (DevValid == 2'b10) Reg_Busy <= 1'b0; 

reg [1:0] Reg_Conf;
always @(posedge S_APB_aclk or negedge S_APB_aresetn)
    if (!S_APB_aresetn) Reg_Conf <= 2'b00;
     else if (S_APB_penable && S_APB_psel && S_APB_pwrite && (S_APB_paddr[11:0] == 12'h008)) Reg_Conf <= S_APB_pwdata[1:0];
assign MATLABconf = Reg_Conf;

reg [11:0] Reg_Length;
always @(posedge S_APB_aclk or negedge S_APB_aresetn)
    if (!S_APB_aresetn) Reg_Length <= 12'h000;
     else if (S_APB_penable && S_APB_psel && S_APB_pwrite && (S_APB_paddr[11:0] == 12'h00c)) Reg_Length <= S_APB_pwdata[11:0];
assign MATLABLength = Reg_Length;

reg Reg_ready;
always @(posedge S_APB_aclk or negedge S_APB_aresetn)
    if (!S_APB_aresetn) Reg_ready <= 1'b0;
     else Reg_ready <= S_APB_penable && S_APB_psel;

assign S_APB_prdata  = (S_APB_paddr[11:0] == 12'h000) ?  {31'h00000000,Reg_Start} :
                       (S_APB_paddr[11:0] == 12'h004) ?  {31'h00000000,Reg_Busy } :  
                       (S_APB_paddr[11:0] == 12'h008) ?  {30'h00000000,Reg_Conf } : 
                       (S_APB_paddr[11:0] == 12'h00c) ?  { 20'h00000,Reg_Length } : 32'h00000000;   
assign S_APB_pready  = Reg_ready;
assign S_APB_pslverr = 1'b0;

endmodule
