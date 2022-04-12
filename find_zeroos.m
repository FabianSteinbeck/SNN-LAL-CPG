function [z]=find_zeroos(s)
% z=find_zeros(s)
% find zeros as points where signal changes signs
% s - signal sample
% z - indices which cross zero with sign changed
% isrise(i) = true if i-zeros in case of come - then +

st = zeros(1,length(s)-1);

for i = 2:length(s)
    
    if s(i) ~= 0
        st(i) = s(i);
    elseif s(i) == 0 && s(i-1) ~= 0
        st(i) = st(i-1);
    elseif s(i) == 0 && s(i-1) == 0
        st(i) = st(i-1);
    end
    
end

cs=xor((st(1:end-1)>=0),(st(2:end)>=0));
z=find(cs);