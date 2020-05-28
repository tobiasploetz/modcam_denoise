function [ R_recon ] = florian( Ims, exposures, nlf, bitdepth, target_bitdepth, R_init )
%FLORIAN Summary of this function goes here
%   Detailed explanation goes here
check_nlf(nlf);
if exist('R_init', 'var')
    E_init = R_init * 2^target_bitdepth;
else
    E_init = [];
end
R_recon = double(doMultiReconstructionCor(split_array(Ims, 3), exposures, bitdepth, E_init)) * 2^(-target_bitdepth);

end

