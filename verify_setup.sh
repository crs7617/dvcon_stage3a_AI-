#!/bin/bash
# Path verification script for DVCON Stage 3A

echo "=== DVCON Stage 3A Path Verification ==="
echo "Current directory: $(pwd)"
echo

echo "1. Checking project structure..."
echo "Main project directory: /home/sairam/dvcon-stage3a"
if [ -d "/home/sairam/dvcon-stage3a" ]; then
    echo "✓ Main directory exists"
else
    echo "✗ Main directory missing"
fi

echo
echo "2. Checking Verilog models..."
for model in vision_ai_core.v audio_ai_core.v motion_ai_core.v; do
    if [ -f "/home/sairam/dvcon-stage3a/models/$model" ]; then
        echo "✓ $model exists"
    else
        echo "✗ $model missing"
    fi
done

echo
echo "3. Checking testbench..."
if [ -f "/home/sairam/dvcon-stage3a/testbenches/ai_system_testbench.v" ]; then
    echo "✓ ai_system_testbench.v exists"
else
    echo "✗ ai_system_testbench.v missing"
fi

echo
echo "4. Checking simulation setup..."
if [ -f "/home/sairam/dvcon-stage3a/simulation_work/simulate.do" ]; then
    echo "✓ simulate.do exists"
else
    echo "✗ simulate.do missing"
fi

echo
echo "5. Checking test data..."
for data_type in vision audio motion; do
    if [ -d "/home/sairam/dvcon-stage3a/simulation_work/testdata/$data_type" ]; then
        echo "✓ $data_type test data exists"
        echo "   Files: $(ls /home/sairam/dvcon-stage3a/simulation_work/testdata/$data_type/ | tr '\n' ' ')"
    else
        echo "✗ $data_type test data missing"
    fi
done

echo
echo "6. Checking scripts..."
for script in generate_simulation_data.py run_ai_simulation.sh run_iverilog_simulation.sh; do
    if [ -f "/home/sairam/dvcon-stage3a/scripts/$script" ]; then
        echo "✓ $script exists"
    else
        echo "✗ $script missing"
    fi
done

echo
echo "=== Ready to run QuestaSim ==="
echo "To start simulation:"
echo "1. cd /home/sairam/dvcon-stage3a/simulation_work"
echo "2. vsim -do simulate.do"
echo
