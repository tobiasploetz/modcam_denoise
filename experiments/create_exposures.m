function [ Ims, ks ] = create_exposures( I, exposures, bitdepth, target_bitdepth, nlf, random_seed )
%CREATE_EXPOSURES Summary of this function goes here
%   Detailed explanation goes here

sprev = rng(random_seed);

ni = numel(exposures);
Ims = cell(ni,1);
ks = cell(ni,1);
for i=1:ni
    [Ims{i},ks{i}] = expose_modcam(I, exposures(i), bitdepth, target_bitdepth, nlf); 
end

rng(sprev);

end

