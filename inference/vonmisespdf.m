function p = vonmisespdf( x, mu, kappa )
%VONMISESPDF Summary of this function goes here
%   Detailed explanation goes here

p = exp(kappa .* cos(x-mu)) ./ ( 2*pi*besseli(0,kappa));

end

