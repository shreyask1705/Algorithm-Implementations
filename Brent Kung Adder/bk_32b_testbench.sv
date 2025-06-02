module bk32_testbench();
    // Declare signals
    logic [31:0] a, b;
    logic        cin;
    logic [32:0] sum;

    // Arrays to hold test vectors
    logic [31:0] a_vals [0:99];
    logic [31:0] b_vals [0:99];
    logic        cin_vals [0:99];

    // Instantiate the DUT
    bk_adder_32b dut (
        .a   (a),
        .b   (b),
        .cin (cin),
        .sum (sum)
    );

    initial begin
        // Read in the test vectors (hex for a and b, decimal for cin)
        $readmemh("C:/Users/shrey/OneDrive/Documents/Projects/Brent_Kung_Adder/a_values.txt",   a_vals);
        $readmemh("C:/Users/shrey/OneDrive/Documents/Projects/Brent_Kung_Adder/b_values.txt",   b_vals);
        $readmemh("C:/Users/shrey/OneDrive/Documents/Projects/Brent_Kung_Adder/cin_values.txt", cin_vals);

        // Setup waveform dumping
        $dumpfile("C:/Users/shrey/OneDrive/Documents/Projects/Brent_Kung_Adder/bk_32b_test.vcd");
        $dumpvars(0, bk32_testbench);

        // Drive the 100 test cases
        //integer i;
        for (int i = 0; i < 100; i = i + 1) begin
            a   = a_vals[i];
            b   = b_vals[i];
            cin = cin_vals[i];
            #10;
        end

        $finish;
    end
endmodule
