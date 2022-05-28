`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2022 01:44:08 PM
// Design Name: 
// Module Name: InputMem
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


module InputMem(
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

input   Send_start,
input  [11:0] Send_Length,
output  Valid,

output [31:0] M_AXIS_tdata , 
output        M_AXIS_tvalid, 
output [3:0]  M_AXIS_tkeep, 
output        M_AXIS_tlast, 
input         M_AXIS_tready

    );

reg [1:0] DevSend_start;
always @(posedge S_APB_aclk or negedge S_APB_aresetn)
    if (!S_APB_aresetn) DevSend_start <= 2'b00;
     else DevSend_start <= {DevSend_start[0],Send_start};

reg SendOn;         
reg [11:0] RaddCounter;
always @(posedge S_APB_aclk or negedge S_APB_aresetn)
    if (!S_APB_aresetn) SendOn <= 1'b0;
     else if (DevSend_start == 2'b01) SendOn <= 1'b1;
     else if (RaddCounter == Send_Length) SendOn <= 1'b0;

always @(posedge S_APB_aclk or negedge S_APB_aresetn)
    if (!S_APB_aresetn) RaddCounter <= 12'h000;
     else if (!SendOn) RaddCounter <= 12'h000;
     else RaddCounter <= RaddCounter + 1;


reg [31:0] Mem [0:1023];
reg [31:0] RegMem;

always @(posedge S_APB_aclk)
    if (S_APB_penable && S_APB_psel && S_APB_pwrite && (S_APB_paddr[31:12] == 20'h43c00))Mem[S_APB_paddr[11:2]] <=  S_APB_pwdata;
always @(posedge S_APB_aclk)
    RegMem <= Mem[RaddCounter];

reg Reg_ready;
always @(posedge S_APB_aclk or negedge S_APB_aresetn)
    if (!S_APB_aresetn) Reg_ready <= 1'b0;
     else Reg_ready <= S_APB_penable && S_APB_psel;

assign S_APB_prdata  = 32'h00000000;
assign S_APB_pready  = Reg_ready;
assign S_APB_pslverr = 1'b0;

reg Reg_Valid;
always @(posedge S_APB_aclk or negedge S_APB_aresetn)
    if (!S_APB_aresetn) Reg_Valid <= 1'b0;
     else if (M_AXIS_tlast) Reg_Valid <= 1'b0;
     else Reg_Valid <= SendOn;

reg [11:0] Sendadder;
always @(posedge S_APB_aclk or negedge S_APB_aresetn)
    if (!S_APB_aresetn) Sendadder <= 12'h000;
     else Sendadder <= RaddCounter;
     
assign M_AXIS_tdata  =  (Reg_Valid) ? RegMem : 32'h00000000;
assign M_AXIS_tvalid =  Reg_Valid;
assign M_AXIS_tlast  =  (Reg_Valid && (RaddCounter == Send_Length)) ? 1'b1 :1'b0;

assign  Valid = M_AXIS_tvalid;

endmodule
