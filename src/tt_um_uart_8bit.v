/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */
`timescale 1ns / 1ps

// `default_nettype none

 module tt_um_uart_8bit #(  
		parameter [23:0] BAUD_RATE = 24'd4000000,
		parameter [27:0] CLOCK_FREQ = 28'd100000000
	)
	(
		input  wire [7:0] ui_in,    // Dedicated inputs
		output wire [7:0] uo_out,   // Dedicated outputs
		input  wire [7:0] uio_in,   // IOs: Input path
		output wire [7:0] uio_out,  // IOs: Output path
		output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
		input  wire       ena,      // always 1 when the design is powered, so you can ignore it
		input  wire       clk,      // clock
		input  wire       rst_n     // reset_n - low to reset
	);

  uart_rx_tx #(
        .BAUD_RATE(BAUD_RATE),
        .CLOCK_FREQ(CLOCK_FREQ)
    ) 
	uart_module (	
		.clk_int(clk),
		.uart_reset(rst_n),
		.uart_rx_d_in(ui_in[0]),
		.uart_tx_start(ui_in[1]),
		.loopback(ui_in[2]),
		.uart_tx_d_out(uo_out[0]),
		.uart_rx_valid(uo_out[1]),
		.uart_tx_ready(uo_out[2])
	);
	
  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out[7:3] = 0;
  assign uio_out[7:0] = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, uio_in[7:0], 1'b0};

endmodule
