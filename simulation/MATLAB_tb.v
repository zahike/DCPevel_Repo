`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2022 03:01:10 PM
// Design Name: 
// Module Name: MATLAB_tb
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


module MATLAB_tb();
reg clk;
reg rstn;
initial begin 
clk  = 1'b0;
rstn = 1'b0;
#100;
rstn = 1'b1;
end

always #5 clk = ~clk;

reg [31:0]  IS_APB_paddr    ; //input  [31:0] S_APB_paddr   ,
reg         IS_APB_penable  ; //input         S_APB_penable ,
wire [31:0] IS_APB_prdata  = 32'h00000000; //output [31:0] S_APB_prdata  ,
wire [0:0]  IS_APB_pready  ; //output [0:0]  S_APB_pready  ,
reg [0:0]   IS_APB_psel     ; //input  [0:0]  S_APB_psel    ,
wire [0:0]  IS_APB_pslverr ; //output [0:0]  S_APB_pslverr ,
reg [31:0]  IS_APB_pwdata   ; //input  [31:0] S_APB_pwdata  ,
reg         IS_APB_pwrite   ; //input         S_APB_pwrite  ,

reg [31:0]  OS_APB_paddr    ; //input  [31:0] S_APB_paddr   ,
reg         OS_APB_penable  ; //input         S_APB_penable ,
wire [31:0] OS_APB_prdata; //output [31:0] S_APB_prdata  ,
wire [0:0]  OS_APB_pready  ; //output [0:0]  S_APB_pready  ,
reg [0:0]   OS_APB_psel     ; //input  [0:0]  S_APB_psel    ,
wire [0:0]  OS_APB_pslverr ; //output [0:0]  S_APB_pslverr ,
reg [31:0]  OS_APB_pwdata   ; //input  [31:0] S_APB_pwdata  ,
reg         OS_APB_pwrite   ; //input         S_APB_pwrite  ,

reg   Send_start       ; // input   Send_start       ,
reg  [11:0] Send_Length; // input  [11:0] Send_Length,

wire [31:0] M_AXIS_tdata ; // output [7:0] M_AXIS_tdata ,  
wire        M_AXIS_tvalid; // output       M_AXIS_tvalid,  
wire [3:0]  M_AXIS_tkeep ; // output       M_AXIS_tkeep ,  
wire        M_AXIS_tlast ; // output       M_AXIS_tlast ,  
wire        M_AXIS_tready; // input        M_AXIS_tready

wire [31:0] S_AXIS_tdata ; // output [7:0] M_AXIS_tdata ,  
wire        S_AXIS_tvalid; // output       M_AXIS_tvalid,  
wire [3:0]  S_AXIS_tkeep ; // output       M_AXIS_tkeep ,  
wire        S_AXIS_tlast ; // output       M_AXIS_tlast ,  
wire        S_AXIS_tready; // input        M_AXIS_tready

integer i;

reg [13:0] Add_i;
reg [5:0] Data_i;

wire [15:0] InData [0:15];

assign InData[0 ] = 16'h0000;
assign InData[1 ] = 16'h187D;
assign InData[2 ] = 16'h2D40;
assign InData[3 ] = 16'h3B1f;
assign InData[4 ] = 16'h3fff;
assign InData[5 ] = 16'h3B1f;
assign InData[6 ] = 16'h2D40;
assign InData[7 ] = 16'h187D;
assign InData[8 ] = 16'h0000;
assign InData[9 ] = 16'hE783;
assign InData[10] = 16'hD2C0;
assign InData[11] = 16'hC4E1;
assign InData[12] = 16'hC001;
assign InData[13] = 16'hC4E1;
assign InData[14] = 16'hD2C0;
assign InData[15] = 16'hE783;

//assign InData[0 ] = 16'h3fff;
//assign InData[1 ] = 16'h3fff;
//assign InData[2 ] = 16'h3fff;
//assign InData[3 ] = 16'h3fff;
//assign InData[4 ] = 16'h3fff;
//assign InData[5 ] = 16'h3fff;
//assign InData[6 ] = 16'h3fff;
//assign InData[7 ] = 16'h3fff;
//assign InData[8 ] = 16'h3fff;
//assign InData[9 ] = 16'h3fff;
//assign InData[10] = 16'h3fff;
//assign InData[11] = 16'h3fff;
//assign InData[12] = 16'h3fff;
//assign InData[13] = 16'h3fff;
//assign InData[14] = 16'h3fff;
//assign InData[15] = 16'h3fff;

initial begin
Send_start  = 0; // input   Send_start       ,
Send_Length = 0; // input  [11:0] Send_Length,
IS_APB_paddr   = 0; //input  [31:0] S_APB_paddr   ,
IS_APB_penable = 0; //input         S_APB_penable ,
IS_APB_psel    = 0; //input  [0:0]  S_APB_psel    ,
IS_APB_pwdata  = 0; //input  [31:0] S_APB_pwdata  ,
IS_APB_pwrite  = 0; //input         S_APB_pwrite  ,
@(posedge rstn);
#100;
@(posedge clk);
Send_Length = 16; // input  [11:0] Send_Length,
#100;
@(posedge clk);
for (i=0;i<16;i=i+1) begin
    Add_i = i;
    Data_i = i;
//    IWriteAPB({16'h43c0,Add_i,2'b00},{Data_i,2'b11,Data_i,2'b10,Data_i,2'b01,Data_i,2'b00});
    IWriteAPB({16'h43c0,Add_i,2'b00},{16'h0000,InData[i]});
end  
#100;
@(posedge clk);
Send_start = 1'b1;
#100;
@(posedge clk);
Send_start = 1'b0;


@(negedge M_AXIS_tvalid);
for (i=0;i<20;i=i+1) begin
    Add_i = i;
    Data_i = i;
    OReadAPB({16'h43c2,Add_i,2'b00});
end  

end


InputMem InputMem_inst(                 // module InputMem(
.S_APB_aclk   (clk),     // input         S_APB_aclk   ,
.S_APB_aresetn(rstn),    // input         S_APB_aresetn ,
                   // 
.S_APB_paddr   (IS_APB_paddr   ),    // input  [31:0] S_APB_paddr   ,
.S_APB_penable (IS_APB_penable ),    // input         S_APB_penable ,
.S_APB_prdata  (IS_APB_prdata  ),    // output [31:0] S_APB_prdata  ,
.S_APB_pready  (IS_APB_pready  ),    // output [0:0]  S_APB_pready  ,
.S_APB_psel    (IS_APB_psel    ),    // input  [0:0]  S_APB_psel    ,
.S_APB_pslverr (IS_APB_pslverr ),    // output [0:0]  S_APB_pslverr ,
.S_APB_pwdata  (IS_APB_pwdata  ),    // input  [31:0] S_APB_pwdata  ,
.S_APB_pwrite  (IS_APB_pwrite  ),    // input         S_APB_pwrite  ,
                          
.Send_start(Send_start),              // input   Send_start,
.Send_Length(Send_Length),            // input  [11:0] Send_Length,
                          // 
.M_AXIS_tdata (M_AXIS_tdata ),      // output [7:0] M_AXIS_tdata , 
.M_AXIS_tvalid(M_AXIS_tvalid),      // output       M_AXIS_tvalid, 
//.M_AXIS_tkeep (M_AXIS_tkeep ),       // output       M_AXIS_tkeep, 
.M_AXIS_tlast (M_AXIS_tlast ),       // output       M_AXIS_tlast, 
.M_AXIS_tready(M_AXIS_tready)       // input        M_AXIS_tready
    );

OutputMem OutputMem_inst(                 // module InputMem(
.S_APB_aclk   (clk),     // input         S_APB_aclk   ,
.S_APB_aresetn(rstn),    // input         S_APB_aresetn ,
                   // 
.S_APB_paddr   (OS_APB_paddr   ),    // input  [31:0] S_APB_paddr   ,
.S_APB_penable (OS_APB_penable ),    // input         S_APB_penable ,
.S_APB_prdata  (OS_APB_prdata  ),    // output [31:0] S_APB_prdata  ,
.S_APB_pready  (OS_APB_pready  ),    // output [0:0]  S_APB_pready  ,
.S_APB_psel    (OS_APB_psel    ),    // input  [0:0]  S_APB_psel    ,
.S_APB_pslverr (OS_APB_pslverr ),    // output [0:0]  S_APB_pslverr ,
.S_APB_pwdata  (OS_APB_pwdata  ),    // input  [31:0] S_APB_pwdata  ,
.S_APB_pwrite  (OS_APB_pwrite  ),    // input         S_APB_pwrite  ,
                          
.S_AXIS_tdata (S_AXIS_tdata ),      // output [7:0] M_AXIS_tdata , 
.S_AXIS_tvalid(S_AXIS_tvalid),      // output       M_AXIS_tvalid, 
//.S_AXIS_tkeep (S_AXIS_tkeep ),       // output       M_AXIS_tkeep, 
.S_AXIS_tlast (S_AXIS_tlast ),       // output       M_AXIS_tlast, 
.S_AXIS_tready(S_AXIS_tready)       // input        M_AXIS_tready
    );

DUT_wreap DUT_wreap_inst(
.clk   (clk ),
.rstn  (rstn),

.Select (2'b0),

.S_AXIS_tdata (M_AXIS_tdata ), 
.S_AXIS_tvalid(M_AXIS_tvalid), 
.S_AXIS_tlast (M_AXIS_tlast ), 
.S_AXIS_tready(M_AXIS_tready),
      
.M_AXIS_tdata (S_AXIS_tdata ), 
.M_AXIS_tvalid(S_AXIS_tvalid), 
.M_AXIS_tlast (S_AXIS_tlast ), 
.M_AXIS_tready(S_AXIS_tready)
    );




task IWriteAPB;
input [31:0] Adder;
input [31:0] Data;
begin
@(posedge clk); 
IS_APB_paddr   = Adder;
IS_APB_penable = 1'b1;
IS_APB_psel    = 1'b0;
IS_APB_pwdata  = Data;
IS_APB_pwrite  = 1'b1;
@(posedge clk); 
IS_APB_paddr   = Adder;
IS_APB_penable = 1'b1;
IS_APB_psel    = 1'b1;
IS_APB_pwdata  = Data;
IS_APB_pwrite  = 1'b1;
while (!IS_APB_pready) begin
        @(posedge clk); 
    end
@(posedge clk); 
IS_APB_paddr   = 0;
IS_APB_penable = 0;
IS_APB_psel    = 0;
IS_APB_pwdata  = 0;
IS_APB_pwrite  = 0;    
end
endtask

task OReadAPB;
input [31:0] Adder;
begin
@(posedge clk); 
OS_APB_paddr   = Adder;
OS_APB_penable = 1'b1;
OS_APB_psel    = 1'b0;
OS_APB_pwrite  = 1'b0;
@(posedge clk); 
OS_APB_paddr   = Adder;
OS_APB_penable = 1'b1;
OS_APB_psel    = 1'b1;
OS_APB_pwrite  = 1'b0;
while (!OS_APB_pready) begin
        @(posedge clk); 
    end
@(posedge clk); 
OS_APB_paddr   = 0;
OS_APB_penable = 0;
OS_APB_psel    = 0;
OS_APB_pwdata  = 0;
OS_APB_pwrite  = 0;    
end
endtask

endmodule
