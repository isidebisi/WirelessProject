function [txbits conf] = image2bin(conf)
    % reads png image, converts to grayscale, and applies threshold
    % returns binary image

    if strcmp(conf.imageConversion,'easy')
        image = imread(conf.imagePath);
        imageGray = rgb2gray(image);
        imageBW = imbinarize(imageGray, conf.threshold);
        %txbits_char = reshape(imageBW', 1, []);
        txbits = double(imageBW(:));
        % figure
        % montage({image, imageGray, imageBW}, 'Size', [1 3]);
        % title("Image, from original to converted bin BW");
    end
    
    if strcmp(conf.imageConversion,'complex')
        image = imread(conf.imagePath);
        imageGray = rgb2gray(image);
        txbits = double(imageGray(:));
        % figure
        % montage({image, imageGray}, 'Size', [1 2]);
        % title("Image, from original to converted bin BW");
    end

    %add random bits
    if (mod(txbits,conf.nbcarriers) ~= 0)
        nb_rdm_bit = mod(txbits,conf.nbcarriers);
        txbits = [txbits randi([0 1], nb_rdm_bit, 1)]
    end
    conf.imageheight = size(image,1);
    conf.imagewidth = size(image,2);
end