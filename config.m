function [conf] = config()
%CONFIG configuration structure
%% TODO : change so it is not copy pasted

% Imagesettings
conf.imagePath = "Ludovic.png";
conf.threshold = 0.35;

% OFDM 
conf.nbcarriers = 512;
conf.carriersSpacing = 2; % Hz
conf.cp_length = 128;
conf.bandwidth = ceil((conf.nbcarriers + 1)/ 2)*conf.carriersSpacing;
conf.nbdatapertrainning = 64;

conf.f_s     = 48000;   % sampling rate  
conf.f_sym   = 100;     % symbol rate
% for rx filter (preamble filter)
conf.rolloff = 0.22;
conf.filterlength = 20;

conf.nframes = 1;       % number of frames to transmit
conf.nbits   = conf.nbdatapertrainning*conf.nbcarriers*2      * 5;    % number of bits
conf.modulation_order = 2; % BPSK:1, QPSK:2
conf.f_c     = 6000;

conf.npreamble  = 256;
conf.bitsps     = 16;   % bits per audio sample
conf.offset     = 0;

conf.os_factor  = conf.f_s/conf.f_sym;
if mod(conf.os_factor,1) ~= 0
   disp('WARNING: Sampling rate must be a multiple of the symbol rate'); 
end

conf.nsyms      = ceil(conf.nbits/conf.modulation_order);
end

