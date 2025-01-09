module cordic_tb;
    // Parameters
    localparam data_width = 16;
    localparam iterations = 15;

    // Signals
    logic clk, reset_n, valid_in, valid_out;
    logic signed [data_width-1:0] angle, x_i, y_i;
    logic signed [data_width-1:0] cos, sin;

    // DUT instantiation
    cordic #(data_width, iterations) dut (
        .clk(clk),
        .reset_n(reset_n),
        .angle(angle),
        .x_i(x_i),
        .y_i(y_i),
        .cos(cos),
        .sin(sin),
        .valid_in(valid_in),
        .valid_out(valid_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        reset_n = 0;
        valid_in = 0;
        angle = 0;
        x_i = 0;
        y_i = 0;

        // Apply reset
        #10 reset_n = 1;

        // Test case 1: 45 degrees
        #10 angle = 16'd11585;  // 45 degrees in fixed-point
            x_i = 16'd92682;     // 1.0 in fixed-point
            y_i = 16'd0;
            valid_in = 1;

        // Test case 2: -45 degrees
        #20 angle = -16'd11585;
            x_i = 16'd92682;
            y_i = 16'd0;

        // Test case 3: 90 degrees
        #20 angle = 16'd23170;
            x_i = 16'd92682;
            y_i = 16'd0;

        // Test case 4: -90 degrees
        #20 angle = -16'd23170;
            x_i = 16'd92682;
            y_i = 16'd0;

        // Test case 5: 0 degrees
        #20 angle = 16'd0;
            x_i = 16'd92682;
            y_i = 16'd0;

        // End test
        #100 $stop;
    end

endmodule
