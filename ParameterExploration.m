function [data] = ParameterExploration(combination)

%% The simulation of the SNN using a given combination of parameters.

%% Simulation parameters --------------------------------------------------
% temporal resolution of simulation
dt = 0.001; %[s]
% duration of simulation
T = 2; % [s]
% steps of simulation
steps = T/dt;
% Setting up the neurons' parameters
[N,Populations,N_Indices] = Neuronator(steps,combination);
% Setting up the weights
[Weights,LNI,RNI] = Weighting(N_Indices,combination); %WeightMatrix,LeftNeuronIndices,RNI

% "World" settings
Agent.Centre = [zeros(1,steps);zeros(1,steps)]'; %Centrepoint of the Agent
Phi = zeros(1,steps);

% muscle activity
Agent.ForceLeft = zeros(1,steps);
Agent.ForceRight = Agent.ForceLeft;
Agent.MAL = zeros(1,steps); %MuscleActivationLeft
Agent.MAR = Agent.MAL; %MuscleActivationRight

% test
Agent.F = zeros(N_Indices(end),steps);
F = [0.25,0.5,0.75,1];
Agent.F(1,1:steps) = F(combination(9));
Agent.F(2,1:steps) = F(combination(10));
%% Simulation
for i = 1:steps
       
    %positions of the different parts of the agent
    [Agent.LeftEye(i,:), Agent.RightEye(i,:), Agent.LeftMotor(i,:), Agent.RightMotor(i,:)]...
        = Bodypositions(Agent.Centre(i,:), Phi(i));
    
    % give the visual input to the LAL-network
    N = NetworkStepper(N,N_Indices,i,dt,Agent.F(:,i),Weights);
    
    % give the LAL-output-neurons' to the "muscle neurons"
    [Agent.ForceLeft(i+1),Agent.MAL(i+1)] =...
        Accelerator(N.spike(RNI{end},i),Agent.ForceLeft(i),Agent.MAL(i));
    [Agent.ForceRight(i+1),Agent.MAR(i+1)] =...
        Accelerator(N.spike(LNI{end},i),Agent.ForceRight(i),Agent.MAR(i));
    
    % what is the new direction with which distance
    [Rotation(i), Distance(i)] =...
        ReactionApproach(Agent.ForceLeft(i), Agent.ForceRight(i));
    
    %Current angle (Phi) + NewAngle (Rotation) + Noise
    Phi(i+1) = Phi(i) + Rotation(i);
    
    Agent.Centre(i+1,:) = CentrePosition(Agent.Centre(i,:), Phi(i+1), Distance(i));
    
end

%% Data packing

data{1} = combination;
data{2} = Phi;
data{3} = Agent.Centre;
data{4} = N.spike;
data{5} = Distance;
data{6} = Agent.ForceLeft;
data{7} = Agent.ForceRight;

%% 
end