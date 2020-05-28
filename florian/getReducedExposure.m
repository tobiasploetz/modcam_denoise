function [ yi,ei,xiM,xiI,exposure,addedNew ]=getReducedExposure( Y, exposure, cameraM,cameraI,epsilon, addNoRollover,newDepth)
%GETREDUCEDEXPOSURE 
% can be called via getReducedExposure(Y, exposure, cameraM, cameraI, epsilon, addNoRollover, newDepth)
% or getReducedExposure(Y, params), where params is a struct containing the other variables. 
% Where exposure=params.startingExposures;, addNoRollover=params.addNew;, newDepth=params.bitRec; (Other three same name).
%
% Y is the grund truth, exposure the requested exposure times.
% cameraM,cameraI,epsilon: modulo, saturating camera and noise term function.
% newDepth is the bit-depth of the cameras and 
% if addNoRollover is true a new exposure time without rollovers/saturated pixels is added if needed (according to noise free Y).
%
% returns:
% yi the scaled noise free images,
% ei the noise term,
% xiM the modulo images,
% xiI the saturating images,
% exposure the actually used exposures,
% addedNew flag if a new exposure time has been added.


addedNew=false;
if(nargin==2)
    params=exposure;
    exposure=params.startingExposures;
    cameraM=params.cameraM;
    cameraI=params.cameraI;
    epsilon=params.epsilon;
    addNoRollover=params.addNew;
    newDepth=params.bitRec;
end
if((nargin==2) || ((nargin>=6) && addNoRollover))
    % add a new one without rollovers.
    scale=double((2^newDepth-1))/double(max(Y(:)));
    if(scale<min(exposure(:)))
        exposure=[0.9*scale exposure];
        addedNew=true;
    end
end

amount=length(exposure);
yi=cell(1,amount);
ei=cell(1,amount);
xiM=cell(1,amount);
xiI=cell(1,amount);
for i=1:amount
    
    yi{i} = int32(Y*exposure(i));
    ei{i} = epsilon(yi{i});
    xiM{i} = cameraM(max(yi{i}+ei{i},0));
    xiI{i} = cameraI(max(yi{i}+ei{i},0));
end
end

