function [ lam] = getlambda( bitdepth, nlf, model )
%GETLAMBDA Summary of this function goes here
%   Detailed explanation goes here

if ~exist('model', 'var')
    model = 'pw';
end

if strcmp(model, 'pw')
    lam = 0.5e1;
elseif strcmp(model, '5x5')
    lam = 1.5e1;
end
lam = 10;
