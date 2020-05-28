function [ x ] = denoiseMRFGauss( y,x0, prior, sigma, lambda, opt, gt )
%DENOISEMRFGAUSS Summary of this function goes here
%   Detailed explanation goes here
sz = size(y);
prior.imdims = sz;
y = double(y(:));
x0 = double(x0(:));
sigma = double(sigma);

output_fn = [];
if exist('gt', 'var')
    gt = gt(:);
    output_fn = @(xi, varargin) fprintf('PSNR: %.2f\n', psnr(gt,xi,255)) && false;
end
    
opt.outputFcn = output_fn;

[x,f,exitflag,output] = minFunc(@FoEGauss_llh_and_grad, x0, opt, y,prior,sigma, lambda);

x = reshape(x,sz);

end