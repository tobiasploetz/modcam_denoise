function [ nlf ] = adapt_nlf( nlf, target_bitdepth )
%ADAPT_NLF Summary of this function goes here
%   Detailed explanation goes here

if(isfield(nlf, 'a_orig'))
    warning('NLF has already been adapted');
    return
end

nlf.a_orig = nlf.a;
nlf.b_orig = nlf.b;

nlf.a = nlf.a * 2^(nlf.bitdepth - target_bitdepth);
nlf.b = nlf.b * 2^(2*(nlf.bitdepth - target_bitdepth));

end

