function [ Itm ] = tonemap_ward( I )
%TONEMAP_WARD Summary of this function goes here
%   Detailed explanation goes here
% Itm = WardHistAdjTMO(I.^(1/1.8), 100, 2^-16, 1);
Itm = DragoTMO(I,100,0.65);
end

