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
	logic        pready;

         matrix_multiplication_8x8_apb dut (
           .PCLK    (pclk),
           .PRESETn (presetn),
           .PADDR   (paddr),
           .PWRITE  (pwrite),
           .PSEL    (psel),
           .PENABLE (penable),
           .PWDATA  (pwdata),
           .PRDATA  (prdata),
           .PREADY  (pready)
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
  
	assign paddr   = apb_if.PADDR;
	assign pwrite  = apb_if.PWRITE;
	assign penable = apb_if.PENABLE;
	assign pwdata  = apb_if.PWDATA;
	assign psel    = apb_if.PSEL;

	initial begin
		uvm_config_db#(virtual apb_if)::set( null, "", "apb_vif", apb_if);
		uvm_top.enable_print_topology = 1; // Use this to debug uvm build phase and make sure all verification components are built correctly.
		run_test("apb_test");
	end
	
endmodule



