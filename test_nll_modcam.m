nlf = struct; nlf.a=1e-2; nlf.b = 1e-4;
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
exposures = exposure_times_florian( bitdepth, target_bitdepth, nlf, p, 100)
% weights = ones(size(exposures));
weights = exposures.^2;

ne = numel(exposures);

I = im2double(rgb2gray(imread('peppers.png')));

Im = cell(1,ne);
k = cell(1,ne);

for i=1:ne
    [Im{i},k{i}] = expose_modcam(I, exposures(i), bitdepth, target_bitdepth, nlf); 
end

Ims = cat(3, Im{:});
%%
% exposure_idx = 1:3;
% exposure_idx = 3;
% exposure_idx = 1:numel(exposures);
exposure_idx = 1;

r = 350;
c = 78;
r = 356;
c = 63;
r = 22;
c = 377;
r = 270;
c = 353;
r = 319;
c = 61;
% r = 214;
% c = 230;
nll_opt = struct;
nll_opt.clipped = true;
nll_opt2 = struct;
nll_opt2.clipped = false;
f = @(x) nll_modcam_multiexposure(x , Ims(r,c,exposure_idx), exposures(exposure_idx), weights(exposure_idx), bitdepth, target_bitdepth, nlf, nll_opt );
f2 = @(x) nll_modcam_multiexposure(x , Ims(r,c,exposure_idx), exposures(exposure_idx), weights(exposure_idx), bitdepth, target_bitdepth, nlf, nll_opt2 );
clf;
hold on;
% fplot(@(x) selectOutput(@() f(x), 1), [0.2,0.22], 'b')
% fplot(@(x) selectOutput(@() f(x), 2)*0.01, [0.2,0.22], 'r')
fplot(@(x) selectOutput(@() f(x), 1), [0,1], 'b')
fplot(@(x) selectOutput(@() f(x), 2)*0.01, [0,1], 'r')
% fplot(@(x) selectOutput(@() f2(x), 1), [0,1], 'b--')
% fplot(@(x) selectOutput(@() f2(x), 2)*0.01, [0,1], 'r--')
% ylim([-1,1]*1e2)

I(r,c)
R_denoise(r,c)
RFlorian(r,c)
% Ims(r,c,:) .* 2^(-bitdepth)
% xlim([0.14,0.24]);
% ylim([0,2]*10^7);

