`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/20/2022 11:27:49 AM
// Design Name: 
// Module Name: DUT_wreap
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


module DUT_wreap(
input         clk   ,
input         rstn  ,

input [1:0] Select,
output Busy,

input [31:0]  S_AXIS_tdata , 
input         S_AXIS_tvalid, 
input [3:0]   S_AXIS_tkeep, 
input         S_AXIS_tlast, 
output        S_AXIS_tready,

output [31:0] M_AXIS_tdata , 
output        M_AXIS_tvalid, 
output [3:0]  M_AXIS_tkeep, 
output        M_AXIS_tlast, 
input         M_AXIS_tready
    );

reg RegBusy;
always @(posedge clk or negedge rstn)
    if (!rstn) RegBusy <= 1'b0;
     else if (S_AXIS_tvalid) RegBusy <= 1'b1;
     else if (M_AXIS_tlast) RegBusy <= 1'b0;
assign Busy = RegBusy;
     
assign M_AXIS_tkeep  = 4'hf;
assign S_AXIS_tready = 1'b1;

reg [3:0] INmemAdd;
always @(posedge clk or negedge rstn) 
    if (!rstn) INmemAdd <= 4'h0;
     else if (!S_AXIS_tvalid) INmemAdd <= 4'h0;
     else INmemAdd <= INmemAdd + 1;
genvar i;
reg [31:0] INmem [0:15];
generate 
    for (i=0;i<16;i=i+1) begin
        always @(posedge clk or negedge rstn)
            if (!rstn) INmem[i] <= 32'h00000000;
             else if (S_AXIS_tvalid && (INmemAdd == i)) INmem[i] <= S_AXIS_tdata;
    end
endgenerate

wire [39:0] FFTout [0:15];
FFT16 FFT16_inst(
.clk(clk),
//.rstn(rstn)  ,

.Vin0  (INmem[0 ]),
.Vin1  (INmem[1 ]),
.Vin2  (INmem[2 ]),
.Vin3  (INmem[3 ]),
.Vin4  (INmem[4 ]),
.Vin5  (INmem[5 ]),
.Vin6  (INmem[6 ]),
.Vin7  (INmem[7 ]),
.Vin8  (INmem[8 ]),
.Vin9  (INmem[9 ]),
.Vin10 (INmem[10]),
.Vin11 (INmem[11]),
.Vin12 (INmem[12]),
.Vin13 (INmem[13]),
.Vin14 (INmem[14]),
.Vin15 (INmem[15]),

.Vout0  (FFTout[0 ]), 
.Vout1  (FFTout[1 ]), 
.Vout2  (FFTout[2 ]), 
.Vout3  (FFTout[3 ]), 
.Vout4  (FFTout[4 ]), 
.Vout5  (FFTout[5 ]), 
.Vout6  (FFTout[6 ]), 
.Vout7  (FFTout[7 ]), 
.Vout8  (FFTout[8 ]), 
.Vout9  (FFTout[9 ]), 
.Vout10 (FFTout[10]),
.Vout11 (FFTout[11]),
.Vout12 (FFTout[12]),
.Vout13 (FFTout[13]),
.Vout14 (FFTout[14]),
.Vout15 (FFTout[15])
    );
reg [4:0] StartFFT;
always @(posedge clk or negedge rstn)
    if (!rstn) StartFFT <= 5'h16;
     else if (S_AXIS_tlast) StartFFT <= 5'h00;
     else if (StartFFT == 5'h16) StartFFT <= 5'h16;
     else StartFFT <= StartFFT + 1;
reg [3:0] OutOn;
reg [3:0] OutAdd;
always @(posedge clk or negedge rstn)
    if (!rstn) OutOn <= 1'b0;
     else if (StartFFT == 5'h15) OutOn <= 1'b1;
     else if (OutAdd == 4'hf) OutOn <= 1'b0;  

always @(posedge clk or negedge rstn)
    if (!rstn) OutAdd <= 4'h0;
     else if (!OutOn) OutAdd <= 4'h0;
     else OutAdd <= OutAdd + 1;

reg [31:0] FFTdataOut;
always @(posedge clk or negedge rstn)
    if (!rstn) FFTdataOut <= 32'h00000000;
     else if (!OutOn) FFTdataOut <= 32'h00000000;
     else FFTdataOut <= {FFTout[OutAdd][39:24],FFTout[OutAdd][19:4]};


wire [31 : 0] m_axis_data_tdata;
wire m_axis_data_tvalid        ;
wire m_axis_data_tready = 1'b1 ;
wire m_axis_data_tlast         ;
/*
//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
xfft_0 xfft_inst (
  .aclk(clk),                                                // input wire aclk
  .s_axis_config_tdata(8'h00),                  // input wire [7 : 0] s_axis_config_tdata
  .s_axis_config_tvalid(1'b0),                // input wire s_axis_config_tvalid
  .s_axis_config_tready(),                // output wire s_axis_config_tready
  .s_axis_data_tdata(S_AXIS_tdata),                      // input wire [31 : 0] s_axis_data_tdata
  .s_axis_data_tvalid(S_AXIS_tvalid),                    // input wire s_axis_data_tvalid
  .s_axis_data_tready(),                    // output wire s_axis_data_tready
  .s_axis_data_tlast(S_AXIS_tlast),                      // input wire s_axis_data_tlast
  .m_axis_data_tdata(m_axis_data_tdata),                      // output wire [31 : 0] m_axis_data_tdata
  .m_axis_data_tvalid(m_axis_data_tvalid),                    // output wire m_axis_data_tvalid
  .m_axis_data_tready(m_axis_data_tready),                    // input wire m_axis_data_tready
  .m_axis_data_tlast(m_axis_data_tlast),                      // output wire m_axis_data_tlast
  .event_frame_started(event_frame_started),                  // output wire event_frame_started
  .event_tlast_unexpected(event_tlast_unexpected),            // output wire event_tlast_unexpected
  .event_tlast_missing(event_tlast_missing),                  // output wire event_tlast_missing
  .event_status_channel_halt(event_status_channel_halt),      // output wire event_status_channel_halt
  .event_data_in_channel_halt(event_data_in_channel_halt),    // output wire event_data_in_channel_halt
  .event_data_out_channel_halt(event_data_out_channel_halt)  // output wire event_data_out_channel_halt
);
*/
reg RegValid;
always @(posedge clk or negedge rstn)
    if (!rstn) RegValid <= 1'b0;
     else RegValid <= OutOn;
reg RegLast;
always @(posedge clk or negedge rstn)
    if (!rstn) RegLast <= 1'b0;
     else RegLast <= (OutAdd == 4'hf) ? 1'b1 : 1'b0;
     
assign M_AXIS_tdata  = FFTdataOut;
assign M_AXIS_tvalid = RegValid  ;
assign M_AXIS_tlast  = RegLast   ;
             
endmodule
