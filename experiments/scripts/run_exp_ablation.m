% nlf = struct; nlf.a=1e-1; nlf.b = 1e-3;
% dataset = 'cityscapes';
% bitdepth = 10;
% target_bitdepth = 16;

nlf = struct; nlf.a=1e-2; nlf.b = 1e-4;
dataset = 'debevec';
bitdepth = 10;
target_bitdepth = 16;

expdir = getResultDir(sprintf('reconstruction_ablation_%s_%d_to_%d_bit_%0.2e_%0.2e', dataset, bitdepth, target_bitdepth, nlf.a, nlf.b));

exp_opt = struct;
exp_opt.crop = true;
% exp_opt.rescale_crop = ~strcmp(dataset, 'cityscapes');
exp_opt.rescale_crop = false;

if strcmp(dataset, 'cityscapes')
    exp_opt.tmo = @(x) mapTone(x * 2^16);
else
    exp_opt.tmo = @tonemap_ward;
end

nlf.bitdepth = bitdepth;
nlf = adapt_nlf(nlf, target_bitdepth);
p = 0.99;
exposures = exposure_times_florian( bitdepth, target_bitdepth, nlf, p, 100);
exposures

%% Just R init
data_opt = struct;
data_idx = [];
[data_fun, ndata] = get_hdr_data(dataset,data_opt,data_idx);
ndata
data_opt

recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.init_only(Ims, exposures, bitdepth, target_bitdepth);
[ R_recon, data ] = exp_hdr_reconstruction( recon, exposures, nlf, bitdepth, target_bitdepth, data_fun, ndata, exp_opt );
save(fullfile(expdir, sprintf('results_r_init.mat')), 'R_recon', 'exposures', 'nlf', 'bitdepth', 'data_idx', 'target_bitdepth', 'data', 'exp_opt', '-v7.3');

%% Florian
data_opt = struct;
data_idx = [];
[data_fun, ndata] = get_hdr_data(dataset,data_opt,data_idx);
ndata
data_opt

recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.florian(Ims, exposures, nlf, bitdepth, target_bitdepth);
[ R_recon, data ] = exp_hdr_reconstruction( recon, exposures, nlf, bitdepth, target_bitdepth, data_fun, ndata, exp_opt );
save(fullfile(expdir, sprintf('results_florian.mat')), 'R_recon', 'exposures', 'weights', 'nlf', 'bitdepth', 'data_idx', 'target_bitdepth', 'data', 'energy_opt', 'exp_opt', 'optim_opt', '-v7.3');

%% Single pass
% weights = ones(size(exposures));
weights = exposures.^2;

foe = learned_models.cvpr_pw_mrf;

energy_opt = struct;
% energy_opt.clipped = true;
energy_opt.clipped = false;
energy_opt.prior = foe;
energy_opt.lambda = getlambda(bitdepth, nlf);
energy_opt.normalizer = 1;
energy_opt

optim_opt = struct;
optim_opt.minfunc_opt = struct;
optim_opt.minfunc_opt.method = 'lbfgs';
optim_opt.minfunc_opt.MaxIter = 40;
optim_opt.weight_strategy = 'all';
optim_opt.init_with_florian = true;
optim_opt.rescale_weights = false;
optim_opt

data_opt = struct;
data_idx = [];
[data_fun, ndata] = get_hdr_data(dataset,data_opt,data_idx);
ndata
data_opt

recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.joint(Ims, exposures, weights, nlf, bitdepth, target_bitdepth, energy_opt, optim_opt);
[ R_recon, data ] = exp_hdr_reconstruction( recon, exposures, nlf, bitdepth, target_bitdepth, data_fun, ndata, exp_opt );
save(fullfile(expdir, sprintf('results_single_pass.mat')), 'R_recon', 'exposures', 'weights', 'nlf', 'bitdepth', 'data_idx', 'target_bitdepth', 'data', 'energy_opt', 'exp_opt', 'optim_opt', '-v7.3');

%% Florian + Denoise
% weights = ones(size(exposures));
weights = exposures.^2;

