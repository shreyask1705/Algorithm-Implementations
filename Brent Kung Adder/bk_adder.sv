module bk_adder_32b(
    input [31:0] a,
    input [31:0] b,
    input cin,
    output [32:0] sum
);
    logic [31:0] P, G; // Propagate and Generate signals
    logic [31:0] C; // Carry signals
    logic [31:0] S; // Sum signals

    always@(*) begin
        P = a ^ b; 
        G = a & b; 
        C[0] = cin; // Carry in
        // C[1] = G[0] | (P[0] & C[0]); 
        // C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
        // C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
        
        for (int i = 1; i < 32; i=i+1) begin
            C[i] = G[i-1] | (P[i-1] & C[i-1]);
        end
        
        S = P ^ C; 
    end

    assign sum = {C[31], S}; // Concatenate carry out with sum

endmodule
