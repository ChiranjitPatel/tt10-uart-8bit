`timescale 1ns / 1ps
`default_nettype none

module tb_tt_um_uart_8bit;

    // Testbench parameters
    parameter BAUD_RATE = 1500000;
    parameter CLOCK_FREQ = 10000000;
	parameter real CLK_PERIOD = 20.0; // 20 ns for 50 MHz
    
    // Testbench signals
    logic clk;
    logic rst_n;
    logic [7:0] ui_in;
    logic [7:0] uo_out;
    logic [7:0] uio_in;
    logic [7:0] uio_out;
    logic [7:0] uio_oe;


    // DUT instantiation
    tt_um_uart_8bit #(
        .BAUD_RATE(BAUD_RATE),
        .CLOCK_FREQ(CLOCK_FREQ)
    ) dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(1'b1), // Always enabled
        .clk(clk),
        .rst_n(rst_n)
    );

    // Generate clock signal
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk; // Generate clock
    end
	
	// UART loopback
    assign uio_in[0] = uio_in[2]; // Loop back tx_d_out to rx_d_in

    // Monitor received data
    always @(posedge clk) begin
        if (uio_out[0]) begin
            $display("Received data: %h (%s)", uo_out, uo_out);
        end
    end
	
    // initial begin
        // // Initialize inputs
        // rst_n = 0;
        // ui_in = 8'b0;
        // uio_in = 8'b0;

        // // Apply reset
        // #20 rst_n = 1;

 		// uio_in[1] = 1'b1;
        // ui_in = 8'h02; 
		// wait(uio_out[1] == 0);
		// uio_in[1] = 1'b0;
        // #10000; 
        
        // #50000; 
		// uio_in[1] = 1'b1;
        // ui_in = 8'h0A; 
		// wait(uio_out[1] == 0);
		// uio_in[1] = 1'b0;
        // #10000; 
			
        // #100;

    // end

// endmodule

 // Simulation process
    initial begin
        uart_reset = 0;
		uart_tx_start = 1'b0;
        uart_transmit_data = 8'h00; // Initialize transmit data

        // Reset release
        #(4 * CLK_PERIOD);
        uart_reset = 1;

        // Start sending data in a loop
        repeat (10) begin
            // Simulate sending data
            #50000; // Wait a bit before starting transmission
			uio_in[1] = 1'b1;
			ui_in = 8'h02; 
			wait(uio_out[1] == 0);
			uio_in[1] = 1'b0;
            #10000; // Wait for a bit
            
            #50000; // Wait a bit before starting transmission
           	uio_in[1] = 1'b1;
			ui_in = 8'h0A; 
			wait(uio_out[1] == 0);
			uio_in[1] = 1'b0;
            #10000; // Wait for a bit
        end
        
        // Allow enough time to observe multiple transmissions
        #(100 * CLK_PERIOD);
		
    end

endmodule