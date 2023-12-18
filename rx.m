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
demodulated_signal = demodulated(rxsignal, conf)

%% low pass filter

% TODO : adjust function argument f
filtered_rx_signal = ofdmlowpass(demodulated_signal,conf,f)

%% frame synchronization

% Index of the first data symbol
data_idx = frame_sync(filtered_rx_signal, os_factor);

%% FFT using OSFFT function provided function Y = osfft(X,OS_FACTOR)


% remove cycle prefix


% phase correction
% optional


% reconstruct (reshape)
% retourner un truc qui s'appelle rx--- ?

% demapper QPSK
rxbits = demapper(rx---)

end