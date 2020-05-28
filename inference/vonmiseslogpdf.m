function p = vonmiseslogpdf( x, mu, kappa )
%VONMISESPDF Summary of this function goes here
%   Detailed explanation goes here

p = (kappa .* cos(x-mu)) - log(2*pi*besseli(0,kappa));

end

