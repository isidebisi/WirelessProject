function [conf] = config()
%CONFIG configuration structure

% Imagesettings
conf.imageConversion = "complex"; % "easy" or "complex" for purely BW or grayscale
conf.imagePath = "smallSmile.png";
conf.threshold = 0.35;

% OFDM 
conf.nbcarriers = 512;
conf.carriersSpacing = 5; % Hz
conf.cp_length = 64;
conf.bandwidth = ceil((conf.nbcarriers + 1)/ 2)*conf.carriersSpacing;
conf.nbdatapertraining = 64;
conf.enlarge_bandwidth = 1.1*conf.bandwidth;

conf.f_s     = 48000;   % sampling rate  
conf.f_sym   = 100;     % symbol rate
% for rx filter (preamble filter)
conf.rolloff = 0.22;
conf.filterlength = 20;

conf.data_per_frame = 2; % RANDOM NUMBER?
conf.training_len = 1;
conf.train_seq = zeros(conf.training_len);
conf.nframes = 1;       % number of frames to transmit
conf.nbits   = conf.nbdatapertraining*conf.nbcarriers*2      * 5;    % number of bits
conf.modulation_order = 2; % BPSK:1, QPSK:2
conf.f_c     = 6000;

conf.npreamble  = 256;
conf.preamble = preambleGenerate(conf.npreamble);

conf.channel_estimation = 'none'; % 'none'

conf.bitsps     = 16;   % bits per audio sample
conf.offset     = 0;

conf.os_factor_ofdm  = conf.f_s/(conf.carriersSpacing*conf.nbcarriers); % help osifft
conf.os_factor_preamble = 4;

conf.data_len = conf.training_len + conf.data_per_frame;
% vérifier si paramètres sont corrects
conf.frame_without_preamble_len = conf.data_len *conf.os_factor_ofdm *(conf.nbcarriers+ conf.cp_length); % bits

if mod(conf.os_factor_preamble,1) ~= 0
   disp('WARNING: Sampling rate must be a multiple of the symbol rate'); 
end

conf.nsyms      = ceil(conf.nbits/conf.modulation_order);
end

