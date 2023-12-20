function [txsignal conf] = tx(txbits,conf,k)
% Digital Transmitter
%
%   [txsignal conf] = tx(txbits,conf,k) implements a complete transmitter
%   consisting of:
%       - modulator
%       - pulse shaping filter
%       - up converter
%   in digital domain.
%
%   txbits  : Information bits
%   conf    : Universal configuration structure
%   k       : Frame index
%

%map bits to symbols
tx_mapped = mapGray(txbits);

%distribute symbols to carriers
tx_carriers = reshape(tx_mapped, conf.nbcarriers,[]);

%inverse FFT
tx_ofdm = osifft(tx_carriers, conf.os_factor_ofdm);

%create and add cyclic prefix
tx_ofdm_cp = [tx_ofdm(end-conf.cp_length+1:end,:), tx_ofdm];
tx_ofdm_cp = tx_ofdm_cp(:);

%normalize
tx_ofdm_cp_norm = tx_ofdm_cp/max(abs(tx_ofdm_cp));

%generate training sequence
tr_shaped = repmat(conf.train_seq, conf.nbcarriers, 1);
tr_ofdm = osifft(tr_shaped, conf.os_factor_ofdm);
tr_cp = [tr_ofdm(end-conf.cp_os+1:end, :), tr_ofdm];
tr_cp = tr_cp(:);
tr_norm = tr_cp / max(abs(tr_cp));

%add training blocks to signal
txsignal = [tr_norm; tx_ofdm_cp_norm];


%generate preamble
preamble = upsample(conf.preamble, conf.os_factor_preamble);
h = rrc(conf.os_factor_preamble, conf.rolloff, conf.filterlength);
preamble_shaped = conv(h, preamble);
preamble_shaped = preamble_shaped / max(abs(preamble_shaped));


%add preamble to signal
txsignal = [preamble_shaped; txsignal];

% total time of frame to be sent
time = 0:1/conf.f_s:(size(txsignal)-1)/conf.f_s;

%up convert
txsignal = cos(2*pi*conf.f_c*time').* real(txsignal)- sin(2*pi*conf.f_c*time') .* imag(txsignal);

