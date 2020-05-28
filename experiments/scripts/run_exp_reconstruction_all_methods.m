function run_exp_reconstruction_all_methods( dataset, nlf, bitdepth, target_bitdepth, algos )

if ~exist('algos', 'var')
    algos = {'florian', 'florian_plus_denoise', 'denoise_plus_florian', 'joint', 'zhao'};
end

%RUN_EXP_RECONSTRUCTION_ALL_METHODS Summary of this function goes here
%   Detailed explanation goes here
expdir = getResultDir(sprintf('reconstruction_%s_%d_to_%d_bit_%0.2e_%0.2e', dataset, bitdepth, target_bitdepth, nlf.a, nlf.b));

nlf.bitdepth = bitdepth;
nlf = adapt_nlf(nlf, target_bitdepth);
p = 0.99;
exposures = exposure_times_florian( bitdepth, target_bitdepth, nlf, p, 100);
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

exp_opt = struct;
exp_opt.parallelize = strcmp(dataset, 'hdrps');
exp_opt.crop = true;
% exp_opt.rescale_crop = ~strcmp(dataset, 'cityscapes');
exp_opt.rescale_crop = false;

if strcmp(dataset, 'cityscapes')
    exp_opt.tmo = @(x) mapTone(x * 2^16);
else
    exp_opt.tmo = @tonemap_ward;
end

exp_opt

exposures

[ R_recon, data ] = exp_hdr_reconstruction( 'oracle', exposures, nlf, bitdepth, target_bitdepth, data_fun, ndata, exp_opt );
save(fullfile(expdir, sprintf('oracle.mat')), 'R_recon', 'exposures', 'weights', 'nlf', 'bitdepth', 'data_idx', 'target_bitdepth', 'data', 'energy_opt', 'exp_opt', 'optim_opt', '-v7.3');

for i=1:numel(algos)
    algo = algos{i};
    %%
    if strcmp(algo, 'florian')
        recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.florian(Ims, exposures, nlf, bitdepth, target_bitdepth);
    elseif strcmp(algo, 'zhao')
        recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.zhao(Ims, exposures, nlf, bitdepth, target_bitdepth);
    elseif strcmp(algo, 'florian_plus_denoise')
        recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.florian_plus_denoise(Ims, exposures, weights, nlf, bitdepth, target_bitdepth, energy_opt, optim_opt);
    elseif strcmp(algo, 'denoise_plus_florian')
        recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.denoise_plus_florian(Ims, exposures, weights, nlf, bitdepth, target_bitdepth, energy_opt, optim_opt);
    elseif strcmp(algo, 'joint')
        recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.joint(Ims, exposures, weights, nlf, bitdepth, target_bitdepth, energy_opt, optim_opt);
    elseif strcmp(algo, 'r_init')
        recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.init_only(Ims, exposures, bitdepth, target_bitdepth);
    end
    
    [ R_recon, data ] = exp_hdr_reconstruction( recon, exposures, nlf, bitdepth, target_bitdepth, data_fun, ndata, exp_opt );
    save(fullfile(expdir, sprintf('results_%s.mat', algo)), 'R_recon', 'exposures', 'weights', 'nlf', 'bitdepth', 'data_idx', 'target_bitdepth', 'data', 'energy_opt', 'exp_opt', 'optim_opt', '-v7.3');

end

end

