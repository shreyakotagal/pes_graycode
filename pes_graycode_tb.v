module pes_graycode_tb();

    reg clk;
    reg enable;
    reg reset;
    wire [7:0] gray_count;

    // Instantiate the iiitb_gc module
    pes_graycode uut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .gray_count(gray_count)
    );

    // Clock generation
    always
    begin
        #5 clk = ~clk;
    end

    // Stimulus generation
    initial
    begin
        clk = 0;
        reset = 1;
        enable = 0;
        #10 reset = 0;

        // Test case 1: Perform some operations
        enable = 1;
        #20 enable = 0;

        // Test case 2: Reset
        reset = 1;
        #10 reset = 0;
        #20 reset = 1;
        #10 reset = 0;
        enable = 1;
        #20 enable = 0;

        // Add more test cases here as needed

        // Stop the simulation after some time
        #100 $finish;
    end

    // Display gray_count for monitoring
    always @(posedge clk)
    begin
        $display("gray_count = %h", gray_count);
    end

endmodule
