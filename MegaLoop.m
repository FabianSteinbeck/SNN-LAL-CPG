function[] = MegaLoop(I,II)

%% For the extensive parameter exploration of the SNN. The inputs only complete the following combinations
% so that many scripts can be run in parallel on a HPC.

% I = G_adaptation
% II = G_adaptation_step
%% preallocations for analysis
MAC = NaN(1,78125);
SAC = NaN(1,78125);
MLD = NaN(1,78125);
SLD = NaN(1,78125);
F2LA = NaN(1,78125);
TA = NaN(1,78125);
MSL = NaN(1,78125);
SSL = NaN(1,78125);
NoS = NaN(1,78125);
t = 1; %countervariable for each analysis step

% moving average filter
window = 75;
coeff1 = ones(1,window)/window;
coeff2 = 1;

%% run the exploration
% each loop runs through one parameter and sets a different one out of a range of parameters
for III = 1:5 %Adaptation_activation_power
for IV = 1:5 %Tau_adaptation
for V = 1:5 %Weight 1
for VI = 1:5 %Weight 2
for VII = 1:5 %Weight 3
for VIII =  1:5 %Weight 4
    current_data = cell(1,5);
    c = 1; %counter variable for each batch of exportable data
    CPG = 0; %countervariable if CPG spiked
for IX = 1:4 %Inputs left
    if IX == 4 % inputs right
        for X = [1,4] %run an additional full left input
            Iteration = [I,...
                         II,...
                         III,...
                         IV,...
                         V,...
                         VI,...
                         VII,...
                         VIII,...
                         IX,...
                         X];
            % simulation
            current_data{c} =...
            ParameterExploration(Iteration); % rows:left,columns:right
            % analysis
            if X == IX && sum(current_data{c}{1,4}(3,:)) < 2 && sum(current_data{c}{1,4}(4,:)) < 2
                NoS(t) = NaN; MAC(t) = NaN; SAC(t) = NaN; MLD(t) = NaN;...
                SLD(t) = NaN; MSL(t) = NaN; SSL(t) = NaN; F2LA(t) = NaN; TA(t) = NaN;
            elseif X == IX && (sum(current_data{c}{1,4}(5,:)) > 120 || sum(current_data{c}{1,4}(6,:)) > 120)
                NoS(t) = NaN; MAC(t) = NaN; SAC(t) = NaN; MLD(t) = NaN;...
                SLD(t) = NaN; MSL(t) = NaN; SSL(t) = NaN; F2LA(t) = NaN; TA(t) = NaN;
            else
                [NoS(t),MAC(t),SAC(t),MLD(t),SLD(t),MSL(t),SSL(t),F2LA(t),TA(t)] =...
                MetricCollector(current_data{c},coeff1,coeff2);
                CPG = CPG + 1;
            end
            c = c + 1;
            t = t + 1;
        end
    else
        X = IX; % test only symmetric inputs
        Iteration = [I,...
                     II,...
                     III,...
                     IV,...
                     V,...
                     VI,...
                     VII,...
                     VIII,...
                     IX,...
                     X];
        % simulation
        current_data{c} =...
        ParameterExploration(Iteration); % rows:left,columns:right
        % analysis
        if sum(current_data{c}{1,4}(3,:)) < 2 && sum(current_data{c}{1,4}(4,:)) < 2
            NoS(t) = NaN; MAC(t) = NaN; SAC(t) = NaN; MLD(t) = NaN;...
            SLD(t) = NaN; MSL(t) = NaN; SSL(t) = NaN; F2LA(t) = NaN; TA(t) = NaN;  
        elseif sum(current_data{c}{1,4}(5,:)) > 120 || sum(current_data{c}{1,4}(6,:)) > 120
            NoS(t) = NaN; MAC(t) = NaN; SAC(t) = NaN; MLD(t) = NaN;...
            SLD(t) = NaN; MSL(t) = NaN; SSL(t) = NaN; F2LA(t) = NaN; TA(t) = NaN;
        else
            [NoS(t),MAC(t),SAC(t),MLD(t),SLD(t),MSL(t),SSL(t),F2LA(t),TA(t)] =...
            MetricCollector(current_data{c},coeff1,coeff2);
            CPG = CPG + 1;
        end
        c = c + 1;
        t = t + 1;
	end
end
if CPG >= 4 % only save data if the CPG spiked in at least 4 of the batch
    % export data
    filename = strcat('Combination',num2str(Iteration(1:8)),'.mat');
    filename = filename(~isspace(filename));
    save(filename, 'current_data')
else % otherwise make it 0
    filename = strcat('Combination',num2str(Iteration(1:8)),'.mat');
    filename = filename(~isspace(filename));
    current_data = Iteration(1:8);
    save(filename, 'current_data')
end
clear current_data
end
end
end
end
end
end

%% export the analysis data
NoS = reshape(NoS,[5,5^6]);
MAC = reshape(MAC,[5,5^6]);
SAC = reshape(SAC,[5,5^6]);
MLD = reshape(MLD,[5,5^6]);
SLD = reshape(SLD,[5,5^6]);
MSL = reshape(MSL,[5,5^6]);
SSL = reshape(SSL,[5,5^6]);
F2LA = reshape(F2LA,[5,5^6]);
TA = reshape(TA,[5,5^6]);

save(strcat('MedianAngularChange',num2str(I),num2str(II),'.mat'), 'MAC')
save(strcat('STDAngularChange',num2str(I),num2str(II),'.mat'), 'SAC')
save(strcat('MedianLengthDifference',num2str(I),num2str(II),'.mat'), 'MLD')
save(strcat('STDLengthDifference',num2str(I),num2str(II),'.mat'), 'SLD')
save(strcat('First2Last',num2str(I),num2str(II),'.mat'), 'F2LA')
save(strcat('TrajectoryAngle',num2str(I),num2str(II),'.mat'), 'TA')
save(strcat('MedianSwitchSegmentLength',num2str(I),num2str(II),'.mat'), 'MSL')
save(strcat('STDSwitchSegmentLength',num2str(I),num2str(II),'.mat'), 'SSL')
save(strcat('Switches',num2str(I),num2str(II),'.mat'), 'NoS')

%%
disp('This exploration has executed successfully!')
end