foe = learned_models.cvpr_pw_mrf;

energy_opt = struct;
% energy_opt.clipped = true;
energy_opt.clipped = false;
energy_opt.prior = foe;
energy_opt.lambda = getlambda(bitdepth, nlf);
energy_opt.normalizer = 1;
energy_opt

optim_opt = struct;
optim_opt.minfunc_opt = struct;
optim_opt.minfunc_opt.method = 'lbfgs';
optim_opt.minfunc_opt.MaxIter = 40;
optim_opt.weight_strategy = 'all';
optim_opt.init_with_florian = true;
optim_opt.rescale_weights = false;
optim_opt

data_opt = struct;
data_idx = [];
[data_fun, ndata] = get_hdr_data(dataset,data_opt,data_idx);
ndata
data_opt

recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.florian_plus_denoise(Ims, exposures, weights, nlf, bitdepth, target_bitdepth, energy_opt, optim_opt);
[ R_recon, data ] = exp_hdr_reconstruction( recon, exposures, nlf, bitdepth, target_bitdepth, data_fun, ndata, exp_opt );
save(fullfile(expdir, sprintf('results_florian_plus_denoise.mat')), 'R_recon', 'exposures', 'weights', 'nlf', 'bitdepth', 'data_idx', 'target_bitdepth', 'data', 'energy_opt', 'exp_opt', 'optim_opt', '-v7.3');

%% Full
% weights = ones(size(exposures));
weights = exposures.^2;

foe = learned_models.cvpr_pw_mrf;

energy_opt = struct;
% energy_opt.clipped = true;
energy_opt.clipped = false;
energy_opt.prior = foe;
energy_opt.lambda = getlambda(bitdepth, nlf);
energy_opt.normalizer = 1;
energy_opt

optim_opt = struct;
optim_opt.minfunc_opt = struct;
optim_opt.minfunc_opt.method = 'lbfgs';
optim_opt.minfunc_opt.MaxIter = 40;
optim_opt.weight_strategy = 'merge';
optim_opt.init_with_florian = true;
optim_opt.rescale_weights = false;
optim_opt

data_opt = struct;
data_idx = [];
[data_fun, ndata] = get_hdr_data(dataset,data_opt,data_idx);
ndata
data_opt

recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.joint(Ims, exposures, weights, nlf, bitdepth, target_bitdepth, energy_opt, optim_opt);
[ R_recon, data ] = exp_hdr_reconstruction( recon, exposures, nlf, bitdepth, target_bitdepth, data_fun, ndata, exp_opt );
save(fullfile(expdir, sprintf('results_full.mat')), 'R_recon', 'exposures', 'weights', 'nlf', 'bitdepth', 'data_idx', 'target_bitdepth', 'data', 'energy_opt', 'exp_opt', 'optim_opt', '-v7.3');

%% Full with 5x5 prior
% weights = ones(size(exposures));
weights = exposures.^2;

foe = learned_models.gcpr2012_5x5_foe;

energy_opt = struct;
% energy_opt.clipped = true;
energy_opt.clipped = false;
energy_opt.prior = foe;
energy_opt.lambda = getlambda(bitdepth, nlf, '5x5');
energy_opt.normalizer = 1;
energy_opt

optim_opt = struct;
optim_opt.minfunc_opt = struct;
optim_opt.minfunc_opt.method = 'lbfgs';
optim_opt.minfunc_opt.MaxIter = 40;
optim_opt.weight_strategy = 'merge';
optim_opt.init_with_florian = true;
optim_opt.rescale_weights = false;
optim_opt

data_opt = struct;
data_idx = [];
[data_fun, ndata] = get_hdr_data(dataset,data_opt,data_idx);
ndata
data_opt

% recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.joint(Ims, exposures, weights, nlf, bitdepth, target_bitdepth, energy_opt, optim_opt);
% [ R_recon, data ] = exp_hdr_reconstruction( recon, exposures, nlf, bitdepth, target_bitdepth, data_fun, ndata, exp_opt );
% save(fullfile(expdir, sprintf('results_full_5x5foe.mat')), 'R_recon', 'exposures', 'weights', 'nlf', 'bitdepth', 'data_idx', 'target_bitdepth', 'data', 'energy_opt', 'exp_opt', 'optim_opt', '-v7.3');

