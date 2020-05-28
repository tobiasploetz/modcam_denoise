function [ ts, ys, lim] = calculateExposure2( a,b,yForTauIs1,t1,N,l ,limit)
%CALCULATEEXPOSUREFORNORMED 
% calculates the optimal exposures, maximal achievable image values and 
% theoretical limit given noise, starting value/exposure, bit-depth and 
% desired probability.


%limit=100;
%6291456 Pixel (all channels) per image.
m=length(a);
ts=zeros(m,limit);
ys=zeros(m,limit);

c=(2^(N-1)/l);

ts(:,1)=t1;
y=yForTauIs1*t1;
ys(:,1)=y;
for i=2:limit
    
    A=a*y+b-l^-2;
    B=a*y+(2^(N)-2)*l^-2;
    C=b-(2^(N-1)-1)^2*l^-2;
    
    ts(:,i)=ts(:,i-1).*(-B+sqrt(B^2-4*A*C))/(2*A);
    
    y=yForTauIs1*ts(:,i);
    ys(:,i)=y;
end

A=2*a^2*yForTauIs1^2;
B=4*a*b*yForTauIs1+(2^(N+1)-6-2^(2*N-2))*a*yForTauIs1*l^(-2);
C=2*b^2+l^(-4)*(2^(2*N-2)-2^(N-1)+4)+b*l^(-2)*(2^(N+1)-2-2^(2*N-2));

lim=(-B+sqrt(B^2-4*A*C))/(2*A);
if(limit>1)
 %lim=ts(end);
end
 %ts=0;
 %ys=0;