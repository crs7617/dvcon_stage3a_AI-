# generate_simulation_data.py
import numpy as np
import os

def create_test_data_directory():
    os.makedirs("testdata", exist_ok=True)
    os.makedirs("testdata/vision", exist_ok=True)
    os.makedirs("testdata/audio", exist_ok=True)
    os.makedirs("testdata/motion", exist_ok=True)

def generate_vision_test_data():
    """Generate image-like data for vision AI testing"""
    
    # Normal scene (low feature content)
    normal_image = np.random.randint(50, 100, (64, 64), dtype=np.uint8)
    with open("testdata/vision/normal_scene.hex", "w") as f:
        f.write("// Normal scene test data\n")
        for i, pixel in enumerate(normal_image.flatten()):
            f.write(f"@{i:04x} {pixel:02x}\n")
    
    # Threat scene (high contrast/edges)
    threat_image = np.random.randint(0, 255, (64, 64), dtype=np.uint8)
    # Add high contrast regions
    threat_image[20:40, 20:40] = 255
    threat_image[25:35, 25:35] = 0
    
    with open("testdata/vision/threat_scene.hex", "w") as f:
        f.write("// Threat scene test data\n")
        for i, pixel in enumerate(threat_image.flatten()):
            f.write(f"@{i:04x} {pixel:02x}\n")

def generate_audio_test_data():
    """Generate audio-like data for audio AI testing"""
    
    # Normal audio (low amplitude)
    normal_audio = (np.random.normal(0, 0.1, 512) * 32767).astype(np.int16)
    with open("testdata/audio/normal_audio.hex", "w") as f:
        f.write("// Normal audio test data\n")
        for i, sample in enumerate(normal_audio):
            # Convert signed int16 to unsigned hex (proper conversion)
            unsigned_sample = int(sample) & 0xFFFF
            f.write(f"@{i:04x} {unsigned_sample:04x}\n")
    
    # Alarm audio (high amplitude, specific frequency)
    t = np.linspace(0, 1, 512)
    alarm_audio = (0.8 * np.sin(2 * np.pi * 1000 * t) * 32767).astype(np.int16)
    with open("testdata/audio/alarm_audio.hex", "w") as f:
        f.write("// Alarm audio test data\n")
        for i, sample in enumerate(alarm_audio):
            # Convert signed int16 to unsigned hex (proper conversion)
            unsigned_sample = int(sample) & 0xFFFF
            f.write(f"@{i:04x} {unsigned_sample:04x}\n")

def generate_motion_test_data():
    """Generate motion sensor data for motion AI testing"""
    
    # Normal walking motion
    t = np.linspace(0, 2, 100)
    normal_x = (0.2 * np.sin(2 * np.pi * 2 * t) * 32767).astype(np.int16)
    normal_y = (0.1 * np.cos(2 * np.pi * 2 * t) * 32767).astype(np.int16)
    normal_z = (np.ones(100) * 32767 * 0.98).astype(np.int16)
    
    with open("testdata/motion/normal_motion.hex", "w") as f:
        f.write("// Normal motion test data\n")
        for i in range(100):
            x_val = int(normal_x[i]) & 0xFFFF
            y_val = int(normal_y[i]) & 0xFFFF
            z_val = int(normal_z[i]) & 0xFFFF
            f.write(f"@{i*3:04x} {x_val:04x}\n")
            f.write(f"@{i*3+1:04x} {y_val:04x}\n")
            f.write(f"@{i*3+2:04x} {z_val:04x}\n")
    
    # Fall/emergency motion
    fall_motion = (np.random.normal(0, 2, (100, 3)) * 32767).astype(np.int16)
    with open("testdata/motion/fall_motion.hex", "w") as f:
        f.write("// Fall motion test data\n")
        for i in range(100):
            x_val = int(fall_motion[i,0]) & 0xFFFF
            y_val = int(fall_motion[i,1]) & 0xFFFF
            z_val = int(fall_motion[i,2]) & 0xFFFF
            f.write(f"@{i*3:04x} {x_val:04x}\n")
            f.write(f"@{i*3+1:04x} {y_val:04x}\n")
            f.write(f"@{i*3+2:04x} {z_val:04x}\n")

if __name__ == "__main__":
    create_test_data_directory()
    generate_vision_test_data()
    generate_audio_test_data()
    generate_motion_test_data()
    print("Test data generated successfully!")