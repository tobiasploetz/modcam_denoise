function run_exp_reconstruction_nlf_sweep( dataset, bitdepth, target_bitdepth, exposure_extend, algos, data_idx )

if ~exist('algos', 'var')|| isempty(algos)
    algos = {'florian', 'joint'};
end

if ~exist('data_idx', 'var')
    data_idx = [];
end

%RUN_EXP_RECONSTRUCTION_ALL_METHODS Summary of this function goes here
%   Detailed explanation goes here
expdir = getResultDir(sprintf('reconstruction_nlfsweep_%s_%d_to_%d_bit', dataset, bitdepth, target_bitdepth));

as = 10.^(linspace(-4,-1,15));
bs = 10.^(linspace(-6,-3,15));
nlfs = cell(15,15);
for i=1:15
    for jj=1:15
        nlfs{i,jj} = struct('a', as(i), 'b', bs(jj), 'bitdepth', bitdepth);
        nlfs{i,jj} = adapt_nlf(nlfs{i,jj}, target_bitdepth);
    end
end

foe = learned_models.cvpr_pw_mrf;

energy_opt = struct;
energy_opt.clipped = false;
energy_opt.prior = foe;
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
% data_idx = [];
[data_fun, ndata] = get_hdr_data(dataset,data_opt,data_idx);
ndata
data_opt

exp_opt = struct;
exp_opt.crop = true;
exp_opt.rescale_crop = ~strcmp(dataset, 'cityscapes');
exp_opt

for i=1:numel(algos)
    algo = algos{i};
    %%
    
    datas = cell(15*15,1);
    parfor k=1:numel(datas)
        [ii,jj] = ind2sub(size(nlfs), k);
        nlf = nlfs{ii,jj}

        energy_opt_iter = energy_opt;
        energy_opt_iter.lambda = getlambda(bitdepth, nlf);
        
        p = 0.99;
        exposures = exposure_times_florian( bitdepth, target_bitdepth, nlf, p, 100);
        if exposure_extend==1
            exposures = [ones(1,3)*exposures(1) exposures(2) exposures(3:end)];
        elseif exposure_extend==2
            exposures = [exposures(1) ones(1,3)*exposures(2) exposures(3:end)];
        elseif exposure_extend==3
            if numel(exposures) > 2
                exposures = [exposures(1) exposures(2) ones(1,3)*exposures(3) exposures(4:end)];
            else
                exposures = [exposures(1) ones(1,3)*exposures(2)];
            end
        end
        
        exposures
        
%         weights = ones(size(exposures));
        weights = exposures.^2;
        
        if strcmp(algo, 'florian')
            recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.florian(Ims, exposures, nlf, bitdepth, target_bitdepth);
        elseif strcmp(algo, 'zhao')
            recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.zhao(Ims, exposures, nlf, bitdepth, target_bitdepth);
        elseif strcmp(algo, 'florian_plus_denoise')
            recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.florian_plus_denoise(Ims, exposures, weights, nlf, bitdepth, target_bitdepth, energy_opt_iter, optim_opt);
        elseif strcmp(algo, 'denoise_plu_florian')
            recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.denoise_plus_florian(Ims, exposures, weights, nlf, bitdepth, target_bitdepth, energy_opt_iter, optim_opt);
        elseif strcmp(algo, 'joint')
            recon = @(Ims, exposures, bitdepth, target_bitdepth, nlf) baselines.joint(Ims, exposures, weights, nlf, bitdepth, target_bitdepth, energy_opt_iter, optim_opt);
        end
        
        [R_recon, data ] = exp_hdr_reconstruction( recon, exposures, nlf, bitdepth, target_bitdepth, data_fun, ndata, exp_opt );
        data.nlf = nlf;
        data.exposures = exposures;
        data.weights = weights;
        datas{k} = data;
    end
    datas = reshape(datas,size(nlfs));
    save(fullfile(expdir, sprintf('results_%s.mat', algo)), 'nlfs', 'bitdepth', 'data_idx', 'target_bitdepth', 'exp_opt', 'datas', 'energy_opt', 'optim_opt', '-v7.3');
    
end

end

