%% Calculation of bodyparts depending on a central position and its angle

function[LEP, REP, LMP, RMP] = Bodypositions(Body, Angle)

%LeftEye: 13.5 deg with length 0.0045m to the front left
LEP = [Body(1) + 0.0045*cos(Angle+0.075*pi),...
        Body(2) + 0.0045*sin(Angle+0.075*pi)];
%LeftEye: 13.5 deg with length 0.0045mm to the front right  
REP = [Body(1) + 0.0045*cos(Angle-0.075*pi),...
        Body(2) + 0.0045*sin(Angle-0.075*pi)];
%LeftMotor: 90 deg with length 0.0033 to the front left
LMP = [Body(1) + 0.0033*cos(Angle+(3/6)*pi),...
        Body(2) + 0.0033*sin(Angle+(3/6)*pi)];
%LeftMotor: 90 deg with length 0.0033 to the front right  
RMP = [Body(1) + 0.0033*cos(Angle-(3/6)*pi),...
        Body(2) + 0.0033*sin(Angle-(3/6)*pi)];

end