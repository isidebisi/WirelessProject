function [rxbits conf] = rx(rxsignal,conf,k)
% Digital Receiver
%
%   [txsignal conf] = tx(txbits,conf,k) implements a complete causal
%   receiver in digital domain.
%
%   rxsignal    : received signal
%   conf        : configuration structure
%   k           : frame index
%
%   Outputs
%
%   rxbits      : received bits
%   conf        : configuration structure
%

%% demodulate
demodulated_signal = demodulated(rxsignal, conf);

%% low pass filter
filtered_rx_signal = ofdmlowpass(demodulated_signal,conf,conf.enlarge_bandwidth);

%% frame synchronization

% Index of the first data symbol
data_idx = frame_sync(filtered_rx_signal, conf.os_factor_preamble); % maybe change frame_sync / fun arg

% get datastream without preamble
data_rx = filtered_rx_signal(data_idx:data_idx+frame_without_preamble_len);
%% remove cycle prefix
% Number of blocks based on data length and block size
num_blocks = numel(data_rx) / conf.data_len;

% Reshape received data into a 2D matrix 
rx_array = reshape(data_rx, conf.data_len, num_blocks);

% Remove cyclic prefix from each block
rx_without_cp = rx_array(conf.cp_length*conf.os_factor_ofdm + 1:end,:);

%% convert to frequency domain using OSFFT function provided 

freq_rx = osfft(rx_without_cp,conf.os_factor_ofdm);

%% channel estimation & phase correction
% TODO
rx_corr = phase_estimation(freq_rx);

% Define colors for plotting
colors = ["#ff0000", "#ff1c00", "#ff3900", "#ff5500", "#ff7100", "#ff8e00", ...
          "#ffaa00", "#ffc600", "#ffe300", "#ffff00"];
colors = [colors, colors(end:-1:1)];

% Create a figure for visualization
figure()
axis square
hold on
xline(0, "blue", "LineWidth", 2)
yline(0, "blue", "LineWidth", 2)
%% demapper QPSK
% reconstruct frame without cp before demapping
rx_reconstructed =  reshape(rx_corr.', 1, []);

% demap bits
rxbits = demapper(rx_reconstructed);

end