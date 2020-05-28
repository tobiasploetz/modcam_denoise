function [ R_recon ] = denoise_plus_florian( Ims, exposures, weights, nlf, bitdepth, target_bitdepth, energy_opt, optim_opt)
%FLORIAN Summary of this function goes here
%   Detailed explanation goes here

check_nlf(nlf);

period = 2^(bitdepth - target_bitdepth) / exposures(1);
R_init = Ims(:,:,1) ./ 2^bitdepth *period;

R_denoise = denoise_modcam(R_init , Ims(:,:,1), exposures(1), weights(1), bitdepth, target_bitdepth, nlf, energy_opt, optim_opt );

E_init = R_denoise * 2^target_bitdepth;
R_recon = double(doMultiReconstructionCor(split_array(Ims(:,:,2:end), 3), exposures(2:end), bitdepth, E_init)) * 2^(-target_bitdepth);


end

