module pes_graycode_tb();
    reg clk, enable, reset;
    wire [7:0] gray_count;
    
    pes_graycode gc1(clk, enable, reset, gray_count);
    
    initial
    begin
        $dumpfile("pes_graycode.vcd");
        $dumpvars(0, pes_graycode_tb);
        clk = 0;
        reset = 1;
        enable = 1;
        
        #5 reset = 0;
        #4000 $finish;     
    end 
    
    always #2 clk = ~clk;
       
endmodule
