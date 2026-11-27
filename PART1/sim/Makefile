VCS ?= $(VCS_HOME)/bin/vcs
VERDI ?= $(VERDI_HOME)/bin/verdi
SEED ?= 1
UVM_VERBOSITY ?= UVM_MEDIUM

# Sources are listed relative to PART2/sim; top.sv comes first because it
# declares typedefs used by the other RTL modules.
SV_SRCS := \
	../../matmul_with_ram_8x8_apb.sv \
	../../matmul_8x8.sv \
	../../matmul.v \
	../../ram.sv \
	../../apb_slave.sv \
	common/apb_common_pkg.sv \
	common/apb_if.sv \
	master/apb_master_pkg.sv \
	apb_test.svh \
	apb_env.svh \
        testbench.sv

.PHONY: all compile_and_sim compile compile_verdi sim verdi waves gui clean

all: compile_and_sim

# Compile and run the UVM testbench
compile_and_sim:
	$(VCS) -R -full64 -sverilog -timescale=1ns/1ps -ntb_opts uvm \
		-top matrix_multiplication_8x8_apb +incdir+. +incdir+common +incdir+master $(SV_SRCS) \
		-debug_access+all -kdb -lca +UVM_VERBOSITY=$(UVM_VERBOSITY) \
		+ntb_random_seed=$(SEED) -l sim_$(SEED).log 2>&1 | tee compile_and_sim.log

# Compile without running
compile:
	$(VCS) -full64 -sverilog -timescale=1ns/1ps -ntb_opts uvm \
		-top matrix_multiplication_8x8_apb +incdir+. +incdir+common +incdir+master $(SV_SRCS) \
		-debug_access+all -lca -l comp.log 2>&1 | tee compile.log

# Compile with the database needed by Verdi
compile_verdi:
	$(VCS) -full64 -sverilog -timescale=1ns/1ps -ntb_opts uvm \
		-top matrix_multiplication_8x8_apb +incdir+. +incdir+common +incdir+master $(SV_SRCS) \
		-debug_access+all -kdb -lca -l compile_verdi.log

# Run the compiled simulation
sim:
	./simv +UVM_VERBOSITY=$(UVM_VERBOSITY) +ntb_random_seed=$(SEED) -l sim_$(SEED).log

# Launch Verdi, optionally loading the generated waveform database
verdi:
	$(VERDI) -dbdir ./simv.daidir -nologo

waves:
	$(VERDI) -dbdir ./simv.daidir -ssf novas.fsdb -nologo

gui:
	./simv +UVM_VERBOSITY=$(UVM_VERBOSITY) +ntb_random_seed=$(SEED) -gui=verdi

clean:
	rm -rf *.log *.h csrc simv simv.daidir *.vdb *.fsdb ucli.key DVEFiles \
		verdiLog novas.* memfile.dat dmemfile.dat


