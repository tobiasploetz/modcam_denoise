function [ reconstructed ] = doMultiReconstructionIntensity( xi,exposure,bitRecover, maximal)
%DOMULTIRECONSTRUCTIONINTENSITY Summary of this function goes here
%   Detailed explanation goes here

n=length(xi);

hdr=mymakehdr(xi, exposure,floor(0.98*(2^bitRecover)));

reconstructed=int32((double(hdr)/max(double(hdr(:))))*double(maximal));

end

