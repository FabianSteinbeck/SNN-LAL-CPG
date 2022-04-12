function[dA] = Orienter(A)
%%
% calculate angle differences within 0+pi (left turns) and 0-pi (right
% turns)
%%
for i = 1:length(A)-1
    
    dA(i) = A(i+1) - A(i);
    if dA(i) > pi
        dA(i) = -pi + (dA(i) - pi);
    elseif dA(i) < -pi
        dA(i) = pi + (dA(i) + pi);
    end
    
end

end