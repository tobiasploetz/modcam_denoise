function surf_exposures( I1, k1, I2, k2 )
%SCATTER_EXPOSURES Summary of this function goes here
%   Detailed explanation goes here

maxI= max([I1(:); I2(:)])+1;
Z = zeros(maxI);
idx = sub2ind([maxI, maxI], I1(:)+1, I2(:)+1);
Z(idx) = k1(:);

surf(0:maxI-1, 0:maxI-1, Z);

end

