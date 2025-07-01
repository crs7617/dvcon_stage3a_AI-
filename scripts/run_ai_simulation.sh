#!/bin/bash
# run_ai_simulation.sh - AI Component Simulation Script

echo "=== DVCON 2025 AI Component Simulation ==="

# Set paths
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="$PROJECT_ROOT/simulation_work"

# Create simulation working directory
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

# Generate test data
echo "Step 1: Generating test data..."
cd "$PROJECT_ROOT/scripts"
python3 generate_simulation_data.py
if [ $? -ne 0 ]; then
    echo "ERROR: Test data generation failed!"
    exit 1
fi

echo "Step 2: Setting up QuestaSim environment..."
cd "$WORK_DIR"

# Create QuestaSim project file
cat > simulate.do << 'EOF'
# QuestaSim simulation script
vlib work
vmap work work

# Compile AI models
vlog ../models/vision_ai_core.v
vlog ../models/audio_ai_core.v
vlog ../models/motion_ai_core.v
vlog ../testbenches/ai_system_testbench.v

# Start simulation
vsim -gui ai_system_testbench

# Add all signals to wave window
add wave -r /*

# Run simulation
run -all

# Save waveform
write format wave -window .main_pane.wave.interior.cs.body.pw.wf sim_results.wlf

echo "Simulation completed successfully!"
EOF

echo "Step 3: Copying test data to simulation directory..."
cp -r testdata "$WORK_DIR/"

echo "Step 4: Starting QuestaSim..."
echo "Run the following command to start simulation:"
echo "cd $WORK_DIR && vsim -do simulate.do"

echo ""
echo "=== Manual Steps in QuestaSim ==="
echo "1. QuestaSim will open with the simulation loaded"
echo "2. In the wave window, you'll see all signals"
echo "3. Click 'Run All' or type 'run -all' in transcript"
echo "4. Take screenshots of the waveforms"
echo "5. Save transcript: File → Save → Transcript"
echo ""
echo "Simulation setup complete!"