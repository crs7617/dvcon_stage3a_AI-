module multi_accelerator_top_testbench;

// Test signals
reg s_axi_aclk_IBUF_BUFG;
reg s_axi_aresetn_IBUF;

// AXI4-Lite Slave Interface signals
reg [5:0] s_axi_araddr_IBUF;
reg s_axi_arvalid_IBUF;
wire s_axi_arready;
wire s_axi_arready_OBUF;
wire [31:0] s_axi_rdata_OBUF;
wire s_axi_rvalid;
wire s_axi_rvalid_OBUF;
reg s_axi_rready_IBUF;

reg [5:0] s_axi_awaddr_IBUF;
reg s_axi_awvalid_IBUF;
reg s_axi_awvalid;
wire s_axi_awready;
wire s_axi_awready_OBUF;
reg [127:0] s_axi_wdata_IBUF;
reg [15:0] s_axi_wstrb_IBUF;
reg s_axi_wvalid_IBUF;
reg s_axi_wvalid;
wire s_axi_wready;
wire s_axi_wready_OBUF;
reg s_axi_wlast;
wire s_axi_bvalid;
wire s_axi_bvalid_OBUF;
reg s_axi_bready_IBUF;

// AXI4 Master Interface signals
wire [63:2] m_axi_gmem_AWADDR;
wire [3:0] m_axi_gmem_AWLEN;
wire s_acc_axi_arvalid;
reg s_axi_arready_master;

wire [63:2] m_axi_gmem_ARADDR;
wire [3:0] m_axi_gmem_ARLEN;
reg s_acc_axi_bready;
reg s_acc_axi_rready;

wire [31:0] m_axi_gmem_WDATA;
wire [3:0] m_axi_gmem_WSTRB;

// Data and Response signals
reg [32:0] D;
reg [1:0] RRESP;

// Test variables
reg [31:0] read_data;

// Clock generation
initial begin
    s_axi_aclk_IBUF_BUFG = 0;
    forever #5 s_axi_aclk_IBUF_BUFG = ~s_axi_aclk_IBUF_BUFG; // 100MHz clock
end

// Instantiate the multi_accelerator_top_integrated
multi_accelerator_top_integrated uut (
    .s_axi_aclk_IBUF_BUFG(s_axi_aclk_IBUF_BUFG),
    .s_axi_aresetn_IBUF(s_axi_aresetn_IBUF),
    
    // AXI4-Lite Slave Interface
    .s_axi_araddr_IBUF(s_axi_araddr_IBUF),
    .s_axi_arvalid_IBUF(s_axi_arvalid_IBUF),
    .s_axi_arready(s_axi_arready),
    .s_axi_arready_OBUF(s_axi_arready_OBUF),
    .s_axi_rdata_OBUF(s_axi_rdata_OBUF),
    .s_axi_rvalid(s_axi_rvalid),
    .s_axi_rvalid_OBUF(s_axi_rvalid_OBUF),
    .s_axi_rready_IBUF(s_axi_rready_IBUF),
    
    .s_axi_awaddr_IBUF(s_axi_awaddr_IBUF),
    .s_axi_awvalid_IBUF(s_axi_awvalid_IBUF),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awready(s_axi_awready),
    .s_axi_awready_OBUF(s_axi_awready_OBUF),
    .s_axi_wdata_IBUF(s_axi_wdata_IBUF),
    .s_axi_wstrb_IBUF(s_axi_wstrb_IBUF),
    .s_axi_wvalid_IBUF(s_axi_wvalid_IBUF),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wready(s_axi_wready),
    .s_axi_wready_OBUF(s_axi_wready_OBUF),
    .s_axi_wlast(s_axi_wlast),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bvalid_OBUF(s_axi_bvalid_OBUF),
    .s_axi_bready_IBUF(s_axi_bready_IBUF),
    
    // AXI4 Master Interface
    .m_axi_gmem_AWADDR(m_axi_gmem_AWADDR),
    .m_axi_gmem_AWLEN(m_axi_gmem_AWLEN),
    .s_acc_axi_arvalid(s_acc_axi_arvalid),
    .s_axi_arready_master(s_axi_arready_master),
    
    .m_axi_gmem_ARADDR(m_axi_gmem_ARADDR),
    .m_axi_gmem_ARLEN(m_axi_gmem_ARLEN),
    .s_acc_axi_bready(s_acc_axi_bready),
    .s_acc_axi_rready(s_acc_axi_rready),
    
    .m_axi_gmem_WDATA(m_axi_gmem_WDATA),
    .m_axi_gmem_WSTRB(m_axi_gmem_WSTRB),
    
    .D(D),
    .RRESP(RRESP)
);

