# UART Transmitter in VHDL

## Introduction

This repository contains the VHDL code for a Universal Asynchronous Receiver/Transmitter (UART) transmitter required for the Electronics and Communication Systems exam (LM-Computer Engineering at Università di Pisa). UART is a simple, low-speed protocol commonly used for serial communication between devices.

## Features

- **Baud Rate**: The UART transmitter supports a configurable baud rate, generic mapped at 115200.
- **Data Bits**: It supports N data bits, but generic mapped at 7.
- **Parity**: Even parity bit.
- **Start/Stop Bits**: Two start/stop bit are implemented.

## VHDL Files

The VHDL files included in this repository are:

1. `uart.vhd`: This is the main VHDL file that contains the UART transmitter logic.
2. `shiftv2.vhd`: This is the core of the UART functionalities.


## Simulation

You can simulate this UART transmitter using any VHDL simulator. Testbenches (`uart_tb[1,2,3].vhd`) are provided for this purpose.

## Synthesis/Implementation

All the data analyzed in this repository are gathered from Vivado software.

## Max Clock Frequency

V2: 356,633 MHz

## Conclusion

This UART transmitter is a simple and efficient solution for serial communication in your FPGA or ASIC designs.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.
