function [ nll, g, pc ] = nll_modcam_multiexposure( R, Ims, exposure_times, weights, bitdepth, target_bitdepth, nlf, nll_opt )
%NLLL_MODCAM Summary of this function goes here
%   Detailed explanation goes here

if iscell(Ims)
    Ims = cat(3, Ims{:});
end
ni = size(Ims,3);
Ims = reshape(Ims, [], ni);
nlls = zeros(numel(R), ni);
gs = zeros(numel(R), ni);
pcs = zeros(numel(R), ni);
for i = 1:ni
    [nlls(:,i), gs(:,i), pcs(:,i)] = nll_modcam(R(:), Ims(:,i), exposure_times(i), bitdepth, target_bitdepth, nlf, nll_opt);
end

nlls = weights.*nlls;
gs = weights.*gs;

nll = reshape(sum(nlls,2),size(R));
g = reshape(sum(gs,2),size(R));
pc = reshape(sum(pcs,2),size(R));

end