// Task to write AXI register
task write_axi_register;
    input [5:0] addr;
    input [31:0] data;
    begin
        @(posedge s_axi_aclk_IBUF_BUFG);
        s_axi_awaddr_IBUF = addr;
        s_axi_awvalid_IBUF = 1'b1;
        s_axi_awvalid = 1'b1;
        s_axi_wdata_IBUF = {96'b0, data}; // Put data in lower 32 bits
        s_axi_wstrb_IBUF = 16'hFFFF;
        s_axi_wvalid_IBUF = 1'b1;
        s_axi_wvalid = 1'b1;
        s_axi_wlast = 1'b1;
        s_axi_bready_IBUF = 1'b1;
        
        // Wait for write to complete
        wait(s_axi_awready && s_axi_wready);
        @(posedge s_axi_aclk_IBUF_BUFG);
        s_axi_awvalid_IBUF = 1'b0;
        s_axi_awvalid = 1'b0;
        s_axi_wvalid_IBUF = 1'b0;
        s_axi_wvalid = 1'b0;
        
        wait(s_axi_bvalid);
        @(posedge s_axi_aclk_IBUF_BUFG);
        s_axi_bready_IBUF = 1'b0;
        
        $display("Time: %0t - Written 0x%h to register 0x%h", $time, data, addr);
    end
endtask

// Task to read AXI register
task read_axi_register;
    input [5:0] addr;
    output [31:0] data;
    begin
        @(posedge s_axi_aclk_IBUF_BUFG);
        s_axi_araddr_IBUF = addr;
        s_axi_arvalid_IBUF = 1'b1;
        s_axi_rready_IBUF = 1'b1;
        
        wait(s_axi_arready);
        @(posedge s_axi_aclk_IBUF_BUFG);
        s_axi_arvalid_IBUF = 1'b0;
        
        wait(s_axi_rvalid);
        @(posedge s_axi_aclk_IBUF_BUFG);
        data = s_axi_rdata_OBUF;
        s_axi_rready_IBUF = 1'b0;
        
        $display("Time: %0t - Read 0x%h from register 0x%h", $time, data, addr);
    end
endtask

// Test sequence
initial begin
    // Initialize signals
    s_axi_aresetn_IBUF = 0;
    s_axi_araddr_IBUF = 0;
    s_axi_arvalid_IBUF = 0;
    s_axi_rready_IBUF = 0;
    s_axi_awaddr_IBUF = 0;
    s_axi_awvalid_IBUF = 0;
    s_axi_awvalid = 0;
    s_axi_wdata_IBUF = 0;
    s_axi_wstrb_IBUF = 0;
    s_axi_wvalid_IBUF = 0;
    s_axi_wvalid = 0;
    s_axi_wlast = 0;
    s_axi_bready_IBUF = 0;
    s_axi_arready_master = 1;
    s_acc_axi_bready = 1;
    s_acc_axi_rready = 1;
    D = 33'h100000000; // Memory ready with sample data
    RRESP = 2'b00;
    
    $display("========================================");
    $display("Multi-Accelerator Top Integrated Test");
    $display("========================================");
    
    // Reset sequence
    #100;
    s_axi_aresetn_IBUF = 1;
    $display("Time: %0t - Reset released", $time);
    
    #100;
    
    // Test 1: Read initial status
    read_axi_register(6'h04, read_data); // Status register
    $display("Initial status: 0x%h", read_data);
    
    // Test 2: Enable all AI cores
    $display("\n--- Test: Enable Audio, Vision, and Motion AI cores ---");
    write_axi_register(6'h00, 32'h00000007); // Enable audio, video, motion
    
    // Test 3: Configure Audio AI core
    $display("\n--- Test: Configure Audio AI core ---");
    write_axi_register(6'h08, 32'h00001000); // Audio config - memory address
    
    // Test 4: Configure Vision AI core
    $display("\n--- Test: Configure Vision AI core ---");
    write_axi_register(6'h0C, 32'h00003000); // Video config - memory address
    
    // Test 5: Configure Motion AI core
    $display("\n--- Test: Configure Motion AI core ---");
    write_axi_register(6'h10, 32'h00002000); // Motion config - memory address
    
    // Test 6: Monitor status register for interrupts
    $display("\n--- Test: Monitor AI processing status ---");
    repeat(10) begin
        #1000;
        read_axi_register(6'h04, read_data); // Status register
        $display("Status: 0x%h - Audio IRQ: %b, Video IRQ: %b, Motion IRQ: %b", 
                 read_data, read_data[0], read_data[1], read_data[2]);
        
        // Provide memory data when requested
        if (s_acc_axi_arvalid) begin
            D = {1'b1, $random}; // Ready with random data
        end
    end
    
    // Test 7: Disable cores
    $display("\n--- Test: Disable all AI cores ---");
    write_axi_register(6'h00, 32'h00000000); // Disable all
    
    #1000;
    read_axi_register(6'h04, read_data); // Final status
    $display("Final status: 0x%h", read_data);
    
    $display("\n========================================");
    $display("Multi-Accelerator Top Test Complete");
    $display("========================================");
    
    #1000;
    $finish;
end

// Monitor important signals
initial begin
    $monitor("Time: %0t - Control: 0x%h, Status: 0x%h, Audio En: %b, Video En: %b, Motion En: %b",
             $time, uut.control_reg, uut.status_reg, 
             uut.audio_enable, uut.video_enable, uut.motion_enable);
end

endmodule
