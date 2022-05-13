`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2022 05:24:51 PM
// Design Name: 
// Module Name: MATLAB_DUT
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


module MATLAB_DUT(
input         S_APB_aclk   ,
input         S_APB_aresetn ,

input [7:0]   S_AXIS_tdata , 
input         S_AXIS_tvalid, 
input         S_AXIS_tkeep, 
input         S_AXIS_tlast, 
output        S_AXIS_tready,

input [1:0] MATLABconf,

output [7:0] M_AXIS_tdata , 
output       M_AXIS_tvalid, 
output       M_AXIS_tkeep, 
output       M_AXIS_tlast, 
input        M_AXIS_tready
    );

assign M_AXIS_tdata  = (MATLABconf == 2'b00) ? S_AXIS_tdata           :
                       (MATLABconf == 2'b01) ? {S_AXIS_tdata[3:0],S_AXIS_tdata[7:4]} :
                       (MATLABconf == 2'b10) ? {S_AXIS_tdata[1:0],S_AXIS_tdata[3:2],S_AXIS_tdata[5:4],S_AXIS_tdata[7:6]} :
                       (MATLABconf == 2'b11) ? {S_AXIS_tdata[0],S_AXIS_tdata[1],S_AXIS_tdata[2],S_AXIS_tdata[3],S_AXIS_tdata[4],S_AXIS_tdata[5],S_AXIS_tdata[6],S_AXIS_tdata[7]} :
                       8'h00;
assign M_AXIS_tvalid = S_AXIS_tvalid;
assign M_AXIS_tkeep  = S_AXIS_tkeep ;
assign M_AXIS_tlast  = S_AXIS_tlast ;
assign S_AXIS_tready = M_AXIS_tready;
    
endmodule
