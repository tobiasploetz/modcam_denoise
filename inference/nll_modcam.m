function [ nll, g, pc ] = nll_modcam( R, Im, exposure_time, bitdepth, target_bitdepth, nlf, nll_opt )
%NLLL_MODCAM Summary of this function goes here
%   Detailed explanation goes here
check_nlf(nlf);
clipped = getOpt(nll_opt, 'clipped', false);

period = 2^(bitdepth - target_bitdepth) / exposure_time;

% c = 1;
c = 2*pi/period;
sigma = sqrt(nlf.a * R*exposure_time + nlf.b) * c + eps;
k = 1./(sigma.*sigma);

Im_to_R = Im ./ 2^bitdepth *period;

R_diff = R - Im_to_R;

idx = k>100;
normalizer = k;
normalizer(idx) = logbesseli(1,k(idx));
normalizer(~idx) = log(besseli(0,k(~idx)));
% normalizer = k + log(k);

R_diff_cos = cos(2.*pi./period .* R_diff);
if clipped
    quant = period * 2^(-bitdepth);
    quant_cos = cos(pi/period * quant);
    R_diff_cos(R_diff_cos > quant_cos) = 1.0;
end
likelihood = k .* R_diff_cos;

nll = -(likelihood-normalizer);
% nll = -(likelihood);
% nll = -(-normalizer);

dSigmaSq_dR = nlf.a.*c.^2.*exposure_time;
dK_dSigmaSq = - 1 ./ (sigma.^4);
dk_dR = dK_dSigmaSq .* dSigmaSq_dR;

dLogBessel_dK = zeros(size(k));
h = 0.01; 
dLogBessel_dK(idx) = (logbesseli(1,k(idx)+h) - logbesseli(1,k(idx)-h))/(2*h);
dLogBessel_dK(~idx) = (log(besseli(0,k(~idx)+h)) - log(besseli(0,k(~idx)-h)))/(2*h);
R_diff_sin = sin(2.*pi./period .* R_diff);
if clipped
    R_diff_sin(R_diff_cos > quant_cos) = 0.0;
end
dR_diff_cos_dR = - 2.*pi./period * R_diff_sin;

dLikelihood_dR = dk_dR.*R_diff_cos + k.*dR_diff_cos_dR;
dNormalizer_dR = dLogBessel_dK .* dk_dR; 

g = -(dLikelihood_dR - dNormalizer_dR);
pc = k;

end

