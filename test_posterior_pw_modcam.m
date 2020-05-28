nlf = struct; nlf.a=1e-2; nlf.b = 1e-3;
nlf

target_bitdepth=16;
bitdepth= 10;

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
exposures = exposure_times_florian( bitdepth, target_bitdepth, nlf, p, 100)
weights = ones(size(exposures));

ne = numel(exposures);

I = im2double(rgb2gray(imread('peppers.png')));

Im = cell(1,ne);
k = cell(1,ne);

for i=1:ne
    [Im{i},k{i}] = expose_modcam(I, exposures(i), bitdepth, target_bitdepth, nlf); 
end

Ims = cat(3, Im{:});

foe = learned_models.cvpr_pw_mrf;
foe.imdims = [2,1];
%%
r = 100;
c1 = 100;
c2 = 351;
nll_opt = struct;
nll_opt.clipped = true;
nll_opt2 = struct;
nll_opt2.clipped = false;

Rvals = linspace(0,1,1001);
Rclique = zeros(numel(Rvals), numel(Rvals), 2);
[Rclique(:,:,1), Rclique(:,:,2)] = meshgrid(Rvals, Rvals);
Rclique = reshape(Rclique, [],2);
logprior = foe.experts{1}.energy((Rclique(:,1) - Rclique(:,2))'*255);
logprior = reshape(logprior, numel(Rvals), numel(Rvals));

% exposure_idx = 1:numel(exposures);
%%
exposure_idx = numel(exposures);
exposure_idx = 1:1;
% exposure_idx = [1,3];

nll1 = nll_modcam_multiexposure(Rvals , Ims(r,c1,exposure_idx), exposures(exposure_idx), weights(exposure_idx), bitdepth, target_bitdepth, nlf, nll_opt );
nll2 = nll_modcam_multiexposure(Rvals , Ims(r,c2,exposure_idx), exposures(exposure_idx), weights(exposure_idx), bitdepth, target_bitdepth, nlf, nll_opt );

figure(1)
clf;
posterior = nll1 + nll2' + logprior*1e6;
idx = 100:300;
idx = 1:numel(Rvals);
contourf(Rvals(idx), Rvals(idx), posterior(idx,idx));

figure(2)
clf;
f = @(x,c) nll_modcam_multiexposure(x , Ims(r,c,exposure_idx), exposures(exposure_idx), weights(exposure_idx), bitdepth, target_bitdepth, nlf, nll_opt );
hold on
fplot(@(x) selectOutput(@() f(x,c1), 1), [0,1], 'b')
fplot(@(x) selectOutput(@() f(x,c2), 1), [0,1], 'r')

I(r,c1)
I(r,c2)
Ims(r,c,:) .* 2^(-bitdepth)
% xlim([0.14,0.24]);
% ylim([0,2]*10^7);

