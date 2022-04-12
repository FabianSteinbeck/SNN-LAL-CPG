function[a, A_injectionE] = Accelerator(ExInput, a, A_injectionE)

%%
% model the behaviour of a muscle generating force[acceleration(a)] with a
% leaky, integrate and not fire neuron
% ExInput = spikes from the LAL-output neurons
% a = acceleration [Voltage]
% A_injection = activation of the "muscles"

%% behaviour variables
% membrane conductance: excitability of the neuron
C_m = 3e-7; %[Farad]
% synaptic conductance
G_injection = 1e-5; %[Siemens]
% maximum radial velocity [deg/sec]
a_injection_Ex = 0.025*1.8; %[deg/msec]
% time constant for A_synaptic excitatory
Tau_injection_Ex = 0.012; %[s]
dt = 0.001;

% Leak conductance
G_leak= 5e-6; %[Siemens]
% Resting potential
a_rest = 0; %[deg/sec]

%%
A_injectionE = A_injectionE + ExInput;
I_injectionE  = G_injection*A_injectionE*(a_injection_Ex - a);
I_leak = G_leak*(a_rest - a);

% voltage change ------------------------------------------------------
da= (dt/C_m)*(I_leak + I_injectionE);

% new voltage
a = a + da;

% synaptic activation variable A_injection: decay excitatory
dA_syn = -(dt/Tau_injection_Ex)*A_injectionE;
A_injectionE = A_injectionE + dA_syn;

end