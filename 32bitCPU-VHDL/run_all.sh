#!/usr/bin/env bash
set -euo pipefail

# Compile and run all VHDL modules/testbenches for 32bitCPU-VHDL.

echo "Cleaning previous GHDL artifacts..."
rm -f work-obj*.cf

echo "Analyzing source and testbench files..."
ghdl -a --std=08 src/*.vhd testbench/*.vhd

echo "Running TB_Data_Memory..."
ghdl -e --std=08 TB_Data_Memory
ghdl -r --std=08 TB_Data_Memory --stop-time=250ns

echo "Running TB_ALU..."
ghdl -e --std=08 TB_ALU
ghdl -r --std=08 TB_ALU --stop-time=200ns

echo "Running TB_Register_File..."
ghdl -e --std=08 TB_Register_File
ghdl -r --std=08 TB_Register_File --stop-time=300ns

echo "Running TB_Instruction_Memory..."
ghdl -e --std=08 TB_Instruction_Memory
ghdl -r --std=08 TB_Instruction_Memory --stop-time=120ns

echo "Running TB_Control_Unit..."
ghdl -e --std=08 TB_Control_Unit
ghdl -r --std=08 TB_Control_Unit --stop-time=200ns

echo "Running TB_Datapath..."
ghdl -e --std=08 TB_Datapath
ghdl -r --std=08 TB_Datapath --stop-time=200ns

echo "All testbenches completed successfully."
