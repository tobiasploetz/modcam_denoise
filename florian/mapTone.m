function [ imO ] = mapTone( imI )
%MAPTONE 
% maps images from the cityscapes dataset to look natural.
% Credits to Marius Cordts for providing a c++ implementation.

size_ui=size(imI,1)*size(imI,2);

temp_p=double(imI);

temp_p(temp_p<16)=16;
temp_p(temp_p>16383)=16383;

currMinPreLog_f = 16;
currMaxPreLog_f = 16383;
targetMinPreLog_f = 16.0;
targetMaxPreLog_f = 200.0;
scalePreLog_f  = (targetMaxPreLog_f - targetMinPreLog_f) / (currMaxPreLog_f - currMinPreLog_f);

temp_p = (temp_p - currMinPreLog_f) * scalePreLog_f + targetMinPreLog_f;
temp_p = log1p(temp_p);


currMinPostLog_f = log1p(16.0);
currMaxPostLog_f = log1p(200.0);
targetMinPostLog_f = 0.0;
targetMaxPostLog_f = 255;%2^16-1;
scalePostLog_f  = (targetMaxPostLog_f - targetMinPostLog_f) / (currMaxPostLog_f - currMinPostLog_f);

temp_p = (temp_p - currMinPostLog_f) * scalePostLog_f + targetMinPostLog_f;

imO = uint8( temp_p + 0.5 );

end

