`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2022 01:45:42 PM
// Design Name: 
// Module Name: OutputMem
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


module OutputMem(
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

input [31:0]  S_AXIS_tdata , 
input         S_AXIS_tvalid, 
//input [3:0]   S_AXIS_tkeep, 
input         S_AXIS_tlast, 
output        S_AXIS_tready

    );

reg [11:0] S_AXIS_counter;
always @(posedge S_APB_aclk or negedge S_APB_aresetn)
    if (!S_APB_aresetn) S_AXIS_counter <= 12'h000;
     else if (!S_AXIS_tvalid) S_AXIS_counter <= 12'h000;
     else S_AXIS_counter <= S_AXIS_counter + 1;
//reg [7:0] DataIn [0:2];
//always @(posedge S_APB_aclk or negedge S_APB_aresetn)
//    if (!S_APB_aresetn) DataIn[0] <= 8'h00;
//     else if (S_AXIS_tvalid && (S_AXIS_counter[1:0] == 2'b00)) DataIn[0] <= S_AXIS_tdata; 
//always @(posedge S_APB_aclk or negedge S_APB_aresetn)
//    if (!S_APB_aresetn) DataIn[1] <= 8'h00;
//     else if (S_AXIS_tvalid && (S_AXIS_counter[1:0] == 2'b01)) DataIn[1] <= S_AXIS_tdata; 
//always @(posedge S_APB_aclk or negedge S_APB_aresetn)
//    if (!S_APB_aresetn) DataIn[2] <= 8'h00;
//     else if (S_AXIS_tvalid && (S_AXIS_counter[1:0] == 2'b10)) DataIn[2] <= S_AXIS_tdata; 
    
reg [31:0] Mem [0:1023];
reg [31:0] RegMem;

always @(posedge S_APB_aclk)
    if (S_AXIS_tvalid)Mem[S_AXIS_counter] <=  S_AXIS_tdata;
always @(posedge S_APB_aclk)
    RegMem <= Mem[S_APB_paddr[11:2]];

reg Reg_ready;
always @(posedge S_APB_aclk or negedge S_APB_aresetn)
    if (!S_APB_aresetn) Reg_ready <= 1'b0;
     else Reg_ready <= S_APB_penable && S_APB_psel;

assign S_APB_prdata  = RegMem;    
assign S_APB_pready  = Reg_ready;
assign S_APB_pslverr = 1'b0;

assign S_AXIS_tready = 1'b1;

endmodule
