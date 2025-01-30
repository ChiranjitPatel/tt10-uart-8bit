module uart_tx_tb;

	parameter integer BAUD_RATE = 9600;
	parameter integer CLOCK_FREQ = 10000000;
	
	parameter real CLK_PERIOD = 20.0; // 20 ns for 50 MHz

	logic uart_clock;
	logic uart_reset;
	logic uart_start;
	logic [7:0] uart_d_in;
	logic uart_d_out;
	logic uart_tx_ready;

	// UART tx module
	uart_tx #(
		.baud_rate(BAUD_RATE),
		.clock_freq(CLOCK_FREQ)
	) uut (
		.uart_clock(uart_clock),
		.uart_reset(uart_reset),
		.uart_start(uart_start),
		.uart_d_in(uart_d_in),
		.uart_d_out(uart_d_out),
		.uart_tx_ready(uart_tx_ready)
	);

	initial begin
		uart_clock = 0;
		forever #(CLK_PERIOD/2) uart_clock = ~uart_clock;
	end

	initial begin
		uart_reset = 0;
		uart_start = 0;
		uart_d_in = 8'h00;
		
		// Reset release
		#(4 * CLK_PERIOD);
		
		uart_reset = 1;
		#50;
		
		// Test 1: Send byte 0xA5
		uart_d_in = 8'hA5;
		uart_start = 1;
		#40;
		uart_start = 0;
		// #40;
		wait(uart_tx_ready);

		// Test 2: Send another byte 0x5A after ready
		uart_d_in = 8'h5A;
		uart_start = 1;
		#40;
		uart_start = 0;

		#(100 * CLK_PERIOD); // Allow time to observe full transmission
		
	end

endmodule
