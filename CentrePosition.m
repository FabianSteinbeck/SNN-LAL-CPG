function[BC] = CentrePosition(Pos, Phi, D)

% Updating Bodycentre from previous pos based on Distance and angle

BC = [Pos(1) + D*cos(Phi),...
      Pos(2) + D*sin(Phi)];

end