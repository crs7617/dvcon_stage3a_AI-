// ai_system_testbench.v
`timescale 1ns/1ps

module ai_system_testbench;

// Clock and reset
reg clk;
reg rst_n;

// Vision AI signals
reg [7:0] vision_pixel;
reg vision_pixel_valid;
reg vision_frame_start;
reg vision_frame_end;
reg vision_start_proc;
wire [31:0] vision_result;
wire [7:0] vision_confidence;
wire vision_done;
wire vision_busy;

// Audio AI signals
reg [15:0] audio_sample;
reg audio_sample_valid;
reg audio_start_analysis;
wire [31:0] audio_classification;
wire [7:0] audio_threat_level;
wire audio_complete;
wire audio_busy;

// Motion AI signals
reg [15:0] motion_x, motion_y, motion_z;
reg motion_valid;
reg motion_start;
wire [31:0] motion_pattern;
wire [7:0] motion_anomaly;
wire motion_done;
wire motion_busy;

// Instantiate AI cores
vision_ai_core vision_ai (
    .clk(clk), .rst_n(rst_n),
    .pixel_data(vision_pixel),
    .pixel_valid(vision_pixel_valid),
    .frame_start(vision_frame_start),
    .frame_end(vision_frame_end),
    .start_processing(vision_start_proc),
    .control_reg(32'h00000001),
    .detection_result(vision_result),
    .confidence_score(vision_confidence),
    .processing_done(vision_done),
    .pixels_processed(),
    .ai_busy(vision_busy)
);

audio_ai_core audio_ai (
    .clk(clk), .rst_n(rst_n),
    .audio_sample(audio_sample),
    .sample_valid(audio_sample_valid),
    .start_analysis(audio_start_analysis),
    .analysis_config(32'h00000001),
    .audio_classification(audio_classification),
    .threat_level(audio_threat_level),
    .analysis_complete(audio_complete),
    .samples_processed(),
    .audio_ai_busy(audio_busy)
);

motion_ai_core motion_ai (
    .clk(clk), .rst_n(rst_n),
    .accel_x(motion_x),
    .accel_y(motion_y),
    .accel_z(motion_z),
    .accel_valid(motion_valid),
    .start_motion_analysis(motion_start),
    .motion_pattern(motion_pattern),
    .anomaly_score(motion_anomaly),
    .motion_analysis_done(motion_done),
    .motion_ai_busy(motion_busy)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100MHz
end

// Test memories
reg [7:0] vision_test_data [0:4095];
reg [15:0] audio_test_data [0:511];
reg [15:0] motion_test_x [0:99];
reg [15:0] motion_test_y [0:99];
reg [15:0] motion_test_z [0:99];

// Test execution
initial begin
    $display("=== AI System Integration Test ===");
    
    // Initialize
    rst_n = 0;
    vision_pixel_valid = 0;
    audio_sample_valid = 0;
    motion_valid = 0;
    vision_start_proc = 0;
    audio_start_analysis = 0;
    motion_start = 0;
    
    #100;
    rst_n = 1;
    
    // Load test data
    $readmemh("testdata/vision/normal_scene.hex", vision_test_data);
    $readmemh("testdata/audio/normal_audio.hex", audio_test_data);
    $readmemh("testdata/motion/normal_motion.hex", motion_test_x);
    // Note: In real implementation, you'd load Y and Z data separately
    
    $display("Test data loaded successfully");
    
    // Test 1: Normal scenario
    fork
        test_vision_normal();
        test_audio_normal();
        test_motion_normal();
    join
    
    #1000;
    
    // Test 2: Threat scenario
    $readmemh("testdata/vision/threat_scene.hex", vision_test_data);
    $readmemh("testdata/audio/alarm_audio.hex", audio_test_data);
    $readmemh("testdata/motion/fall_motion.hex", motion_test_x);
    
    fork
        test_vision_threat();
        test_audio_threat();
        test_motion_threat();
    join
    
    #2000;
    
    $display("=== All AI Tests Completed ===");
    $finish;
end

// Test tasks
task test_vision_normal();
    integer i;
    begin
        $display("Testing Vision AI - Normal Scene");
        @(posedge clk);
        vision_frame_start = 1;
        vision_start_proc = 1;
        @(posedge clk);
        vision_frame_start = 0;
        
        for (i = 0; i < 64*64; i = i + 1) begin
            @(posedge clk);
            vision_pixel = vision_test_data[i];
            vision_pixel_valid = 1;
        end
        
        vision_pixel_valid = 0;
        vision_frame_end = 1;
        @(posedge clk);
        vision_frame_end = 0;
        
        wait(vision_done);
        $display("Vision Result: %h, Confidence: %d", vision_result, vision_confidence);
    end
endtask

task test_audio_normal();
    integer i;
    begin
        $display("Testing Audio AI - Normal Audio");
        @(posedge clk);
        audio_start_analysis = 1;
        @(posedge clk);
        audio_start_analysis = 0;
        
        for (i = 0; i < 512; i = i + 1) begin
            @(posedge clk);
            audio_sample = audio_test_data[i];
            audio_sample_valid = 1;
        end
        
        audio_sample_valid = 0;
        wait(audio_complete);
        $display("Audio Classification: %h, Threat Level: %d", audio_classification, audio_threat_level);
    end
endtask

task test_motion_normal();
    integer i;
    begin
        $display("Testing Motion AI - Normal Motion");
        @(posedge clk);
        motion_start = 1;
        @(posedge clk);
        motion_start = 0;
        
        for (i = 0; i < 100; i = i + 1) begin
            @(posedge clk);
            motion_x = motion_test_x[i];
            motion_y = motion_test_x[i] >> 1; // Simplified
            motion_z = 16'h4000; // Gravity
            motion_valid = 1;
        end
        
        motion_valid = 0;
        wait(motion_done);
        $display("Motion Pattern: %h, Anomaly Score: %d", motion_pattern, motion_anomaly);
    end
endtask

// Similar tasks for threat scenarios
task test_vision_threat();
    // Similar to test_vision_normal but with threat data
    test_vision_normal(); // Reuse logic, data is already loaded
endtask

task test_audio_threat();
    test_audio_normal(); // Reuse logic, data is already loaded
endtask

task test_motion_threat();
    test_motion_normal(); // Reuse logic, data is already loaded
endtask

// Performance monitoring
always @(posedge clk) begin
    if (vision_done || audio_complete || motion_done) begin
        $display("Time: %t - AI Processing completed", $time);
    end
end

endmodule