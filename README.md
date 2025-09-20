# DUT_SUM IP

## IP Introduction

The DUT_SUM IP is a configurable accumulator module that sums a set of 8-bit input values and outputs the result. It is designed with three main interfaces:

1. **Data Interface** – Handles input and output data.
2. **Control Interface** – Used by other hardware blocks to control or modify the behavior of the IP.
3. **Configuration Interface** – Used by a processor or software to configure the behavior of the IP.

The IP follows the **RDY/EN protocol** on all interfaces to synchronize data and control signals.

---

## IP Functionality

* Accumulates `N` 8-bit input values and outputs the sum.
* The number of values `N` can be specified:
  * **At the interface** via the `length` port.
  * **Via configuration register** accessible through the configuration interface.
* A configuration bit determines whether the port or the register value is used as the source of `N`.
* Once accumulation starts, changes to length (port or register) are ignored until the output is produced.
* Supports **pause** functionality and software override for length programming.
* Produces a **ready signal** indicating valid data on output.

---

## Interfaces

| Port         | Direction | Width | Description                                         |
| ------------ | --------- | ----- | --------------------------------------------------- |
| din_rdy      | out       | 1     | Ready signal for input data                         |
| din_en       | in        | 1     | Enable signal for input data                        |
| din_value    | in        | 8     | Input data                                          |
| dout_rdy     | out       | 1     | Ready signal for output data                        |
| dout_en      | in        | 1     | Enable signal for output data                       |
| dout_value   | out       | 16    | Accumulated output data                              |
| len_rdy      | out       | 1     | Ready signal for length input                        |
| len_en       | in        | 1     | Enable signal for length input                       |
| len_value    | in        | 8     | Number of input bytes to accumulate                 |
| cfg_rdy      | out       | 1     | Ready signal for configuration interface            |
| cfg_en       | in        | 1     | Enable signal for configuration interface           |
| cfg_address  | in        | 8     | Address of register in configuration space          |
| cfg_op       | in        | 1     | Operation type (0=Read, 1=Write)                   |
| cfg_data_in  | in        | 32    | Data to write (ignored for read operations)        |
| cfg_data_out | out       | 32    | Data returned from read operation                   |

---

## Configuration Space Register Map

| Address | Access | Bit map | Reset | Field             | Description                                                                 |
| ------- | ------ | ------- | ----- | ----------------- | --------------------------------------------------------------------------- |
| 0       | R      | 7:0     | 0     | current_count     | Number of bytes processed                                                   |
| 0       | R      | 15:8    | 0     | programmed_length | Length programmed for this session                                         |
| 0       | R      | 16      | 0     | busy              | 1 if operation is ongoing                                                  |
| 4       | R/W    | 0       | 0     | sw_override       | 0=use length from port, 1=use length from register                          |
| 4       | R/W    | 1       | 0     | pause             | 1=input ready will be deasserted after current dataset                     |
| 8       | R/W    | 7:0     | 0     | len               | Length register (programmed length for accumulation)                        |

---

## Test Plan

1. **Initialization and Data Input**
   - Reset the IP.
   - Provide input data and enable signals.
   - Verify accumulation and ready flags.

2. **Length Programming via Port**
   - Program length via `len_value` port.
   - Verify accumulation matches programmed length.

3. **Length Programming via Configuration Register**
   - Program length via `cfg_address=8`.
   - Verify accumulation respects register value.

4. **Software Override of Length**
   - Enable software override via `cfg_address=4`.
   - Verify accumulation uses port length over register.

5. **Pausing Input**
   - Enable pause bit via configuration register.
   - Verify accumulation stops at the programmed length and input ready is deasserted.

6. **Reading Configuration Register**
   - Program values into configuration registers.
   - Read back and verify correct values.

7. **Busy Signal**
   - Verify `busy` is high during accumulation and low when idle.

8. **Reset Operation**
   - Perform reset during accumulation.
   - Verify output and internal state reset correctly.

---

## Notes

* All outputs are synchronized to the clock.
* Accumulated output width is 16 bits to handle overflow from multiple 8-bit inputs.
* RDY/EN protocol ensures safe handshake between IP and other modules.

# Simulation Results
<img width="1202" height="771" alt="Screenshot 2025-09-20 220904" src="https://github.com/user-attachments/assets/5e04118a-87e9-4986-8c48-30ad40e7e7d5" />
<img width="1201" height="774" alt="Screenshot 2025-09-20 221001" src="https://github.com/user-attachments/assets/ab7693df-251a-42c1-8962-b6b0378eee8e" />
<img width="1213" height="775" alt="Screenshot 2025-09-20 215033" src="https://github.com/user-attachments/assets/227957c2-fea2-4e24-abfd-63e6c9b27f85" />


