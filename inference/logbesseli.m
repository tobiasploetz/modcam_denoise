%#   $Author: Israel D. Gebru $    $Date: 2016/04/28 $    $Revision: 1.0 $
%#   Copyright:

function [logb] = logbesseli(nu,x)
% log of the Bessel function, extended for large nu and x
% approximation from Eqn 9.7.7 of Abramowitz and Stegun
% http://www.math.sfu.ca/~cbm/aands/page_378.htm
frac = x/nu;
square = 1 + frac.^2;
root = sqrt(square);
eta = root + log(frac) - log(1+root);
approx = - log(sqrt(2*pi*nu)) + nu*eta - 0.25*log(square);
logb = approx;
% alternative less accurate approximation from Eqn 9.6.7
% this gives better results on the Classic400 dataset!
% logb = nu*log(x/2) - gammaln(nu+1);
% [bessel,flags] = besseli(nu,x);
% if any(flags ~= 0) || any(bessel == Inf)
%     besselproblem = [x, bessel, flags];
% end
% logb = bessel;
% nz = find(bessel > 0);
% z = find(bessel == 0);
% logb(nz) = log(bessel(nz));
% logb(z) = nu*log(x(z)/2) - gammaln(nu+1);
%[nu*ones(size(x))'; x'; approx'; logb']
end