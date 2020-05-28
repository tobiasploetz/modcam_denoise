nlf = struct; nlf.a=1e-1; nlf.b = 1e-3;
% nlf = struct; nlf.a=1e-2; nlf.b = 1e-4;
% nlf = struct; nlf.a=1e-3; nlf.b = 1e-5;
% nlf = struct; nlf.a=1e-4; nlf.b = 1e-6;
nlf

target_bitdepth=16;
bitdepth= 10;
nlf.bitdepth = bitdepth;
nlf = adapt_nlf(nlf, target_bitdepth);

% exposures = [1 0.5 0.25 1 1 1 1 1 1]
% weights = [ 1 5 5 1 1 1 1 1 1];
% exposures = [1 0.5 0.25 0.4]
% weights = [ 1 1 1 1];
% exposures = [1 2^-0.5*(target_bitdepth-bitdepth)  2^-(target_bitdepth-bitdepth)]
% weights = [ 1 1 1];
% exposures = [1 2^-(target_bitdepth-bitdepth)]
% weights = [1 10];
% exposures = [2^-(target_bitdepth-bitdepth)]
% weights = [ 1];

p = 0.99;
exposures = exposure_times_florian( bitdepth, target_bitdepth, nlf, p, 100);
% exposures = sort(horzcat(exposures, exposures, exposures))
% weights = ones(size(exposures));
weights = exposures.^2;

ne = numel(exposures);

[data_fun, ndata] = hdr_data_debevec();
% [data_fun, ndata] = hdr_data_psftools();
% [data_fun, ndata] = hdr_data_cityscapes();
I = double(data_fun(3));
[h,w] = size(I);
d = 150;
w = floor(w/2)-d; h = floor(h/2)-d;
I = I(h:h+2*d-1,w:w+2*d-1);
I = (I - min(I(:))) ./ (max(I(:)) - min(I(:)));
    
% I = im2double(rgb2gray(imread('peppers.png')));
% I = I(1:10,1:10);
%%
Im = cell(1,ne);
k = cell(1,ne);

for i=1:ne
    [Im{i},k{i}] = expose_modcam(I, exposures(i), bitdepth, target_bitdepth, nlf); 
end
Inoisy = expose_intcam(I, 1, target_bitdepth, target_bitdepth, nlf) * 2^-target_bitdepth;

Ims = cat(3, Im{:});
%%
foe = learned_models.cvpr_pw_mrf;
% foe = learned_models.gcpr2012_5x5_foe;
foe.imdims = size(I);

RFlorian = double(doMultiReconstructionCor(split_array(Ims, 3), exposures, bitdepth)) * 2^(-target_bitdepth);
ROrig = double(doMultiReconstruction(split_array(Ims, 3), exposures, bitdepth)) * 2^(-target_bitdepth);
R_oracle = (k{end}*2^bitdepth + Im{end}) / 2^target_bitdepth;
energy_opt = struct;
energy_opt.clipped = false;
energy_opt.prior = foe;
energy_opt.lambda = 1.5e0*1;
% energy_opt.lambda = 1.5e1*1;
energy_opt.normalizer = 1;

optim_opt = struct;
optim_opt.minfunc_opt = struct;
optim_opt.minfunc_opt.method = 'lbfgs';
optim_opt.minfunc_opt.MaxIter = 40;
optim_opt.minfunc_opt.Display = 'on';
% optim_opt.minfunc_opt.DerivativeCheck = 'on';
optim_opt.precond = false;
optim_opt.weight_strategy = 'merge';
optim_opt.init_with_florian = true;
optim_opt.update_with_florian = false;
optim_opt.rescale_weights = false;
% optim_opt.refit_at_end = true;
% exposure_idx = 1:numel(exposures);

exposure_idx = 1:numel(exposures);
% exposure_idx = 1:3;
% exposure_idx = [1,3];

period = 2^(bitdepth - target_bitdepth) / exposures(1);
R_init = Ims(:,:,1) ./ 2^bitdepth *period;

R_denoise = denoise_modcam(R_init , Ims(:,:,exposure_idx), exposures(exposure_idx), weights(exposure_idx), bitdepth, target_bitdepth, nlf, energy_opt, optim_opt );

figure(1)
clf;
imagesc(R_denoise)

fprintf('PSNR Noisy: %.2f dB\n', psnr(Inoisy, I));
fprintf('PSNR First Exposure: %.2f dB\n', psnr(Ims(:,:,1)/2^bitdepth, I));
fprintf('PSNR Denoi: %.2f dB\n', psnr(R_denoise, I));
fprintf('PSNR Florian: %.2f dB\n',psnr(RFlorian , I));
fprintf('PSNR Zhao: %.2f dB\n',psnr(ROrig, I));
fprintf('PSNR Oracle: %.2f dB\n',psnr(R_oracle, I));