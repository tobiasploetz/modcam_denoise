function [reconstrucedWithCor, reconstrucedWithout, YN, Y] = testsuite_florian(I, exposures, nlf, bitdepth, target_bitdepth)


%all image names in the specified folder;
params.bits=target_bitdepth; %assuming input bitdepth is always 16
params.addNew=true;

bitRec = bitdepth;
params.bitRec=bitRec;
params.startingExposures=exposures;

params.noiseA=nlf.a*(2^params.bitRec-1);%;
params.noiseB=nlf.b*(2^params.bitRec-1)^2;%*((2^bits-1)^2);
if(params.noiseA==0 && params.noiseB==0)
    params.epsilon=@(y)(int32(zeros(size(y))));
else
    params.epsilon=@(y)(noiseTerm(y,params.noiseA,params.noiseB));
end
params.cameraM=@(y)moduloKamera(y,params.bitRec);
params.cameraI=@(y)intensityKamera(y,params.bitRec);

params.startingExposures=exposures;


Y=int32(I*2^target_bitdepth); %clear ground truth

YN=int32(max(Y+params.epsilon(Y),0));

[ yi,ei,xiM,xiI,params.usedExposure,params.addedNew ]=getReducedExposure( Y, params);

reconstrucedWithout = int32(doMultiReconstruction( xiM, params.usedExposure, params.bitRec));

reconstrucedWithCor = int32(doMultiReconstructionCor( xiM, params.usedExposure, params.bitRec));

% tmp=double(yi{end})+double(ei{end});
% reconstrucedIntensity = int32(doMultiReconstructionIntensity( xiI, params.usedExposure, params.bitRec,max(tmp(:)) ));


end
