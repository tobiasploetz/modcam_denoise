function [ I, k ] = expose_modcam( R, exposure_time, bitdepth, target_bitdepth, nlf, cont )
%EXPOSE_MODCAM Summary of this function goes here
%   Detailed explanation goes here

if ~exist('cont', 'var')
    cont = false;
end

if ~exist('nlf', 'var')
    nlf = struct;
    nlf.a = 0;
    nlf.b = 0;
end
R = min(R, 1-2^(-target_bitdepth));
R_exp = R*exposure_time;

sigma = sqrt(nlf.a * R_exp + nlf.b);
R_exp_noisy = max(0,R_exp + randn(size(R_exp)) .* sigma);

Ifull = floor(R_exp_noisy*2^target_bitdepth);
Ifull_cont = (R_exp_noisy*2^target_bitdepth);

if cont
    I = mod(Ifull_cont, 2^bitdepth);
else
    I = mod(Ifull, 2^bitdepth);
end
k = (Ifull - I) / 2^bitdepth;

end

