function [ o ] = selectOutput( f, n )
%SELECTOUTPUT Summary of this function goes here
%   Detailed explanation goes here

o = cell(max(n, nargout(f)),1);
[o{:}] = f();
o = o{n};

end

