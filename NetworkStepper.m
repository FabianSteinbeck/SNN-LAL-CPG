function[N] = NetworkStepper(N,N_Indices,t,dt,f,W)

%% looping through all network populations and calculating the new voltage for this timestep
% N = Neuron struct
% N_Indices = Which neurons belong to which polulation
% t = timestep
% dt = temporal resolution
% f = fabricated input
% W = Weight matrix
%% neuron calculations ----------------------------------------------------
for i = 1:size(N_Indices,2) %loop through all populations
    if i == 1 % first population
        for ii = i:N_Indices(i) %% each ii depicts one neuron of the population
            N = NeuuCom(t,W(:,ii).*f,N,dt,i,ii);% input is familiarity
        end
    elseif i == 2 % 2nd population
        for ii = (N_Indices(i-1)+1):N_Indices(i)
            N = NeuuCom(t,W(:,ii).*N.spike(:,t),N,dt,i,ii);
        end
    else % 3rd population
        for ii = (N_Indices(i-1)+1):N_Indices(i)
            N = NeuuCom(t,W(:,ii).*N.spike(:,t),N,dt,i,ii);
        end
    end
end
end