function [ R_recons, data ] = exp_hdr_reconstruction( f_recon, exposures, nlf, bitdepth, target_bitdepth, data_fun, ndata, opt )

if ~exist('opt', 'var')
    opt = struct;
end

random_seed = getOpt(opt, 'random_seed', 42);
store_recon = getOpt(opt, 'store_recon', false);
crop = getOpt(opt, 'crop', false);
rescale_crop = getOpt(opt, 'rescale_crop', false);
parallelize = getOpt(opt, 'parallelize', false);
tmo = getOpt(opt, 'tmo', @tonemap_ward);

R_recons = cell(ndata,1);
psnrs = zeros(ndata, 1);
ssims = zeros(ndata, 1);

psnrs_tm = zeros(ndata, 1);
ssims_tm = zeros(ndata, 1);
global gt

for i=1:ndata
    fprintf('%d/%d', i, ndata);
    I = double(feval(data_fun,i));
    if crop
        [h,w,c] = size(I);
        w = floor(w/2)-200; h = floor(h/2)-200;
        I = I(h:h+400-1,w:w+400-1,:);
        if rescale_crop
            I = (I - min(I(:))) / (max(I(:)) - min(I(:)));
        end
    end
        
    R_recon=zeros(size(I));
    for c=1:size(I,3)
        I_iter = I(:,:,c);
        [Ims, ks] = create_exposures(I_iter, exposures, bitdepth, target_bitdepth,nlf, random_seed+i);
        if strcmp(f_recon, 'oracle')
            R_recon(:,:,c) = (ks{end}*2^bitdepth + Ims{end}) / 2^target_bitdepth;
        else
            Ims = cat(3, Ims{:});
            [R_recon(:,:,c)] = f_recon(Ims, exposures, bitdepth, target_bitdepth, nlf);
        end
    end
    psnrs(i) = psnr(I, R_recon);
    ssims(i) = ssim(I, R_recon);
    
    gt = I;
    I_tm = tmo(I);
    R_recon_tm = tmo(R_recon);
    
    psnrs_tm(i) = psnr(I_tm, R_recon_tm);
    ssims_tm(i) = ssim(I_tm, R_recon_tm);
    
    if store_recon
        R_recons{i} = R_recon;
    end
end
data = struct;
data.psnrs = psnrs;
data.ssims = ssims;
data.psnrs_tm = psnrs_tm;
data.ssims_tm = ssims_tm;

end

