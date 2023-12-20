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
demodulated_signal = demodulate(rxsignal, conf);

%% low pass filter
filtered_rx_signal = ofdmlowpass(demodulated_signal,conf,conf.enlarge_bandwidth);

%% frame synchronization

% Index of the first data symbol
data_idx = frame_sync(filtered_rx_signal, conf.os_factor_preamble);

% get datastream without preamble
data_rx = filtered_rx_signal(data_idx:data_idx+conf.frame_without_preamble_len-1);
size(data_rx)
%% remove cycle prefix
% Number of blocks based on data length and block size
num_blocks = numel(data_rx) / conf.data_len;

% Reshape received data into a 2D matrix 
rx_array = reshape(data_rx, num_blocks, conf.data_len);

% Remove cyclic prefix from each block
rx_without_cp = rx_array(conf.cp_length*conf.os_factor_ofdm + 1:end,:);

%% convert to frequency domain using the provided OSFFT function 

freq_rx = osfft(rx_without_cp,conf.os_factor_ofdm);

%% channel estimation & phase correction
% TODO
rx_corr = phase_estimation(freq_rx, conf);

%% demapper QPSK
% reconstruct frame without cp before demapping
rx_reconstructed =  reshape(rx_corr,[], 1);

% demap bits
rxbits = demapper(rx_reconstructed);

end