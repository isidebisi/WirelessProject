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
data_rx = filtered_rx_signal(data_idx:data_idx+msg_length); % add msg length
%% remove cycle prefix
% Number of blocks based on data length and block size
num_blocks = numel(data_rx) / conf.data_length; % add data length

% Reshape received data into a 2D matrix 
rx_array = reshape(data_rx, conf.data_length, num_blocks).'; % add data length to config

% Remove cyclic prefix from each block assuming that the cp length is known
rx_without_cp = rx_array(conf.cp_length + 1:end,:);

%% convert to frequency domain using OSFFT function provided 

freq_rx = osfft(rx_without_cp,conf.os_factor_ofdm) % os factor different for ofdm

%% channel estimation & phase correction
% TODO

%% demapper QPSK
% reconstruct frame without cp before demapping
rx_reconstructed =  reshape(freq_rx.', 1, []);

% demap bits
rxbits = demapper(rx_reconstructed);

end