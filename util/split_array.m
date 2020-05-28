function [ O ] = split_array( A, dim )
%SPLIT_ARRAY Summary of this function goes here
%   Detailed explanation goes here

ndim = numel(size(A));
index_str = 'A(';
for i=1:ndim
    if i==dim
        index_str = [index_str, 'i'];
    else
        index_str = [index_str, ':'];
    end

    if i==ndim
        index_str = [index_str, ')'];
    else
        index_str = [index_str, ','];
    end
end


O = arrayfun(@(i) tmp(i,A,index_str) , 1:size(A,dim), 'uniformoutput', false);
end

function o = tmp(i, A, index_str)
    B=A;
    o = eval(index_str);
end