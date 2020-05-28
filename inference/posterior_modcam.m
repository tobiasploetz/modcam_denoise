function [ f,g, pc  ] = posterior_modcam( R, Ims, exposures, weights, bitdepth, target_bitdepth, nlf, energy_opt )
%POSTERIOR_MODCAM Summary of this function goes here
%   Detailed explanation goes here
 check_nlf(nlf);
lambda = energy_opt.lambda;
normalizer = getOpt(energy_opt, 'normalizer', 1);

[likelihood, g_likelihood, pc] = nll_modcam_multiexposure(R , Ims, exposures, weights, bitdepth, target_bitdepth, nlf, energy_opt );
try
    prior = energy_opt.prior.energy(R(:));
    g_prior = -energy_opt.prior.log_grad_x(R(:));
    g_prior = reshape(g_prior, size(R));
catch
    prior=0; g_prior=0;
end

n = numel(R);
f = (sum(likelihood(:)) + lambda*sum(prior(:)))/(normalizer*n);
g = (g_likelihood + lambda*g_prior)/(normalizer*n);

end

