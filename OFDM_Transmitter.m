
---

## OFDM_Transmitter.m

```matlab
%% OFDM Transmitter Simulation
% Author: Your Name
% Repository: https://github.com/your-username/OFDM-Transmitter-MATLAB

% ---------------- Parameters ----------------
FFTLength = 512;              % Number of total subcarriers
CPLength = 128;               % Cyclic Prefix length
NumOccupiedSubcarriers = 300; % Active subcarriers
SubcarrierSpacing = 15e3;     % Subcarrier spacing (Hz)
PilotSpacing = 20;            % Pilot spacing
ChannelBW = 5e6;              % Channel bandwidth
ModOrder = 16;                % Modulation order (16-QAM)
CodeRate = 3/4;               % FEC code rate
NumSymbols = 100;             % Number of OFDM symbols
SNR_dB = 20;                  % SNR (dB)

% ---------------- Transmitter ----------------
% Generate random data
numDataBits = NumOccupiedSubcarriers * log2(ModOrder) * NumSymbols * CodeRate;
dataBits = randi([0 1], numDataBits, 1);

% Padding to fit modulation order
numBitsPerSymbol = log2(ModOrder);
padSize = mod(length(dataBits), numBitsPerSymbol);
if padSize ~= 0
    dataBits = [dataBits; zeros(numBitsPerSymbol - padSize, 1)];
end

% QAM modulation
dataSymbols = qammod(dataBits, ModOrder, 'InputType', 'bit', 'UnitAveragePower', true);
dataSymbols = reshape(dataSymbols, NumOccupiedSubcarriers, []);

% Allocate subcarriers
ofdmSymbols = zeros(FFTLength, NumSymbols);
ofdmSymbols(1:NumOccupiedSubcarriers, :) = dataSymbols;

% Insert pilots
pilotIndices = 1:PilotSpacing:NumOccupiedSubcarriers;
numPilots = length(pilotIndices);
ofdmSymbols(pilotIndices, :) = 1;  % pilot = constant 1 (BPSK)

% IFFT
ifftOutput = ifft(ofdmSymbols, FFTLength);

% Add cyclic prefix
cyclicPrefix = ifftOutput(end - CPLength + 1:end, :);
ofdmTxSignal = [cyclicPrefix; ifftOutput];

% ---------------- Channel ----------------
noisySignal = awgn(ofdmTxSignal, SNR_dB, 'measured');

% ---------------- Receiver ----------------
% Remove CP
rxNoCP = noisySignal(CPLength+1:end, :);

% FFT
receivedFFT = fft(rxNoCP, FFTLength);

% Extract data
rxDataSymbols = receivedFFT(1:NumOccupiedSubcarriers, :);

% QAM demodulation
rxBits = qamdemod(rxDataSymbols(:), ModOrder, 'OutputType', 'bit', 'UnitAveragePower', true);
rxBits = rxBits(1:length(dataBits)); % trim padding

% BER
ber = sum(dataBits ~= rxBits) / length(dataBits);

% Actual SNR
signalPower = mean(abs(ofdmTxSignal(:)).^2);
noisePower = mean(abs(noisySignal(:) - ofdmTxSignal(:)).^2);
actualSNR = 10 * log10(signalPower / noisePower);

% ---------------- Plots ----------------
figure;
plot(real(ofdmTxSignal(:,1)));
title('OFDM Transmitted Signal (Time Domain)');
xlabel('Sample Index'); ylabel('Amplitude'); grid on;

figure;
scatterplot(dataSymbols(:));
title('16-QAM Constellation'); grid on;

figure;
allocationPattern = zeros(FFTLength, 1);
allocationPattern(1:NumOccupiedSubcarriers) = abs(dataSymbols(:,1)).^2;
stem(1:FFTLength, 10*log10(allocationPattern+1e-16));
title('Subcarrier Allocation'); xlabel('Subcarrier Index'); ylabel('Power (dB)'); grid on;

figure;
plot(20*log10(abs(fftshift(fft(ofdmTxSignal(:,1), FFTLength)))));
title('OFDM Spectrum'); xlabel('Subcarrier Index'); ylabel('Magnitude (dB)'); grid on;

% ---------------- Results ----------------
disp('OFDM Transmitter Simulation Results');
disp(['FFT Length = ', num2str(FFTLength)]);
disp(['Cyclic Prefix Length = ', num2str(CPLength)]);
disp(['Occupied Subcarriers = ', num2str(NumOccupiedSubcarriers)]);
disp(['Subcarrier Spacing = ', num2str(SubcarrierSpacing), ' Hz']);
disp(['Pilot Subcarrier Spacing = ', num2str(PilotSpacing)]);
disp(['Channel Bandwidth = ', num2str(ChannelBW/1e6), ' MHz']);
disp(['Modulation = 16-QAM']);
disp(['Code Rate = ', num2str(CodeRate)]);
disp(['Specified SNR = ', num2str(SNR_dB), ' dB']);
disp(['Actual SNR = ', num2str(actualSNR), ' dB']);
disp(['Bit Error Rate (BER) = ', num2str(ber)]);

