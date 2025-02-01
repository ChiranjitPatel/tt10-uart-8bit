`timescale 1ns/1ps
module tb_tt_um_uart_8bit;

    // Parameters
    localparam CLK_PERIOD = 10; // 100 MHz clock

    // Testbench signals
    logic clk;
    logic rst_n;
    logic [7:0] ui_in;
    logic [7:0] uo_out;
    logic [7:0] uio_in;
    logic [7:0] uio_out;
    logic [7:0] uio_oe;

    // Instantiate the UART module
    tt_um_uart_8bit  #(
        .BAUD_RATE(24'd4000000),
        .CLOCK_FREQ(28'd100000000)
    ) uut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(1'b1),
        .clk(clk),
        .rst_n(rst_n)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    // Reset generation
    initial begin
        rst_n = 0;
        #100; // Assert reset for 100 ns
        rst_n = 1;
    end

    // Test data
    logic [9:0] test_data;
    integer i; // Declare the loop variable outside the for loop

    initial begin
        // Initialize signals
        ui_in = 8'b00000100;
        uio_in = 8'b0;
        test_data = 10'b1101001010; // Example test data

        // @(negedge rst_n);
        // @(posedge clk);
        
        // Transmit test data
        $display("Starting UART transmission...");
        // ui_in[1] = 0; // Assert uart_tx_start
        ui_in[0] = test_data[0]; // Set LSB for transmission

        for (i = 0; i < 10; i++) begin
            // @(posedge clk);
            ui_in[0] = test_data[i]; // Load next bit for transmission
			#250;
        end
		#1000;
		ui_in[1] = 1;
		#3000;
        ui_in[1] = 0; // De-assert uart_tx_start

        // Wait for tx_ready signal
        @(posedge clk);
        while (!uo_out[2]) @(posedge clk);
        $display("UART transmission complete, tx_ready asserted.");

        // Check UART reception
        @(posedge clk);
        if (uo_out[1]) begin
            $display("UART reception successful.");
        end else begin
            $error("UART reception failed.");
        end

        // $finish;
    end

endmodule
