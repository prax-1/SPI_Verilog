# SPI Communication through VeriLog

## Project Overview
This project involves designing a Serial Peripheral Interface (SPI) communication module in Verilog. The design includes both an SPI transmitter and receiver, allowing data exchange between a master device and a slave device. The goal is to implement a configurable SPI communication system and verify its functionality through simulation using VIVADO Software.

## Understanding SPI
SPI stands for Serial Peripheral Interface.
SPI is a synchronous protocol that allows a master device to initiate communication 
with a slave device.  Data is exchanged between these devices.

 - SPI is a Synchronous protocol.
 - The clock signal is provided by the master to provide synchronization.  The clock 
    signal controls when data can change and when it is valid for reading.
 - Since SPI is synchronous, it has a clock pulse along with the data.  RS-232 and other 
  asynchronous protocols do not use a clock pulse, but the data must be timed very 
  accurately.  
 - Since SPI has a clock signal, the clock can vary without disrupting the data.  The 
data rate will simply change along with the changes in the clock rate.  This makes 
SPI ideal when the microcontroller is being clocked imprecisely, such as by a RC 
oscillator.
- SPI is a Master-Slave protocol.
- Only the master device can control the clock line, SCK.
- No data will be transferred unless the clock is manipulated.
- All slaves are controlled by the clock which is manipulated by the master device.
- The slaves may not manipulate the clock.  The SSP configuration registers will 
  control how a device will respond to the clock input
- SPI is a Data Exchange protocol.  As data is being clocked out, new data is also 
being clocked in.
- When one “transmits” data, the incoming data must be read before attempting to 
transmit again.  If the incoming data is not read, then the data will be lost and the 
- SPI module may become disabled as a result.  Always read the data after a transfer 
has taken place, even if the data has no use in your application.
- Data is always “exchanged” between devices.  No device can just be a “transmitter” 
or just a “receiver” in SPI.  However, each device has two data lines, one for input 
and one for output.  
- These data exchanges are controlled by the clock line, SCK, which is controlled by 
the master device.

Each transmission starts with a falling edge of CSB and ends with the 
rising edge. During transmission, commands and data are controlled by 
SCK and CSB according to the following rules: 
- commands and data are shifted; MSB first, LSB last 
- each output data/status bits are shifted out on the falling edge of SCK (MISO line) 
- each bit is sampled on the rising edge of SCK (MOSI line) 
- after the device is selected with the falling edge of CSB, an 8-bit command is received. The command 
defines the operations to be performed 
- the rising edge of CSB ends all data transfer and resets internal counter and command register 
- if an invalid command is received, no data is shifted into the chip and the MISO remains in high 
impedance state until the falling edge of CSB. This reinitializes the serial communication. 
- In order to perform other commands than those listed in Table 1, the lock register content must be set 
correctly. If such a command is fed without setting the correct lock register content, no data will be 
shifted into the chip and the MISO remains in high impedance state until the falling edge of CSB. 
- data transfer to MOSI continues immediately after receiving the command in all cases where data is to 
be written to ASIC’s internal registers 
- data transfer out from MISO starts with the falling edge of SCK immediately after the last bit of the SPI 
command is sampled in on the rising edge of SCK 
- maximum SPI clock frequency is 500kHz  
- maximum data transfer speed for RDAX and RDAY is 6600 samples per sec / channel 
SPI command can be either an individual command or a combination of command and data. In the case of 
combined command and data, the input data follows uninterruptedly the SPI command and the output data is 
shifted out parallel with the input data


![image](https://github.com/user-attachments/assets/a347c903-bd5e-42e7-9437-99e5b1fc7ec3)


## Project Components
  1. Top Module : This module integrates the SPI transmitter and receiver, handles the clock generation for SPI communication, and manages the state transitions for sending and receiving data.
  2. Testbench (tb): This module is used to simulate the top module, providing the necessary inputs and observing the outputs to verify the functionality of the SPI communication system.

## Top Module Description:
  ### Parameters
  - board_clk: Clock frequency of the board (100,000 Hz).
  - clk_value: Desired SPI clock frequency (10,000 Hz).
  - bits: Number of bits to be transmitted/received (configurable, default 12).
  
  ### Inputs
  - clk: Main clock input.
  - start: Signal to start the SPI communication.
  - din: Data input to be transmitted (12 bits).

  ### Output
  - mosi: Master Out Slave In signal.
  - sclk: SPI clock signal.
  - dout: Data output received from SPI communication (12 bits).

  ### Functionality
  The top module generates the SPI clock (sclk) from the main clock (clk) and manages the state transitions for transmitting and receiving data. The module ensures that data is correctly transmitted bit by     bit through the mosi signal and received through the SPI clock signal (sclk).

  ### SPI Clock Generation
  The SPI clock is generated by dividing the main clock frequency according to the desired SPI clock frequency. This is managed by a counter and a clock toggling mechanism.

  ### State Machine
  The state machine handles the following states:
- Idle: Waiting for the start signal.
- Start Transmission: Preparing for data transmission.
- Send: Transmitting data bits sequentially.
- End Transmission: Finalizing the transmission process.

  ### Data Reception
  The received data is stored in a shift register (shiftrx), and the bits are reversed using the reverse_bits module to ensure correct alignment.

  ## Reverse Bits Module Description
  Inputs da_in : Input 12 bit data to be reversed
  Outputs da_out : Output data with bits reversed

  ### Functionality
  This module iterates over the input data bits and reverses their order, ensuring that the transmitted data is correctly aligned with the received data.

  ## Testbench Description
  ### Functionality
  The testbench simulates the top module by providing clock signals, start signals, and data inputs. It observes the outputs and verifies the correct functionality of the SPI communication system.

  ### Testbench Code
  ```
  module tb_top;

    reg clk = 0;
    reg start = 1;
    wire sclk;
    reg [11:0] din = 12'hf5;
    wire [11:0] dout;
    wire mosi;

    // Instantiate the top module
    top #(.bits(12)) dut (
        .clk(clk),
        .start(start),
        .din(din),
        .mosi(mosi),
        .sclk(sclk),
        .dout(dout)
    );
```
    // Clock generation process
    always #5 clk = ~clk;

    // Initial process
    initial begin
        // Reset signals
        start = 1;
        #10;
        start = 0;
        #100;
        $display("Simulation complete");
        $finish;
    end

endmodule 
```

## Conclusion
This project demonstrates the implementation of an SPI communication system in Verilog. The top module integrates the SPI transmitter and receiver, manages clock generation, and handles state transitions for data transmission and reception. The design is configurable for different bit lengths, making it versatile for various applications.

### Further Improvements
- Parameterization: Make the bit length (bits) fully configurable throughout the code.
- Error Handling: Implement error detection and handling mechanisms.
- Enhancements: Add support for different SPI modes and configurations.



  
