function [ I ] = expose_intcam( R, exposure_time, bitdepth, target_bitdepth, nlf )
%EXPOSE_MODCAM Summary of this function goes here
%   Detailed explanation goes here

R = min(R, 1-2^(-target_bitdepth));
R_exp = R*exposure_time;

sigma = sqrt(nlf.a * R_exp + nlf.b);
R_exp_noisy = max(0,R_exp + randn(size(R_exp)) .* sigma);

I = min(floor(R_exp_noisy*2^target_bitdepth), 2^bitdepth-1);

end

