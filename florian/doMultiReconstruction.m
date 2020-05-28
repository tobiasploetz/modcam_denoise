function [ reconstructed ] = doMultiReconstruction( xi,exposure,bitRecover, E_init)
%DOMULTIRECONSTRUCTION 
% Reconstructs from a series of modulo images using the naive algorithm.

if exist('E_init', 'var') && ~isempty(E_init)
    EDef=E_init;
else
    EDef=zeros(size(xi{1}));
end

for k=1:(length(exposure))
    K=floor((exposure(k)*EDef)/(2^bitRecover));
    EDef=(double(xi{k})+2^bitRecover*K)/exposure(k);
end
reconstructed=int32(EDef);

end

