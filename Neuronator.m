function[NP,Populations,populationIndices] = Neuronator(preallocation,combination)
%% Description
% The neuronator sets up the whole neuron-population. Each possible
% variable gets its own matrix, which will be shared among all neurons.
% Row-dimension is the amount of neurons, column-dimension is the time
% steps (if it changes over time)
% multiple values in the parameters refer to each neuronpopulation in the
% same order as "Populations"

Populations.InputNeurons = 2;
Populations.InhibitoryNeurons = 2;
Populations.OutputNeurons = 2;

subPopulations = fieldnames(Populations);
neuronNumber = 0;
populationIndices = []; %last index of each population
for i = 1:numel(subPopulations)
    neuronNumber = neuronNumber + Populations.(subPopulations{i});
    populationIndices(i) = neuronNumber;
end
%% Neuron Parameters ------------------------------------------------------
%% Membrane conductance C_m
NP.C_m = [1e-9,1e-9,1e-9]; %[Farad] the smaller, the stronger excitability
%% Resting potential
NP.V_rest = [-0.06,-0.06,-0.06]; %[V]
%% Cell potential V
NP.V = zeros(neuronNumber,preallocation); %[V]
NP.V(:,1) = NP.V_rest(1); %Initial potential
%% Threshold potential V_th
NP.V_th = [-0.05,-0.05,-0.05]; %[V]
%% Hyperpolarization potential V_hyper
NP.V_hyper = [-0.065,-0.065,-0.065]; %[V]
%% Spike potential V_spike
NP.V_spike = [0.02,0.02,0.02]; %[V]
%% Injection current parameters -------------------------------------------
%% Synaptic conductance G_injection
NP.G_injection = [1.75e-9,1.75e-9,1.75e-9]; %[Siemens] the lower, the lower excitability
%% Excitatory synaptic battery
NP.V_injection_Ex = [0,0,0]; %[V]
%% Activation of synaptic conductance of the cell synapse for excitation
NP.A_injection_Ex = zeros(neuronNumber,preallocation);
%% Injection current excitatory
NP.I_injection_Ex = zeros(neuronNumber,preallocation); %[A]
%% Time constant for excitatory activation of synaptic conductance
NP.Tau_injection_Ex = [0.02,0.02,0.02]; %[s]
%% Inhibitory synaptic battery
NP.V_injection_In = [-0.08,-0.08,-0.08]; %[V]
%% Activation of synaptic conductance of the cell synapse for inhibition
NP.A_injection_In = zeros(neuronNumber,preallocation);
%% Time constant for inhibitory activation of synaptic conductance
NP.Tau_injection_In = [0.03,0.03,0.03]; %[s]
%% Injection current inhibitory
NP.I_injection_In = zeros(neuronNumber,preallocation); %[A]
%% Spontaneous firing rate activation
NP.A_spontaneous = [0,0,0.105];
%% Synaptic adaptation parameters -----------------------------------------
%% synaptic adaptation conductance change per activation
G_a = [0.25e-7,0.5e-7,1e-7,2e-7,4e-7];
NP.G_adaptation = [0,G_a(combination(1)),0]; %[Siemens]
%% adaptation conductance step
G_a_s = [0.01,0.05,0.1,0.2,0.5];
NP.G_adaptation_Step = [0,G_a_s(combination(2)),0];
%% spike rate adaptation activation
NP.A_adaptation = zeros(neuronNumber,preallocation);
%% spike rate adaptation activation power
A_a_p = [1,2,3,4,5];
NP.A_adaptation_P = [1,A_a_p(combination(3)),1];
%% adaptation battery for hyperpolarization
NP.V_adaptation = [0,-0.07,0]; %[V]
%% spike rate adaptation time constant
T_a = [0.05,0.1,0.2,0.3,0.5];
NP.Tau_adaptation = [9999999999,T_a(combination(4)),9999999999]; %[s], huge values for excitatory neurons which don't adapt
%% synaptic input current
NP.I_adaptation = zeros(neuronNumber,preallocation);
%% Leak parameters --------------------------------------------------------
%% Leak current
NP.I_leak = zeros(neuronNumber,preallocation); %[A]
%% Leak conductance
NP.G_leak = [5e-9,5e-9,5e-9]; %[Siemens]
%% spike events
NP.spike = zeros(neuronNumber,preallocation); %[Binary]

end