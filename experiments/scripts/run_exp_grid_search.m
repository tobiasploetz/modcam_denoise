function run_exp_grid_search( bitdepth, target_bitdepth )

dataset= 'psftools';

expdir = getResultDir(sprintf('gridsearch_%s_%d_to_%d_bit', dataset, bitdepth, target_bitdepth));

nlfs(1) = struct('a', 1e-1, 'b', 1e-2);
nlfs(end+1) = struct('a', 1e-2, 'b', 1e-4);
nlfs(end+1) = struct('a', 1e-3, 'b', 1e-5);
nlfs(end+1) = struct('a', 1e-4, 'b', 1e-6);
nnlfs = numel(nlfs);

lambdas = [0 10.^(linspace(0,3, 10))];
nlambda = numel(lambdas);

exp_opt = struct;
exp_opt.crop = true;
exp_opt.rescale_crop = ~strcmp(dataset, 'cityscapes');
if strcmp(dataset, 'cityscapes')
    exp_opt.tmo = @(x) mapTone(x * 2^16);
else
    exp_opt.tmo = @tonemap_ward;
end

data_opt = struct;
data_idx = [];
[data_fun, ndata] = get_hdr_data(dataset,data_opt,data_idx);
ndata
data_opt

foe = learned_models.cvpr_pw_mrf;

datas = cell(nnlfs, nlambda);
energy_opts = cell(nnlfs, nlambda);
for i = 1:nnlfs
    nlf = nlfs(i);
    nlf.bitdepth = bitdepth;
    nlf = adapt_nlf(nlf, target_bitdepth);
    p = 0.99;
    exposures = exposure_times_florian( bitdepth, target_bitdepth, nlf, p, 100);
    exposures
    weights = exposures.^2;
    for j=1:nlambda
        energy_opt = struct;
        % energy_opt.clipped = true;
        energy_opt.clipped = false;
        energy_opt.prior = foe;
        energy_opt.lambda = lambdas(j);
        energy_opt.normalizer = 1;
        
        optim_opt = struct;
        optim_opt.minfunc_opt = struct;
        optim_opt.minfunc_opt.method = 'lbfgs';
        optim_opt.minfunc_opt.MaxIter = 40;
        optim_opt.weight_strategy = 'merge';
        optim_opt.init_with_florian = true;
        optim_opt.rescale_weights = false;
        
        recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.joint(Ims, exposures, weights, nlf, bitdepth, target_bitdepth, energy_opt, optim_opt);
        [ R_recon, data ] = exp_hdr_reconstruction( recon, exposures, nlf, bitdepth, target_bitdepth, data_fun, ndata, exp_opt );
        
        datas{i,j} = data;
        energy_opts{i,j} = energy_opt;
    end
end

save(fullfile(expdir, sprintf('results.mat')), 'dataset', 'nlfs', 'bitdepth', 'data_idx', 'target_bitdepth', 'datas', 'energy_opts', 'exp_opt', 'optim_opt', '-v7.3');

end