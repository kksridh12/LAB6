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
		presetn=0; 
		#40; 
		presetn=1;
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
	assign apb_if.PRDATA = prdata;
        assign apb_if.PREADY = pready;

	initial begin
		load_matrices(32'h1, 32'h2);
		uvm_config_db#(virtual apb_if)::set( null, "", "apb_vif", apb_if);
		uvm_top.enable_print_topology = 1; // Use this to debug uvm build phase and make sure all verification components are built correctly.
		run_test("apb_test");
	end
	// --------------------------------------------------------------------------
        // Waveform dump for Verdi
        // --------------------------------------------------------------------------
        initial begin
           $fsdbDumpfile("novas.fsdb");
           $fsdbDumpvars(0, testbench);
           $fsdbDumpvars(0, "+mda");
        end

// --------------------------------------------------------
// RAM initialization
// --------------------------------------------------------
task automatic load_matrices(
    input logic [31:0] a_value,
    input logic [31:0] b_value
);
    for (int i = 0; i < (1<<`ADDR_WIDTH); i++) begin
        dut.matrix_A0.ram[i] = 32'b0;
        dut.matrix_A1.ram[i] = 32'b0;
        dut.matrix_B0.ram[i] = 32'b0;
        dut.matrix_B1.ram[i] = 32'b0;

            // Sentinel prevents a false pass in the zero test.
        dut.matrix_C0.ram[i] = 32'hDEADBEEF;
        dut.matrix_C1.ram[i] = 32'hDEADBEEF;
    end

    for (int i = 0; i < 8; i++) begin
        dut.matrix_A0.ram[i] = {a_value};
        dut.matrix_A1.ram[i] = {a_value};
        dut.matrix_B0.ram[i] = {b_value};
        dut.matrix_B1.ram[i] = {b_value};
    end
endtask


endmodule


