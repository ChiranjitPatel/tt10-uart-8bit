//-----------------------------------------------------------------------------------------------------------------------------------------------------
// Company:			NUS
// Engineer:		Vivek Adi (email: vivek.adishesha@u.nus.edu)
//
// Creation Date:	(c) 2024 NUS
// Design Name:		
// Module Name:			- Behavioral
// Project Name:	MEMU Traction Control
// Target Devices:	Altera FPGA Cyclone II EP2C15AF484I8N / EP2C5T144C8N
// Tool Versions:	Quartus 13.1 sp1
// Description:		
// Dependencies:	numeric_std
// Revision:		Revision 0.01 - File Created
// Comments:
//-----------------------------------------------------------------------------------------------------------------------------------------------------			

`timescale 1ns/1ns

module uart_rx_tb;
	logic clock;
	logic reset;
	logic data_in;
	logic [7:0] data_out;
	logic data_vld;
	
uart_rx dut(
			.uart_clock (clock),
            .uart_reset (reset),
			.uart_d_in  (data_in),
            .uart_d_out (data_out),
            .uart_valid (data_vld)
		);

//-----------------------------------------------------------------------------------------------------------------------------------------------------

parameter cycle = 20;	// 20ns
logic [9:0] data_input_ascii = 10'b1;		// stop-data[8:1]-start, MSB-LSB
integer i = 0;	

always begin
	clock <= 1'b0;
	#(cycle/2);
	clock <= 1'b1;
	#(cycle/2);
end

task delay(int n); 
	begin
		#(n);
	end
endtask

task init(); 
	begin
		reset 	<= 1'b0;
		data_in <= 1'b1;
	end
endtask

initial begin
	init();
	delay(50000);
	
	reset	<= 1'b1;
	delay(100000);
	
	data_input_ascii <=	10'b10110010100;		// ASCII -> E
	for(i=0;i<10;i++) begin
		data_in <= data_input_ascii[i];
		delay(2170);
	end
	
	data_in <= 1'b1;
	delay(100000);
	
	data_input_ascii <=	10'b1011011000;		// ASCII -> L // Add an extra zero to the 10 bits , i don't know why lol :)
	for(i=0;i<10;i++) begin
		data_in <= data_input_ascii[i];
		delay(2170);
	end
	
	data_in <= 1'b1;
	delay(100000);
	
	data_input_ascii <=	10'b1011001010;		// ASCII -> E
	for(i=0;i<10;i++) begin
		data_in <= data_input_ascii[i];
		delay(2170);
	end
	
	data_in <= 1'b1;
	delay(100000);
	
	data_input_ascii <=	10'b1011001000;		// ASCII -> D
	for(i=0;i<10;i++) begin
		data_in <= data_input_ascii[i];
		delay(2170);
	end
	
end
	

endmodule