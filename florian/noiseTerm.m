function [ ei ] = noiseTerm( y,a,b )
%NOISETERM Returns gaussian noise for the image y, using sqrt(a*y+b)
% as standard deviation. a,b should be scaled already.
y=double(y);
ei=int32(random('norm', 0, sqrt(a*y+b)));

end

