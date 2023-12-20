function [txbits conf] = image2bin(conf)
    % reads png image, converts to grayscale, and applies threshold
    % returns binary image
    image = imread(conf.imagePath);
    imageGray = rgb2gray(image);
    txbits_char = reshape(imageGray', 1, []);
    txbits = str2double(txbits_char);

    %imageBW = imbinarize(imageGray, conf.threshold);
    figure
    montage({image, imageGray}, 'Size', [1 2]);
    title("Image, from original to converted bin BW");
    
    %add random bits
    bit_per_tram = conf.nbdatapertrainning * conf.nbcarriers * 2;
    conf.nbits = bit_per_tram * (floor(length(txbits) / bit_per_tram) + 1);
    nb_rdm_bit = double(num2str(dec2bin(conf.nbits - length(txbits) - 32, 32)) - '0');
    txbits = [nb_rdm_bit, txbits];
    txbits(:);
    txbits = [txbits; randi([0, 1], conf.nbits - length(txbits), 1)];
    txsignal = txbits;
    
end