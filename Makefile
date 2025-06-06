# Flag to indicate wether we are in debug mode or not
DEBUG ?= 1
# Default max simulation time
SIMTIME ?= 100ns

# VHDL compiler
GHDL = ghdl
STD ?= 08
WORK ?= work
# Wave simulator
ifeq ($(shell uname -s), Linux)
	WAVE = gtkwave
else
	# macOS support for gtkwave
	WAVE = open -a gtkwave
endif

# Source code directory
SRC = src
# Test bench directory
TEST = test
# Simulation file directory
SIM = sim
# Directory containing all build files
BUILD = build

# Set error exit code according to the DEBUG flag
# Set maximum tolerance assertion level (errors will be triggered for this error type & above)
ifeq ($(DEBUG), 1)
	ERROREXIT = 0
	ASSERTLVL = error
else
	ERROREXIT = 1
	ASSERTLVL = warning
endif

# Source VHDL files
SOURCES = $(wildcard $(SRC)/*.vhd)
TARGETS = $(patsubst $(SRC)/%.vhd, %, $(SOURCES))

# Simulation files
SIMULATIONS = $(wildcard $(SIM)/*.vcd)


all: simdir builddir $(TARGETS)


# Dependencies
TrafficLightsController: TrafficLight


# IP with test bench
%: $(SRC)/%.vhd $(TEST)/%Testbench.vhd
	@echo "🔧 Compiling \`$@.vhd\` & \`$@Testbench.vhd\`"
	$(GHDL) -s --workdir=$(BUILD) --std=$(STD) --work=$(WORK) $(SRC)/$@.vhd $(TEST)/$@Testbench.vhd
	$(GHDL) -a --workdir=$(BUILD) --std=$(STD) --work=$(WORK) $(SRC)/$@.vhd $(TEST)/$@Testbench.vhd
	$(GHDL) -e --workdir=$(BUILD) --std=$(STD) --work=$(WORK) -o $(BUILD)/$@Testbench $@Testbench

	@echo "▶️ Running simulation of \`$@Testbench\`"
# Some versions of GHDL produce executables (in $(BUILD)/) and some do not, hence the first two parts of this command
	@./$(BUILD)/$@Testbench --vcd=$(SIM)/$@.vcd --assert-level=$(ASSERTLVL) --stop-time=$(SIMTIME) 2> /dev/null || \
	$(GHDL) -r --workdir=$(BUILD) --std=$(STD) --work=$(WORK) $@Testbench --vcd=$(SIM)/$@.vcd --assert-level=$(ASSERTLVL) --stop-time=$(SIMTIME) && \
		echo "✅ \`$@\` PASSED" || (echo "❌ \`$@\` FAILED"; exit $(ERROREXIT))


# IP without test bench
%: $(SRC)/%.vhd
	@echo "🔧 Compiling \`$@.vhd\`"
	$(GHDL) -s --workdir=$(BUILD) --std=$(STD) --work=$(WORK) $(SRC)/$@.vhd
	$(GHDL) -a --workdir=$(BUILD) --std=$(STD) --work=$(WORK) $(SRC)/$@.vhd


builddir:
	@mkdir -p $(BUILD)/

simdir:
	@mkdir -p $(SIM)/

sim:
	$(WAVE) $(SIMULATIONS)

targets:
	@echo $(TARGETS)

clean:
	rm -rf $(BUILD)/ $(SIM)/


.PHONY: all builddir simdir sim clean targets
