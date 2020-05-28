function [f,g, g_llh, g_lnorm, g_lprior] = FoEHetscedGauss_llh_and_grad(x, y, prior, nlf, lambda)

sigma = sqrt(nlf.a*x+nlf.b);
% sigma = sqrt(max(1e-20,nlf.a*x+nlf.b));

llh = sum(- 0.5 * ((x-y) ./sigma).^2);
llh_norm = sum(log(sigma));
llh_prior = prior.energy(x);


f = -(llh - lambda*llh_prior - llh_norm);
% f = -(llh );

g1 = (x-y) ./ (sigma.^2);
g2 = nlf.a *0.5* (x-y).^2 ./(sigma.^4);
g_llh = (g1 - g2);
g_lnorm = 1./sigma.^2 * 0.5*nlf.a;
g_lprior = prior.log_grad_x(x);

g = (g_llh +g_lnorm - lambda*g_lprior);
% g = (g_llh  - lambda*g_lprior);
% g = (g_llh);

end