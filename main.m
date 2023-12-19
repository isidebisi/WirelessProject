clear, clc, close all

config = config();

image = imread("Ludovic.png");
imshow(image);
imageBW = rgb2gray(image);
imageBW = imbinarize(imageBW, 0.35);
imshow(imageBW);