function [moduloImage, rollovers]=moduloKamera(HDRImage, resultingBit, containedBit)
%moduloKamera 
% calculates the modulo image and the rollovers of the HDRImage.

maxsize=2^(resultingBit);

if( nargout >1)
rollovers=floor(double(HDRImage)/(maxsize));
end
moduloImage=mod(HDRImage, maxsize);
end