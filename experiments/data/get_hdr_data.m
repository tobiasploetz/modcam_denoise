function [ data_fun, ndata ] = get_hdr_data( dataset, varargin )
%GET_HDR_DATA Summary of this function goes here
%   Detailed explanation goes here


if strcmp(dataset, 'hdrps')
    [data_fun, ndata] = hdr_data_hdrps(varargin{:});
elseif strcmp(dataset, 'debevec')
    [data_fun, ndata] = hdr_data_debevec(varargin{:});
elseif strcmp(dataset, 'psftools')
    [data_fun, ndata] = hdr_data_psftools(varargin{:});
elseif strcmp(dataset, 'cityscapes')
    [data_fun, ndata] = hdr_data_cityscapes(varargin{:});
end

end

