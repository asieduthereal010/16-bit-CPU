#!/usr/bin/env bash
set -euo pipefail

# Open all generated VCD waveforms in separate GTKWave windows.

VCD_FILES=(
  "waves/TB_Data_Memory.vcd"
  "waves/TB_ALU.vcd"
  "waves/TB_Register_File.vcd"
  "waves/TB_Instruction_Memory.vcd"
  "waves/TB_Control_Unit.vcd"
  "waves/TB_Datapath.vcd"
)

for vcd in "${VCD_FILES[@]}"; do
  if [[ ! -f "${vcd}" ]]; then
    echo "Missing waveform: ${vcd}"
    echo "Run ./run_with_vcd.sh first."
    exit 1
  fi
done

for vcd in "${VCD_FILES[@]}"; do
  gtkwave "${vcd}" >/dev/null 2>&1 &
done

echo "Opened all waveform files in GTKWave."
