// ------------------------------------------------------------------
// DUT: Sum N 8-bit numbers
// ------------------------------------------------------------------
module dut_sum #(
    parameter N = 4
)(
    input  wire        clk,
    input  wire        rst,
    input  wire        en,
    input  wire [7:0]  data_in,
    output reg  [15:0] data_out,  // widen to 16 bits
    output reg         rdy
);

    // Internal registers
    reg [15:0] sum;      
    reg [2:0]  count;    
    reg         done;     

    // -----------------------------
    // Sequential logic
    // -----------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum      <= 0;
            count    <= 0;
            data_out <= 0;
            rdy      <= 0;
            done     <= 0;
        end else begin
            rdy  <= done;  // output ready pulse
            done <= 0;     // reset done

            if (en) begin
                sum   <= sum + data_in;
                count <= count + 1;

                if (count == N-1) begin
                    data_out <= sum + data_in;  // final sum
                    done     <= 1;              // pulse rdy next cycle
                    sum      <= 0;              // reset sum
                    count    <= 0;              // reset count
                end
            end
        end
    end

    // -----------------------------
    // VCD waveform generation
    // -----------------------------
    initial begin
        $dumpfile("sim_build/wave.vcd");
        $dumpvars(0, dut_sum);
    end

endmodule

