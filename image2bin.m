function [txbits conf] = image2bin(conf)
    % reads png image, converts to grayscale, and applies threshold
    % returns binary image

    if strcmp(conf.imageConversion,'easy')
        image = imread(conf.imagePath);
        imageGray = rgb2gray(image);
        imageBW = imbinarize(imageGray, conf.threshold);
        txbits_char = reshape(imageBW', 1, []);
        txbits = str2double(txbits_char);
        figure
        montage({image, imageGray, imageBW}, 'Size', [1 3]);
        title("Image, from original to converted bin BW");
    end
    
    if strcmp(conf.imageConversion,'complex')
        image = imread(conf.imagePath);
        imageGray = rgb2gray(image);
        txbits_char = reshape(imageGray', 1, []);
        txbits = str2double(txbits_char);
        figure
        montage({image, imageGray}, 'Size', [1 2]);
        title("Image, from original to converted bin BW");
    end

    %add random bits
    bit_per_tram = conf.nbdatapertraining * conf.nbcarriers * 2;
    conf.nbits = bit_per_tram * (floor(length(txbits) / bit_per_tram) + 1);
    nb_rdm_bit = double(num2str(dec2bin(conf.nbits - length(txbits) - 32, 32)) - '0');

    txbits = [nb_rdm_bit, txbits(:)']; % Ensure txbits is a row vector
    txbits = [txbits(:); randi([0, 1], conf.nbits - length(txbits), 1)]; % Ensure txbits is a column vector
    txsignal = txbits;
    
end