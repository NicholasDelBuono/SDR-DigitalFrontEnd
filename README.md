# SDR-DigitalFrontEnd

This repository describes a Digital Front-End (DFE) hardware component for a Software Defined Radio (SDR) in VHDL, a hardware description language.

This project bridges the gap between raw, high-speed digitized RF signals and baseband signal processing, designed to be synthesized onto FPGA fabric for real-time communication systems applications.

<!--

## Logic Scheme

a logic scheme drawing

My work resides exclusively in the right box of the schematic (the digital domain). The analog RF front-end —comprising the Antenna, Low Noise Amplifier (LNA), Analog Mixer, and IF Filter — is intentionally excluded. This is due to standard HDL limitations regarding continuous-time physical phenomena and discrete analog components such as inductors, capacitors, and transistors operating in linear regions. The Analog-to-Digital Converter (ADC) serves as the strict physical boundary for this VHDL implementation.

## Components

Going specific, this repository implements the digital down-conversion and data-packing pipeline. You can find the individual modules in the `src/` directory:

*   **`DDFS_N.vhd` (Direct Digital Synthesizer / NCO):** A parameterized phase accumulator and ROM lookup table that generates the local digital sine and cosine waves at the Intermediate Frequency (IF).
*   **`ComplexMixer.vhd`:** Structural DSP multipliers that mix the incoming ADC data stream with the NCO outputs to separate the signal into In-Phase (I) and Quadrature (Q) baseband components.
*   **`DecimationFilter.vhd`:** (Planned) Cascaded Integrator-Comb (CIC) and Finite Impulse Response (FIR) filters to low-pass filter the baseband signals and downsample the high ADC clock rate to a manageable USB transfer rate.
*   **`FIFO.vhd`:** A fully generic, structurally generated asynchronous shift-register buffer (using a custom 2D array and `for...generate` loops) to safely pack and bridge data between the continuous DSP pipeline and burst-based PC interfaces.

## Testing

Testing is performed via structural ModelSim testbenches located in the `tb/` directory. 

Because we cannot synthesize the physical ADC, the testbenches act as a "Fake ADC." They inject pre-calculated arrays or read raw binary files representing the un-demodulated ADC output. You can run the testbenches to view the resulting waveforms, proving that the phase accumulation, complex mixing, and FIFO propagation maintain exact cycle-accurate timing and data sequence preservation.

## How to Use

1.  Clone this repository and open the project in your preferred HDL simulator (e.g., ModelSim, Questa) or synthesis tool (e.g., Vivado, Quartus).
2.  Compile the source files in the `src/` directory, ensuring you use VHDL-2008 standard (or VHDL-93 with appropriate signal mapping).
3.  Instantiate the top-level DFE entity in your design, configuring the generics (e.g., `Nbit`, `Mnum` for the FIFO depth, `PHASE_BITS` for the NCO).
4.  Map your physical FPGA pins (or simulated ADC input arrays) to the `adc_data_in` port.

-->
## State

As of today, this project is **under development**. 
*   [ ] Generic Counters and Comparators
*   [ ] Parameterized FIFO Buffer
*   [ ] NCO / Phase Accumulator
*   [ ] I/Q Complex Mixer
*   [ ] CIC / FIR Decimation Filters
*   [ ] Top-Level Pipeline Integration
