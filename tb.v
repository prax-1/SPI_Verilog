module tb_top;

    reg clk = 0;
    reg start = 1;
    wire sclk;
    reg [11:0] din = 12'hf5;
    reg [11:0] dout;

    // Instantiate the top module
    top dut (
        .clk(clk),
        .start(start),
        .din(din),
        .sclk(sclk),
        .dout(dout)
    );

    // Clock generation process
    always #5 clk = ~clk;

    // Initial process
    initial begin
        // Reset signals
        start = 1;

        // Wait for a few clock cycles before starting
        #10;

        // De-assert start after initial setup
        start = 0;

        // Simulate for a period of time
        #100;

        // Display simulation results
        $display("Simulation complete");
        $finish;
    end

endmodule
