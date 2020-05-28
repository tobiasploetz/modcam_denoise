function [data_fun, ndata] = denoising_data_bsds( opt, data_idx )
%DEBLURRING_DATA_LEVIN09 Summary of this function goes here
%   Detailed explanation goes here

if ~exist('opt', 'var')
    opt = struct;
end
downscale_factor = getOpt(opt, 'downscale_factor', 1);
split = getOpt(opt, 'split', 'train');


imgfiles = dir(fullfile('/visinf/projects/visinf/datasets/BSDS500/data/images/', split, '*.jpg'));

if exist('data_idx', 'var')
    imgfiles = imgfiles(data_idx);
end

ndata = numel(imgfiles);

    function [Iclean] = fun(i)
          
        Iclean = im2double(imread(fullfile(imgfiles(i).folder, imgfiles(i).name)));
        if size(Iclean,3) > 1
            Iclean = rgb2gray(Iclean);
        end
        if downscale_factor < 1
            Itmp = imresize(Iclean, downscale_factor);
            Iclean = croptosize(Iclean, size(Itmp));
        end
        
    end

data_fun = @fun;
end

