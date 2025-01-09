module cordic #(
    parameter data_width = 16,
    parameter iterations = 15
    )(
    input clk,
    input reset_n,
    input logic signed [data_width-1:0] angle,
    input logic signed [data_width-1:0] x_i,
    input logic signed [data_width-1:0] y_i,
    output logic signed [data_width-1:0] cos,
    output logic signed [data_width-1:0] sin,
    input valid_in,
    output logic valid_out
    );

    // Lookup table for atan(2^-i) values
    logic signed [data_width-1:0] atan_table [0:iterations-1];
    
    initial begin
        atan_table[0]  = 'd12867;  // atan(2^0) in fixed-point
        atan_table[1]  = 'd7596;   // atan(2^-1)
        atan_table[2]  = 'd4013;   // atan(2^-2)
        atan_table[3]  = 'd2037;   // atan(2^-3)
        atan_table[4]  = 'd1021;   // atan(2^-4)
        atan_table[5]  = 'd511;    // atan(2^-5)
        atan_table[6]  = 'd256;    // atan(2^-6)
        atan_table[7]  = 'd128;    // atan(2^-7)
        atan_table[8]  = 'd64;     // atan(2^-8)
        atan_table[9]  = 'd32;     // atan(2^-9)
        atan_table[10] = 'd16;     // atan(2^-10)
        atan_table[11] = 'd8;      // atan(2^-11)
        atan_table[12] = 'd4;      // atan(2^-12)
        atan_table[13] = 'd2;      // atan(2^-13)
        atan_table[14] = 'd1;      // atan(2^-14)
    end

    // Pipelined registers
    logic signed [data_width-1:0] x [0:iterations], y [0:iterations], z [0:iterations];
    logic [$clog2(iterations)-1:0] iteration;
    logic valid_pipe [0:iterations];

    // Initialize first stage
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            x[0] <= 0;
            y[0] <= 0;
            z[0] <= 0;
            valid_pipe[0] <= 0;
        end else if (valid_in) begin
            case (angle[15:14])
                2'b00: begin
                    x[0] <= x_i;
                    y[0] <= y_i;
                    z[0] <= angle;
                end
                2'b01: begin
                    x[0] <= -y_i;
                    y[0] <= x_i;
                    z[0] <= {2'b00, angle[13:0]};
                end
                2'b10: begin
                    x[0] <= -x_i;
                    y[0] <= -y_i;
                    z[0] <= {2'b11, angle[13:0]};
                end
                2'b11: begin
                    x[0] <= y_i;
                    y[0] <= -x_i;
                    z[0] <= -angle;
                end
            endcase
            valid_pipe[0] <= 1;
        end else begin
            valid_pipe[0] <= 0;
        end
    end

    // Pipelined stages
    genvar i;
    generate
        for (i = 0; i < iterations; i = i + 1) begin : cordic_pipeline
            always_ff @(posedge clk or negedge reset_n) begin
                if (!reset_n) begin
                    x[i+1] <= 0;
                    y[i+1] <= 0;
                    z[i+1] <= 0;
                    valid_pipe[i+1] <= 0;
                end else if (valid_pipe[i]) begin
                    if (z[i] < 0) begin
                        x[i+1] <= x[i] + (y[i] >>> i);
                        y[i+1] <= y[i] - (x[i] >>> i);
                        z[i+1] <= z[i] + atan_table[i];
                    end else begin
                        x[i+1] <= x[i] - (y[i] >>> i);
                        y[i+1] <= y[i] + (x[i] >>> i);
                        z[i+1] <= z[i] - atan_table[i];
                    end
                    valid_pipe[i+1] <= 1;
                end else begin
                    valid_pipe[i+1] <= 0;
                end
            end
        end
    endgenerate

    // Assign outputs
    assign cos = x[iterations];
    assign sin = y[iterations];
    assign valid_out = valid_pipe[iterations];

endmodule
