function [ R_recon ] = init_only( Ims, exposures, bitdepth, target_bitdepth)
%FLORIAN Summary of this function goes here
%   Detailed explanation goes here
period = 2^(bitdepth - target_bitdepth) / exposures(1);
R_init = Ims(:,:,1) ./ 2^bitdepth *period;

R_recon = R_init;


end

