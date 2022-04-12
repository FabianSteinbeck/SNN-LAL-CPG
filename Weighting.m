function[Weights,LeftHalves,RightHalves] = Weighting(Indices,combination)

% columns: each neuron of the populations
% rows: connections from the other neurons
% the first half of indices of each population are left-sided, the rest
% right-sided
% negative weights depict inhibitory connections

%% Sort the indices of each population into right and left halves
for half = 1:size(Indices,2)
    if half < 2
        LeftHalves{half} = (Indices(half) - Indices(half) + 1):(Indices(half)/2);
        RightHalves{half} = (LeftHalves{half}(end) + 1):Indices(half);
    else
        Ns = Indices(half) - Indices(half - 1);
        if Ns > 2
            LeftHalves{half} = (Indices(half - 1) + 1):(Indices(half - 1) + 1) + Ns/2 - 1;
            RightHalves{half} = (LeftHalves{half}(end) + 1):Indices(half);
        else
            LeftHalves{half} = (Indices(half - 1) + 1);
            RightHalves{half} = (LeftHalves{half}(end) + 1):Indices(half);
        end
    end
end

%% setup connections for each population individually
WE21 = 1; % Weight external input to population 1 (E21)
W1 = [0.5,1,2,3,5];
W122 = W1(combination(5)); %Weight population 1 to population 2 (122)
W2 = [0.5,1,2,3,5];
W123 = W2(combination(6)); %Weight population 1 to population 3 (123)
W3 = [-0.5,-1,-2,-3,-5];
W222 = W3(combination(7))/size(LeftHalves{2},2); %Weight population 2 to population 2 (222)
W4 = [-0.5,-1,-2,-3,-5];
W223 = W4(combination(8))/size(LeftHalves{2},2); %Weight population 2 to population 3 (223)
Weights = zeros(Indices(end));

for i = 1:size(Indices,2) % loop through each population
    if i == 1 % the excitatory input neurons connect from the other populations in the same hemisphere
        % population 1 only receives input from the external "eyes"
        % left
        for ii = LeftHalves{i}(1):LeftHalves{i}(end)
            Weights(LeftHalves{i},ii) = WE21; % input from ipsilateral external input
        end
        % right
        for ii = RightHalves{i}(1):RightHalves{i}(end) 
            Weights(RightHalves{i},ii) = WE21; % input from ipsilateral external input
        end
    elseif i == 2 % the inhibitory CPG connect to the other hemisphere ----
     % left
        for ii = LeftHalves{i}(1):LeftHalves{i}(end)
            Weights(LeftHalves{i-1},ii) = W122; % input from ipsilateral input neurons
            Weights(RightHalves{i},ii) = W222; % input from contralateral CPG
        end
        % right
        for ii = RightHalves{i}(1):RightHalves{i}(end) 
            Weights(RightHalves{i-1},ii) = W122; % input from ipsilateral input neurons
            Weights(LeftHalves{i},ii) = W222; % input from contralateral CPG
        end
    elseif i == 3 % the excitatory output
        % left
        for ii = LeftHalves{i}(1):LeftHalves{i}(end)
            Weights(LeftHalves{i-2},ii) = W123; % input from ipsilateral input neurons
            Weights(RightHalves{i-1},ii) = W223; % input from contralateral CPG
        end
        % right
        for ii = RightHalves{i}(1):RightHalves{i}(end)
            Weights(RightHalves{i-2},ii) = W123; % input from ipsilateral input neurons
            Weights(LeftHalves{i-1},ii) = W223; % input from contralateral CPG
        end
    end
end

end