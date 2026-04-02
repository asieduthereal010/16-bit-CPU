#!/usr/bin/env bash
set -euo pipefail

# Compile and run all testbenches while generating VCD waveforms.

mkdir -p waves
rm -f waves/*.vcd
rm -f work-obj*.cf

echo "Analyzing source and testbench files..."
ghdl -a --std=08 src/*.vhd testbench/*.vhd

declare -a TESTBENCHES=(
  TB_Data_Memory
  TB_ALU
  TB_Register_File
  TB_Instruction_Memory
  TB_Control_Unit
  TB_Datapath
)

for tb in "${TESTBENCHES[@]}"; do
  echo "Running ${tb} with VCD dump..."
  ghdl -e --std=08 "${tb}"
  ghdl -r --std=08 "${tb}" --stop-time=500ns --vcd="waves/${tb}.vcd"
done

echo
echo "VCD files generated in ./waves:"
ls -1 waves/*.vcd
echo
echo "Open a waveform with:"
echo "  gtkwave waves/TB_ALU.vcd"
