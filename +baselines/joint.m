function [ R_recon ] = joint( Ims, exposures, weights, nlf, bitdepth, target_bitdepth, energy_opt, optim_opt)
%FLORIAN Summary of this function goes here
%   Detailed explanation goes here
check_nlf(nlf);
period = 2^(bitdepth - target_bitdepth) / exposures(1);
R_init = Ims(:,:,1) ./ 2^bitdepth *period;

R_recon = denoise_modcam(R_init , Ims, exposures, weights, bitdepth, target_bitdepth, nlf, energy_opt, optim_opt );


end

