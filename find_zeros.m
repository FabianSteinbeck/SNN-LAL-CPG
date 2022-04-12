function [z]=find_zeros(s)
% z=find_zeros(s)
% find zeros as points where signal changes signs
% s - signal sample
% z - indices which cross zero with sign changed
% isrise(i) = true if i-zeros in case of come - then +

cs=xor((s(1:end-1)>=0),(s(2:end)>=0));

z=find(cs);

