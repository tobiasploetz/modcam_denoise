BSDSpath = '~/data/BSDS500/data/images/train/';
files = dir(fullfile(BSDSpath, '*.jpg'));
nfiles = numel(files);

imgs = {};
for i =1:nfiles
    I = rgb2gray(im2double(imread(fullfile(BSDSpath, files(i).name))))*255;
    if size(I,1) > size(I,2)
        I = imrotate(I, 90);
    end
    imgs{i} = I;
end
imgs = cat(3, imgs{:});
%%
%%
nbeta_a = 20;
nbeta_b_fac = 5;
nnlf = nbeta_a*nbeta_b_fac;

beta_as = 10.^linspace(-5,-1, nbeta_a);
beta_b_facs = 10.^linspace(-4,-1, nbeta_b_fac);

nlfs = struct('a', {}, 'b', {});
for i=1:nbeta_a
    for j=1:nbeta_b_fac
        nlf = struct;
        nlf.a = beta_as(i);
        nlf.b = nlf.a * beta_b_facs(j);
        nlfs(end+1) = nlf;
    end
end

%%
flatsz = [prod(size2(imgs,1:2)), size(imgs,3)];

m_g_llh = zeros(nnlf,1);
m_g_lprior = zeros(nnlf,1);

parfor i=1:nnlf
    foe = learned_models.gcpr2012_3x3_foe;
    foe.imdims = size2(imgs, 1:2);
    nlf = nlfs(i);
    imgs_noisy = simulateNoise(imgs./255, nlf.a, nlf.b, true)*255;
    
    nlf.a = nlf.a*255;
    nlf.b = nlf.b*255^2;
    
    [~,~,g_llh, g_lnorm, g_lprior] = FoEHetscedGauss_llh_and_grad(reshape(imgs, flatsz), reshape(imgs_noisy, flatsz), foe, nlf, 1);
    m_g_llh(i) = mean(g_llh(:)+ g_lnorm(:));
    m_g_lprior(i) = mean(g_lprior(:));
end

%%
prior_weights = m_g_llh ./ -m_g_lprior;

%%
save('algos_denoising/mmse_mrf_demo/prior_weights_hetscedgauss.mat', 'm_g_llh', 'm_g_lprior', 'nlfs', 'prior_weights');