%% No prior
% weights = ones(size(exposures));
weights = exposures.^2;

foe = learned_models.cvpr_pw_mrf;

energy_opt = struct;
% energy_opt.clipped = true;
energy_opt.clipped = false;
energy_opt.prior = foe;
energy_opt.lambda = 0;
energy_opt.normalizer = 1;
energy_opt

optim_opt = struct;
optim_opt.minfunc_opt = struct;
optim_opt.minfunc_opt.method = 'lbfgs';
optim_opt.minfunc_opt.MaxIter = 40;
optim_opt.weight_strategy = 'merge';
optim_opt.init_with_florian = true;
optim_opt.rescale_weights = false;
optim_opt

data_opt = struct;
data_idx = [];
[data_fun, ndata] = get_hdr_data(dataset,data_opt,data_idx);
ndata
data_opt

recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.joint(Ims, exposures, weights, nlf, bitdepth, target_bitdepth, energy_opt, optim_opt);
[ R_recon, data ] = exp_hdr_reconstruction( recon, exposures, nlf, bitdepth, target_bitdepth, data_fun, ndata, exp_opt );
save(fullfile(expdir, sprintf('results_no_prior.mat')), 'R_recon', 'exposures', 'weights', 'nlf', 'bitdepth', 'data_idx', 'target_bitdepth', 'data', 'energy_opt', 'exp_opt', 'optim_opt', '-v7.3');

%% Uniform weights
weights = ones(size(exposures));
% weights = exposures.^2;

foe = learned_models.cvpr_pw_mrf;

energy_opt = struct;
% energy_opt.clipped = true;
energy_opt.clipped = false;
energy_opt.prior = foe;
energy_opt.lambda = getlambda(bitdepth, nlf);
energy_opt.normalizer = 1;
energy_opt

optim_opt = struct;
optim_opt.minfunc_opt = struct;
optim_opt.minfunc_opt.method = 'lbfgs';
optim_opt.minfunc_opt.MaxIter = 40;
optim_opt.weight_strategy = 'merge';
optim_opt.init_with_florian = true;
optim_opt.rescale_weights = false;
optim_opt

data_opt = struct;
data_idx = [];
[data_fun, ndata] = get_hdr_data(dataset,data_opt,data_idx);
ndata
data_opt

recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.joint(Ims, exposures, weights, nlf, bitdepth, target_bitdepth, energy_opt, optim_opt);
[ R_recon, data ] = exp_hdr_reconstruction( recon, exposures, nlf, bitdepth, target_bitdepth, data_fun, ndata, exp_opt );
save(fullfile(expdir, sprintf('results_uniform_weights.mat')), 'R_recon', 'exposures', 'weights', 'nlf', 'bitdepth', 'data_idx', 'target_bitdepth', 'data', 'energy_opt', 'exp_opt', 'optim_opt', '-v7.3');

%% With quantization
% weights = ones(size(exposures));
weights = exposures.^2;

foe = learned_models.cvpr_pw_mrf;

energy_opt = struct;
energy_opt.clipped = true;
% energy_opt.clipped = false;
energy_opt.prior = foe;
energy_opt.lambda = getlambda(bitdepth, nlf);
energy_opt.normalizer = 1;
energy_opt

optim_opt = struct;
optim_opt.minfunc_opt = struct;
optim_opt.minfunc_opt.method = 'lbfgs';
optim_opt.minfunc_opt.MaxIter = 40;
optim_opt.weight_strategy = 'merge';
optim_opt.init_with_florian = true;
optim_opt.rescale_weights = false;
optim_opt

data_opt = struct;
data_idx = [];
[data_fun, ndata] = get_hdr_data(dataset,data_opt,data_idx);
ndata
data_opt

% recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.joint(Ims, exposures, weights, nlf, bitdepth, target_bitdepth, energy_opt, optim_opt);
% [ R_recon, data ] = exp_hdr_reconstruction( recon, exposures, nlf, bitdepth, target_bitdepth, data_fun, ndata, exp_opt );
% save(fullfile(expdir, sprintf('results_with_quant.mat')), 'R_recon', 'exposures', 'weights', 'nlf', 'bitdepth', 'data_idx', 'target_bitdepth', 'data', 'energy_opt', 'exp_opt', 'optim_opt', '-v7.3');


%% Single pass
% weights = ones(size(exposures));
weights = exposures.^2;

foe = learned_models.cvpr_pw_mrf;

energy_opt = struct;
% energy_opt.clipped = true;
energy_opt.clipped = false;
energy_opt.prior = foe;
energy_opt.lambda = getlambda(bitdepth, nlf);
energy_opt.normalizer = 1;
energy_opt

optim_opt = struct;
optim_opt.minfunc_opt = struct;
optim_opt.minfunc_opt.method = 'lbfgs';
optim_opt.minfunc_opt.MaxIter = 40;
optim_opt.weight_strategy = 'all';
optim_opt.init_with_florian = false;
optim_opt.rescale_weights = false;
optim_opt

data_opt = struct;
data_idx = [];
[data_fun, ndata] = get_hdr_data(dataset,data_opt,data_idx);
ndata
data_opt

recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.joint(Ims, exposures, weights, nlf, bitdepth, target_bitdepth, energy_opt, optim_opt);
[ R_recon, data ] = exp_hdr_reconstruction( recon, exposures, nlf, bitdepth, target_bitdepth, data_fun, ndata, exp_opt );
save(fullfile(expdir, sprintf('results_single_pass.mat')), 'R_recon', 'exposures', 'weights', 'nlf', 'bitdepth', 'data_idx', 'target_bitdepth', 'data', 'energy_opt', 'exp_opt', 'optim_opt', '-v7.3');

%% Florian + Denoise
% weights = ones(size(exposures));
weights = exposures.^2;

foe = learned_models.cvpr_pw_mrf;

energy_opt = struct;
% energy_opt.clipped = true;
energy_opt.clipped = false;
energy_opt.prior = foe;
energy_opt.lambda = getlambda(bitdepth, nlf);
energy_opt.normalizer = 1;
energy_opt

optim_opt = struct;
optim_opt.minfunc_opt = struct;
optim_opt.minfunc_opt.method = 'lbfgs';
optim_opt.minfunc_opt.MaxIter = 40;
optim_opt.weight_strategy = 'all';
optim_opt.init_with_florian = true;
optim_opt.rescale_weights = false;
optim_opt

data_opt = struct;
data_idx = [];
[data_fun, ndata] = get_hdr_data(dataset,data_opt,data_idx);
ndata
data_opt

recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.florian_plus_denoise(Ims, exposures, weights, nlf, bitdepth, target_bitdepth, energy_opt, optim_opt);
[ R_recon, data ] = exp_hdr_reconstruction( recon, exposures, nlf, bitdepth, target_bitdepth, data_fun, ndata, exp_opt );
save(fullfile(expdir, sprintf('results_florian_plus_denoise.mat')), 'R_recon', 'exposures', 'weights', 'nlf', 'bitdepth', 'data_idx', 'target_bitdepth', 'data', 'energy_opt', 'exp_opt', 'optim_opt', '-v7.3');

%% Florian
data_opt = struct;
data_idx = [];
[data_fun, ndata] = get_hdr_data(dataset,data_opt,data_idx);
ndata
data_opt

recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.florian(Ims, exposures, weights, nlf, bitdepth, target_bitdepth);
[ R_recon, data ] = exp_hdr_reconstruction( recon, exposures, nlf, bitdepth, target_bitdepth, data_fun, ndata, exp_opt );
save(fullfile(expdir, sprintf('results_florian.mat')), 'R_recon', 'exposures', 'weights', 'nlf', 'bitdepth', 'data_idx', 'target_bitdepth', 'data', 'energy_opt', 'exp_opt', 'optim_opt', '-v7.3');
