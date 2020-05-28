function [ x ] = denoiseMRFHetscedGauss( y, x0, prior, nlf, lambda, opt, gt )
%DENOISEMRFGAUSS Summary of this function goes here
%   Detailed explanation goes here
sz = size(y);
prior.imdims = sz;
y = y(:);
x0 = x0(:);

output_fn = [];
if exist('gt', 'var')
    gt = gt(:);
    output_fn = @(xi, varargin) fprintf('PSNR: %.2f\n', psnr(gt,xi,255)) && false;
end
    
opt.outputFcn = output_fn;

[x] = minFunc(@FoEHetscedGauss_llh_and_grad, x0, opt, y,prior,nlf, lambda);

x = reshape(x,sz);

end