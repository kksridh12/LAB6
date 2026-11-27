/*--------------------------------------------------------------
 *  File Name 	: testbench.sv
 *  Title 		: APB testbench 	
 *  Author		: sefaveske@gmail.com	
 *  Date		: 08/19/2018
 * 
 *               ##     ####   #    #
 *              #  #   #       #    #
 *             #    #   ####   #    #
 *             ######       #  #    #
 *             #    #  #    #   #  #
 *             #    #   ####     ##
 * ------------------------------------------------------------*/
 `timescale 1ns/1ns
 
import uvm_pkg::*;
`include "uvm_macros.svh"

 import apb_master_pkg::*;
 `include "apb_test.svh"

module testbench;


	logic pclk;
	logic presetn;
	
  
	logic [`ADDR_WIDTH-1:0] paddr;
	logic        psel;
	logic        penable;
	logic        pwrite;
	logic [`DATA_WIDTH-1:0] prdata;
	logic [`DATA_WIDTH-1:0] pwdata;

         matrix_multiplication_8x8_apb dut (
           .PCLK    (pclk),
           .PRESETn (presetn),
           .PADDR   (PADDR),
           .PWRITE  (PWRITE),
           .PSEL    (PSEL),
           .PENABLE (PENABLE),
           .PWDATA  (PWDATA),
           .PRDATA  (PRDATA),
           .PREADY  (PREADY)
        );

	initial begin
		pclk=0;
	end
	
	initial begin
		presetn=1; 
		#40; 
		presetn=0;
	end	

	//Generate a clock
	always begin
		#10 pclk = ~pclk;
	end	
	
	// apb interface
	apb_if  apb_if(pclk,presetn);
  
	assign PADDR   = apb_if.PADDR;
	assign PWRITE  = apb_if.PWRITE;
	assign PENABLE = apb_if.PENABLE;
	assign PWDATA  = apb_if.PWDATA;
	assign PSEL    = apb_if.PSEL;
	assign apb_if.PRDATA = PRDATA;
        assign apb_if.PREADY = PREADY;	

	initial begin
		uvm_config_db#(virtual apb_if)::set( null, "", "apb_vif", apb_if);
		uvm_top.enable_print_topology = 1; // Use this to debug uvm build phase and make sure all verification components are built correctly.
		run_test("apb_test");
	end
	
endmodule


