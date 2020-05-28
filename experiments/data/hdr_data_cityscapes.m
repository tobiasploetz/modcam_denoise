function [data_fun, ndata] = hdr_data_cityscapes( opt, data_idx )
%DEBLURRING_DATA_LEVIN09 Summary of this function goes here
%   Detailed explanation goes here

if ~exist('opt', 'var')
    opt = struct;
end
downscale_factor = getOpt(opt, 'downscale_factor', 1);
to_grayscale = getOpt(opt, 'to_grayscale', true);


imgfiles = dir(fullfile('/visinf/projects/visinf/datasets/HDR/cityscapes/','*.png'));

if exist('data_idx', 'var') && ~isempty(data_idx)
    imgfiles = imgfiles(data_idx);
end

ndata = min(numel(imgfiles), 30);

    function [Iclean] = fun(i)
        Iclean = im2double(imread(fullfile(imgfiles(i).folder, imgfiles(i).name)));
        if size(Iclean,3) > 1 && to_grayscale
            Iclean = rgb2gray(Iclean);
        end
        if downscale_factor < 1
            Itmp = imresize(Iclean, downscale_factor);
            Iclean = croptosize(Iclean, size(Itmp));
        end
        
    end

data_fun = @fun;
end

