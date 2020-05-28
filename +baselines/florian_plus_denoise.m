function [ R_recon ] = florian_plus_denoise( Ims, exposures, weights, nlf, bitdepth, target_bitdepth, energy_opt, optim_opt)
%FLORIAN Summary of this function goes here
%   Detailed explanation goes here
check_nlf(nlf);
R_init = baselines.florian( Ims, exposures, nlf, bitdepth, target_bitdepth);

optim_opt.weight_strategy = 'all';

R_recon = denoise_modcam(R_init , Ims, exposures, weights, bitdepth, target_bitdepth, nlf, energy_opt, optim_opt );


end

