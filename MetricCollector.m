function[NoS,MAC,SAC,MLD,SLD,MSL,SSL,F2LA,TA] =...
    MetricCollector(data,coeff1,coeff2)

% calculating the switches, then analysing them with the Curviness.m

% looking at the heading-angle change over time, if it approaches zero, it
% switches from left to right turn or vice versa
CoPhi = diff(data{1,2}); %Change of Phi
CoPhiLP = filter(coeff1,coeff2,CoPhi); %average filtering

% adjust the fluctuations around zero
CoPhiAd = CoPhiLP;
CoPhiAd(CoPhiLP < 1e-3 & CoPhiLP >= -1e-3) = 0;

IoS = find_zeroos(CoPhiAd); % switches between left/right turning

% Calculate the curviness of the trajectory between switches
[MAC,SAC,MLD,SLD,MSL,SSL,F2LA,TA] = Curviness(data,IoS);
% Number of Switches
NoS = length(IoS);

end