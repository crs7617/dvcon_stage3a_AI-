# QuestaSim simulation script for integrated multi-accelerator top
# This script compiles and runs the integrated top module with audio and motion AI cores

# Map work library
vmap work work

# Compile the source files with accessibility
echo "Compiling source files..."

# Compile AI core modules
vlog -work work +acc ../models/audio_ai_core.v
vlog -work work +acc ../models/motion_ai_core.v 
vlog -work work +acc ../models/vision_ai_core.v

# Compile the integrated top module
vlog -work work +acc ../multi_accelerator_top_integrated.v

# Compile the testbench
vlog -work work +acc ../testbenches/multi_accelerator_top_testbench.v

# Load the testbench
vsim -t ps multi_accelerator_top_testbench

# Add waveforms for integrated top
echo "Adding waveforms..."

# Clock and Reset
add wave -group "Clock/Reset" /multi_accelerator_top_testbench/s_axi_aclk_IBUF_BUFG
add wave -group "Clock/Reset" /multi_accelerator_top_testbench/s_axi_aresetn_IBUF

# AXI Control Interface
add wave -group "AXI Control" /multi_accelerator_top_testbench/s_axi_awaddr_IBUF
add wave -group "AXI Control" /multi_accelerator_top_testbench/s_axi_awvalid_IBUF
add wave -group "AXI Control" /multi_accelerator_top_testbench/s_axi_awready
add wave -group "AXI Control" /multi_accelerator_top_testbench/s_axi_wdata_IBUF
add wave -group "AXI Control" /multi_accelerator_top_testbench/s_axi_wvalid_IBUF
add wave -group "AXI Control" /multi_accelerator_top_testbench/s_axi_wready
add wave -group "AXI Control" /multi_accelerator_top_testbench/s_axi_bvalid
add wave -group "AXI Control" /multi_accelerator_top_testbench/s_axi_bready_IBUF

# AXI Read Interface
add wave -group "AXI Read" /multi_accelerator_top_testbench/s_axi_araddr_IBUF
add wave -group "AXI Read" /multi_accelerator_top_testbench/s_axi_arvalid_IBUF
add wave -group "AXI Read" /multi_accelerator_top_testbench/s_axi_arready
add wave -group "AXI Read" /multi_accelerator_top_testbench/s_axi_rdata_OBUF
add wave -group "AXI Read" /multi_accelerator_top_testbench/s_axi_rvalid
add wave -group "AXI Read" /multi_accelerator_top_testbench/s_axi_rready_IBUF

# Control and Status Registers
add wave -group "Registers" /multi_accelerator_top_testbench/uut/control_reg
add wave -group "Registers" /multi_accelerator_top_testbench/uut/status_reg
add wave -group "Registers" /multi_accelerator_top_testbench/uut/audio_config_reg
add wave -group "Registers" /multi_accelerator_top_testbench/uut/video_config_reg
add wave -group "Registers" /multi_accelerator_top_testbench/uut/motion_config_reg

# Enable Signals
add wave -group "Enables" /multi_accelerator_top_testbench/uut/audio_enable
add wave -group "Enables" /multi_accelerator_top_testbench/uut/video_enable
add wave -group "Enables" /multi_accelerator_top_testbench/uut/motion_enable

# Memory Arbiter
add wave -group "Memory Arbiter" /multi_accelerator_top_testbench/uut/arbiter_state
add wave -group "Memory Arbiter" /multi_accelerator_top_testbench/uut/mem_addr_internal
add wave -group "Memory Arbiter" /multi_accelerator_top_testbench/uut/mem_read_enable
add wave -group "Memory Arbiter" /multi_accelerator_top_testbench/uut/mem_ready_internal

# Audio Processing Signals
add wave -group "Audio AI" /multi_accelerator_top_testbench/uut/audio_adapter/audio_proc_state
add wave -group "Audio AI" /multi_accelerator_top_testbench/uut/audio_adapter/audio_ai_busy
add wave -group "Audio AI" /multi_accelerator_top_testbench/uut/audio_adapter/audio_start_pulse
add wave -group "Audio AI" /multi_accelerator_top_testbench/uut/audio_adapter/audio_core/audio_classification
add wave -group "Audio AI" /multi_accelerator_top_testbench/uut/audio_adapter/audio_core/threat_level
add wave -group "Audio AI" /multi_accelerator_top_testbench/uut/audio_adapter/audio_core/analysis_complete

# Motion Processing Signals  
add wave -group "Motion AI" /multi_accelerator_top_testbench/uut/motion_adapter/motion_proc_state
add wave -group "Motion AI" /multi_accelerator_top_testbench/uut/motion_adapter/motion_ai_busy
add wave -group "Motion AI" /multi_accelerator_top_testbench/uut/motion_adapter/motion_start_pulse
add wave -group "Motion AI" /multi_accelerator_top_testbench/uut/motion_adapter/motion_core/motion_pattern
add wave -group "Motion AI" /multi_accelerator_top_testbench/uut/motion_adapter/motion_core/anomaly_score
add wave -group "Motion AI" /multi_accelerator_top_testbench/uut/motion_adapter/motion_core/motion_analysis_done

# Vision Processing Signals
add wave -group "Vision AI" /multi_accelerator_top_testbench/uut/vision_adapter/vision_proc_state
add wave -group "Vision AI" /multi_accelerator_top_testbench/uut/vision_adapter/vision_ai_busy
add wave -group "Vision AI" /multi_accelerator_top_testbench/uut/vision_adapter/vision_start_pulse

# Interrupt Signals
add wave -group "Interrupts" /multi_accelerator_top_testbench/uut/audio_interrupt
add wave -group "Interrupts" /multi_accelerator_top_testbench/uut/motion_interrupt
add wave -group "Interrupts" /multi_accelerator_top_testbench/uut/vision_interrupt

# Set waveform display options
wave zoom full
configure wave -namecolwidth 300
configure wave -valuecolwidth 100

echo "Starting integrated simulation..."
run -all

echo "Integrated simulation complete!"
echo "Use 'wave zoom full' to see all waveforms"
