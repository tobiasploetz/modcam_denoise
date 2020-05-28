
function [f,g, g_llh, g_llh_prior] = FoEGauss_llh_and_grad(x, y, prior, sigma, lambda)

llh = sum(- 0.5 * (x-y).^2 * (1/(sigma.^2)));
llh_prior = prior.energy(x);

f = -(llh - lambda*llh_prior);

g_llh = -(x-y) * (1/(sigma.^2));
g_llh_prior = prior.log_grad_x(x);

g = (g_llh - lambda*g_llh_prior);

end