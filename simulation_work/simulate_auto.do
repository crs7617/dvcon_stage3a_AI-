# QuestaSim simulation script - Batch mode version
# This version adds waves automatically

# Create and map work library
vlib work
vmap work work

# Compile AI models
vlog ../models/vision_ai_core.v
vlog ../models/audio_ai_core.v
vlog ../models/motion_ai_core.v
vlog ../testbenches/ai_system_testbench.v

# Start simulation in batch mode first to set up waves
vsim -c ai_system_testbench -do "
  # Add all signals to wave
  add wave -r /*
  # Save wave setup
  write format wave -window sim_waves.wlf
  # Quit batch mode
  quit -f
"

# Now start GUI simulation
vsim -gui ai_system_testbench

echo "=========================================="
echo "Simulation loaded in GUI mode!"
echo "Wave window should be ready with all signals."
echo "Run the simulation with: run -all"
echo "=========================================="
