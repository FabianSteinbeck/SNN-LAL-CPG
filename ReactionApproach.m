function [NewPhi,Distance] = ReactionApproach(LI,RI)
% the intensities of left and right will result in 2 parts:
% 1. the relative difference between the both of them, leading to a
% rotation
% 2. the amount that is left, which will propulse the vehicle
% This is the reaction for the approach vehicle: LeftEye activates
% RightMotor, RightEye activates LeftMotor

%MaximumVelocity
MaxVel = 0.3; % [0.3 m/s -> 0.3mm/ms]
r = 0.0033; %~radius for the rotation in Melophorus bagoti
% rotation gain
RG = pi/180; % conversion deg -->rad

RotationPart = abs(LI - RI);
PropulsionPart = max([LI,RI]) - RotationPart;

if LI > RI %right turns mean negative radians
    % Rotation movement: W= velocity/radius
    NewPhi = RG*-RotationPart/r;
elseif LI == RI %no turn
    NewPhi = 0;
elseif LI < RI %left turns mean positive radians
    NewPhi = RG*RotationPart/r;
end

% Distance = 0.1;
Distance = PropulsionPart*MaxVel;

end