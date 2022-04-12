function[N] = NeuuCom(t,input,N,dt,population,neuronIndex)
%% Parameters: Inputs
% t = timestep
% input = current spikes of the whole network
% Neuron = all neuron parameters
% dt = time resolution
% population = which of the network population is the current calculation
% --> difference between inhibitory/excitatory
% neuronIndex = which neuron of the whole network

%% first test if the neuron spikes now and change Activations accordingly
if N.spike(neuronIndex,t) == 1 % did this neuron spike last time?
    % do not take external inputs
else % it didn't, take external inputs
    % set excitatory injection activation
    N.A_injection_Ex(neuronIndex,t) =...
        N.A_injection_Ex(neuronIndex,t)...
        + sum(input(input > 0))...% find excitatory input (everything positive)
        + N.A_spontaneous(population);
    % set inhibitory injection activation
    N.A_injection_In(neuronIndex,t) =...
        N.A_injection_In(neuronIndex,t)...
        + abs(sum(input(input < 0)));% find inhibitory input (everything negative)
end

%% Currents ---------------------------------------------------------------
N.I_injection_Ex(neuronIndex,t) =...
    N.G_injection(population)*N.A_injection_Ex(neuronIndex,t)*...
   (N.V_injection_Ex(population) - N.V(neuronIndex,t));
N.I_injection_In(neuronIndex,t) =...
    N.G_injection(population)*N.A_injection_In(neuronIndex,t)*...
   (N.V_injection_In(population) - N.V(neuronIndex,t));
N.I_leak(neuronIndex,t) =...
    N.G_leak(population)*(N.V_rest(population) - N.V(neuronIndex,t));
N.I_adaptation(neuronIndex,t) =...
    N.G_adaptation(population)*N.A_adaptation(neuronIndex,t)^N.A_adaptation_P(population)*...
    (N.V_adaptation(population) - N.V(neuronIndex,t));

%% Calculate new voltage, depending on if neuron spikes -------------------
if N.spike(neuronIndex,t) == 1 % yes
    % let it spike
    N.V(neuronIndex,t+1) = N.V_spike(population);
elseif N.V(neuronIndex,t) == N.V_spike(population)
    %reset voltage to hyperpolarization in the next step
    N.V(neuronIndex,t+1) = N.V_hyper(population);
else % no
    % voltage change
    dV = (dt/N.C_m(population))*...
        (N.I_leak(neuronIndex,t)...
        + N.I_injection_Ex(neuronIndex,t)...
        + N.I_injection_In(neuronIndex,t)...
        + N.I_adaptation(neuronIndex,t));
    % add noise
    dV = dV + ((0.000003*rand(1))/sqrt(dt));
    N.V(neuronIndex,t+1) = N.V(neuronIndex,t) + dV;
end

%% synaptic activation variable A: decay ----------------------------------
% excitatory
dA_syn_ex = -(dt/N.Tau_injection_Ex(population))*...
           N.A_injection_Ex(neuronIndex,t);
N.A_injection_Ex(neuronIndex,t+1) =...
    N.A_injection_Ex(neuronIndex,t) + dA_syn_ex;
% inhibitory
dA_syn_in = -(dt/N.Tau_injection_In(population))*...
           N.A_injection_In(neuronIndex,t);
N.A_injection_In(neuronIndex,t+1) =...
    N.A_injection_In(neuronIndex,t) + dA_syn_in;

%% conductance change da --------------------------------------------------
da = -(dt/N.Tau_adaptation(population))*N.A_adaptation(neuronIndex,t);
% new adaptation activation
N.A_adaptation(neuronIndex,t+1) = N.A_adaptation(neuronIndex,t) + da;

%% is the voltage surpassing the threshold for spiking next timestep ------
if N.V(neuronIndex,t+1) >= N.V_th(population)
    if N.V(neuronIndex,t+1) == N.V_spike(population)
        % do nothing, no spike command
    else
        % record a spike event
        N.spike(neuronIndex,t+1) = 1;
        % increase spike rate adaptation "activation"
        N.A_adaptation(neuronIndex,t+1) =...
            N.A_adaptation(neuronIndex,t+1)...
            + N.G_adaptation_Step(population);
    end
elseif N.V(neuronIndex,t+1) < N.V_hyper(population)
    N.V(neuronIndex,t+1) = N.V_hyper(population);
end

end