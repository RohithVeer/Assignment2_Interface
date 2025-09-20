// ------------------------------------------------------------------
// Bluespec DUT to sum N integers
// ------------------------------------------------------------------
module mkDutSum #(parameter Integer N = 4) (Empty);

    // ------------------------------------------------------------------
    // Internal Registers
    // ------------------------------------------------------------------
    // Holds the running sum of input integers
    Reg#(Integer) sum <- mkReg(0);

    // Counts how many inputs have been received
    Reg#(Integer) count <- mkReg(0);

    // ------------------------------------------------------------------
    // Method: inputData
    // Accepts an input integer and updates sum and count
    // Executes only if count < N
    // ------------------------------------------------------------------
    method Action inputData(Integer data) if (count < N);
        // Add current input to running sum
        sum <= sum + data;

        // Increment the count of received inputs
        count <= count + 1;

        // Check if we have reached N inputs
        if (count == N-1) begin
            // Print the sum of N integers
            $display("Sum: %0d", sum + data);

            // Reset sum and count for next round
            sum <= 0;
            count <= 0;
        end
    endmethod

endmodule

