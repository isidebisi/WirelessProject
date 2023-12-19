function [imageBW] = image2bin(config)
    % reads png image, converts to grayscale, and applies threshold
    % returns binary image
    image = imread(config.imagePath);
    imageGray = rgb2gray(image);
    imageBW = imbinarize(imageGray, config.threshold);
    figure
    montage({image, imageGray, imageBW}, 'Size', [1 3]);
    title("Image, from original to converted bin BW");

    
end