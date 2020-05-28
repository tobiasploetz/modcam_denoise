function [ reconstructed ] = doMultiReconstructionCor( xi,exposure,bitRecover, E_init)
%DOMULTIRECONSTRUCTION 
% Reconstructs from a series of modulo images using the robust algorithm.

if exist('E_init', 'var') && ~isempty(E_init)
    ECor=E_init;
else
    ECor=zeros(size(xi{1}));
end
for k=1:(length(exposure))
    
    KCont=(exposure(k)*ECor)/(2^bitRecover);
    K=floor(KCont); %17 %228
    
    KCont=KCont-K; %0,8819 %0,85
    
    expected=KCont*2^bitRecover; %225,77 %219,5
    
    dif=expected-double(xi{k}); %146 %142,5
    cor=zeros(size(dif));
    cor(dif<-(2^(bitRecover-1)))=-1;
    cor(dif>(2^(bitRecover-1)))=1; %1 %1
    
    K=K+cor; %18 %229
    K(K<0)=0;
    
    ECor=(double(xi{k})+2^bitRecover*K)/exposure(k); %57222,2222 %5858,75

end
reconstructed=int32(ECor);
end

