function [ ts ] = exposure_times_florian( bitdepth, target_bitdepth, nlf, p, nt_max )
%EXPOSURE_TIMES_FLORIAN Summary of this function goes here
%   Detailed explanation goes here

% from Testsuit2.m

exposures=[0.003, 0.02, 0.1, 0.3, 0.6250, 1.000];
if p==0.99
    l = 2.576;
else
    l = norminv(0.5+0.5*p, 0, 1); % cf Eq. 91-92
end

a = nlf.a_orig * (2^bitdepth-1);
b = nlf.b_orig * (2^bitdepth-1)^2;
[ts] = calculateExposure2(a,b,(2^target_bitdepth-1),0.9*2^(bitdepth-target_bitdepth),bitdepth,l, nt_max);
lim=ts(end);
if(isnan(lim))
    lim=inf;
end
params = struct;
if(isreal(lim) && lim>0.3)
    if(lim>1)
        params.startingExposures=ts(ts(:)<1);
        if(params.startingExposures(end)<0.01)
            params.startingExposures=[params.startingExposures 0.1];
        end
        params.startingExposures=[params.startingExposures 1];
    else
        if(lim > 0.65)
            params.startingExposures=[ts(1:2)  1];
        else
            params.startingExposures=[ts(1:2) 0.7 1];
        end
    end
else
    params.startingExposures=[ts(1) exposures(exposures > ts(1))];
end

ts = params.startingExposures;


end

