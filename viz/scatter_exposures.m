function scatter_exposures( I1, k1, I2, k2, val1 )
%SCATTER_EXPOSURES Summary of this function goes here
%   Detailed explanation goes here
idx = I1==val1;

scatter(I2(idx), k1(idx)+ (k1(idx)-k2(idx))/(2*max(k1(:))));
end

