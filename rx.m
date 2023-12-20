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

% TODO : adjust function argument f
filtered_rx_signal = ofdmlowpass(demodulated_signal,conf,f);

%% frame synchronization

% Index of the first data symbol
data_idx = frame_sync(filtered_rx_signal, os_factor);

% get entire datastream
data_rx = filtered_rx_signal(data_idx:data_idx+msg_length(dans conf)-1)
%% remove cycle prefix
data_without_cp = data_rx(conf.cp_length + 1:end);
% nicolas reshape ici 

%% convert to frequency domain using OSFFT function provided 

freq_rx = osfft(data_without_cp,conf.os_factor) % os factor different for ofdm

%% channel estimation & phase correction
% 


% reconstruct (reshape)
% retourner un truc qui s'appelle rx--- ?

%% demapper QPSK
rxbits = demapper(rx---)

end