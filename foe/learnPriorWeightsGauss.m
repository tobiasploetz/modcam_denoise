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
nsigmas = 100;
sigmas = 10.^linspace(-5,2,nsigmas);
flatsz = [prod(size2(imgs,1:2)), size(imgs,3)];

m_g_llh = zeros(nsigmas,1);
m_g_lprior = zeros(nsigmas,1);

parfor i=1:nsigmas
    foe = learned_models.gcpr2012_3x3_foe;
    foe.imdims = size2(imgs, 1:2);
    sigma = sigmas(i);
    imgs_noisy = imgs + randn(size(imgs)) * sigma;
    [~,~,g_llh, g_lprior] = FoEGauss_llh_and_grad(reshape(imgs, flatsz), reshape(imgs_noisy, flatsz), foe, sigma, 1);
    m_g_llh(i) = mean(g_llh(:));
    m_g_lprior(i) = mean(g_lprior(:));
end

%%
prior_weights = m_g_llh ./ -m_g_lprior;

%%
save('algos_denoising/mmse_mrf_demo/prior_weights_gauss.mat', 'm_g_llh', 'm_g_lprior', 'sigmas', 'prior_weights');