# OFDM Transmitter Simulation in MATLAB

This project simulates an **Orthogonal Frequency Division Multiplexing (OFDM)** transmitter using **16-QAM modulation** and evaluates its performance over an **AWGN channel**.

---

## ⚙️ Simulation Parameters

| Parameter                 | Value     | Description                                                                 |
|---------------------------|-----------|-----------------------------------------------------------------------------|
| `FFTLength`               | 512       | Total number of subcarriers in the OFDM system (FFT size).                  |
| `CPLength`                | 128       | Length of the cyclic prefix (to mitigate ISI).                              |
| `NumOccupiedSubcarriers`  | 300       | Number of active subcarriers used for data transmission.                    |
| `SubcarrierSpacing`       | 15 kHz    | Frequency spacing between adjacent subcarriers.                             |
| `PilotSpacing`            | 20        | Interval between pilot subcarriers used for channel estimation.             |
| `ChannelBW`               | 5 MHz     | Overall channel bandwidth.                                                  |
| `ModOrder`                | 16        | QAM modulation order (16-QAM).                                              |
| `CodeRate`                | 3/4       | Forward error correction (useful bits / total transmitted bits).            |
| `NumSymbols`              | 100       | Number of OFDM symbols simulated.                                           |
| `SNR_dB`                  | 20 dB     | Signal-to-noise ratio in dB (AWGN channel).                                 |

---

## Features

- Random data bit generation.  
- 16-QAM symbol mapping.  
- Subcarrier allocation with pilots.  
- IFFT modulation and cyclic prefix insertion.  
- Transmission over AWGN channel.  
- Receiver with FFT, CP removal, and demodulation.  
- BER calculation and actual SNR measurement.  
- Visualization of:
  - OFDM time-domain signal
  - 16-QAM constellation
  - Subcarrier allocation
  - OFDM spectrum

---

## Example Results

- **Bit Error Rate (BER)** depends on SNR and modulation order.  
- **Constellation diagrams** show how noise distorts received QAM symbols.  
- **Spectrum plots** illustrate subcarrier allocation in frequency domain.

---

## How to Run

1. Clone this repository:

   ```bash
   git clone https://github.com/your-username/OFDM-Transmitter-MATLAB.git
   cd OFDM-Transmitter-MATLAB
