/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_types.h"

u32 *CONFIG = XPAR_APB_M_0_BASEADDR ;
u32 *INMEM  = XPAR_APB_M2_0_BASEADDR;
u32  *OUTMEM = XPAR_APB_M3_0_BASEADDR;



int main()
{

//	int Indata[];
//	int Outdata[];

	int data0,data1,data2,data3;
	int OutData1;
	s16 RoutData;
	s16 IoutData;
	s16 RextData;
	s16 IextData;
    init_platform();


    xil_printf("Hello World\n\r");
#include "Indata.c"
#include "Outdata.c"

    CONFIG[3] = sizeof(Indata)/4;

    for (int i = 0; i<sizeof(Indata);i++){
     	INMEM[i] = Indata[i];
    }
    CONFIG[2] = 0;	// No Cange
//    CONFIG[2] = 1;	// switch every 4 bits
//    CONFIG[2] = 2;	// switch every 2 bits
//    CONFIG[2] = 3;	// switch every 1 bits
    CONFIG[0] = 1;

	xil_printf("input\tReal\tExpect\tGot\tImage\tExpect\tGot\n\r\n\r");
   for (int i=0;i<sizeof(Outdata)/4;i++){
    	OutData1 = OUTMEM[i];
    	RoutData = OutData1;
    	IoutData = OutData1 >> 16;
    	RextData = Outdata[i];
    	IextData = Outdata[i] >> 16;
//    	if (OutData1 == Outdata[i]){
        if (abs(RoutData-RextData) <10 & abs(IoutData-IextData) < 10){
    		xil_printf("%d\tReal:\t%d == %d\t\tImage: %d == %d \t\t OK\n\r",Indata[i],RextData,RoutData,IextData,IoutData);
    	} else {
    		xil_printf("%d\tReal:\t%d <> %d\t\tImage: %d <> %d \t\t ===> worng\n\r",Indata[i],RextData,RoutData,IextData,IoutData);
    	}
    }

    xil_printf("GoodBye World\n\r");

    cleanup_platform();
    return 0;
}
