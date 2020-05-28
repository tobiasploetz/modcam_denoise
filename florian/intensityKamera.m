function [ intensityImage,x ] = intensityKamera(HDRImage, resultingBit, containedBit)
%INTENSITYKAMERA 
% Clips the values in HDRImage according to resultingBit.

x=0;%to hold signature equal to modulo
maxsize=2^(resultingBit)-1;
intensityImage=HDRImage;
intensityImage(intensityImage>maxsize)=maxsize;

end

