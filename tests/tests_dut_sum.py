import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

# ----------------------------------------------------------------------
# Cocotb Testbench for dut_sum
# ----------------------------------------------------------------------

@cocotb.test()
async def sum_test(dut):
    """Test DUT with multiple input sets and check sums."""
    
    # ------------------------------
    # Start the clock (10 ns period)
    # ------------------------------
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    
    # ------------------------------
    # Reset DUT
    # ------------------------------
    dut.rst.value = 1
    dut.en.value = 0
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)
    
    # ------------------------------
    # Define test vectors
    # ------------------------------
    test_vectors = [
        [5, 10, 15, 20],       # Normal case
        [0, 0, 0, 0],          # All zeros
        [255, 1, 0, 0],        # Edge case: max 8-bit input
        [1, 2, 3, 4],          # Small numbers
    ]
    
    # ------------------------------
    # Apply test vectors
    # ------------------------------
    for vec in test_vectors:
        expected_sum = sum(vec)
        
        # Feed all inputs
        for val in vec:
            dut.data_in.value = val
            dut.en.value = 1
            await RisingEdge(dut.clk)  # Wait one clock
            dut.en.value = 0
        
        # Wait for ready pulse (rdy is a single-cycle pulse)
        while dut.rdy.value != 1:
            await RisingEdge(dut.clk)
        
        # ------------------------------
        # Check DUT outputs
        # ------------------------------
        cocotb.log.info(f"Expected sum: {expected_sum}, DUT sum: {int(dut.data_out.value)}")
        cocotb.log.info(f"DUT ready flag: {int(dut.rdy.value)}")
        assert dut.data_out.value == expected_sum, f"sum expected {expected_sum}, got {dut.data_out.value}"
        
        # Wait one more clock before next vector
        await RisingEdge(dut.clk)

