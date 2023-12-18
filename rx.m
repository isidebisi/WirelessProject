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

% downconversion

% low pass filter using the function function [after] = ofdmlowpass(before,conf,f)


% frame synchronization

% FFT using OSFFT function provided function Y = osfft(X,OS_FACTOR)


% remove cycle prefix

% phase correction
% optional


% reconstruct (reshape)
% retourner un truc qui s'appelle rx--- ?

% demapper QPSK
rxbits = demapper(rx---)

end