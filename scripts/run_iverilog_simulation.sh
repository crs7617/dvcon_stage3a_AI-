#!/bin/bash
# Alternative simulation using Icarus Verilog (open source)

echo "=== Running AI Simulation with Icarus Verilog ==="

# Set paths  
WORK_DIR="/home/sairam/dvcon-stage3a/simulation_work"
PROJECT_ROOT="/home/sairam/dvcon-stage3a"

cd "$WORK_DIR"

# Check if iverilog is installed
if ! command -v iverilog &> /dev/null; then
    echo "Icarus Verilog not found. Installing..."
    echo "Please run: sudo apt install iverilog gtkwave"
    exit 1
fi

echo "Compiling Verilog files..."
iverilog -o ai_simulation \
    ../models/vision_ai_core.v \
    ../models/audio_ai_core.v \
    ../models/motion_ai_core.v \
    ../testbenches/ai_system_testbench.v

if [ $? -eq 0 ]; then
    echo "Compilation successful!"
    echo "Running simulation..."
    ./ai_simulation
    
    if [ -f dump.vcd ]; then
        echo "Simulation complete! Waveform saved to dump.vcd"
        echo "To view waveforms, run: gtkwave dump.vcd"
    fi
else
    echo "Compilation failed!"
    exit 1
fi
