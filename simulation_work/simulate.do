# QuestaSim simulation script
vlib work
vmap work work

# Compile AI models with accessibility
vlog -work work +acc ../models/vision_ai_core.v
vlog -work work +acc ../models/audio_ai_core.v
vlog -work work +acc ../models/motion_ai_core.v
vlog -work work +acc ../testbenches/ai_system_testbench.v

# Start simulation without optimization
vsim -gui -voptargs=+acc ai_system_testbench

# Note: Add waves manually in transcript:
# add wave -r /*
# run -all
