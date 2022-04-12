function [MAC,SAC,MLD,SLD,MSL,SSL,F2LA,TA] = Curviness(data,IoS)
% to get a measure of how curvy the trajectory is, we look at the intervals
% between heading switches. there, we calculate the distance of every point
% within these intervals to the line, which connects the switching points.
% we use the formula d = norm(cross product(directionalVector X
% (intervalpoint - switchpoint))/(norm(directionalVector))
% outputs:
% MAC = Mean Angular change between the segments
% SAC = STD of the angular change
% MLD = Length difference between sigmoid and segmental lengths
% SLD = STD
% F2LA = first 2 last switch angle
% TA = trajectory angle, [0,0] to last recorded position
% MSL = Median switch segment length
% SSL = STD

% preallocations
SV = zeros(3,length(IoS)-1);% z for crossproduct
SVA = zeros(1,length(IoS)-1);
SVL = zeros(1,length(IoS)-1);
% AV = zeros(1,length(IoS)-1);
ML = zeros(1,length(IoS)-1);
%%
if isempty(IoS)
    MAC = NaN;
    SAC = NaN;
    MLD = NaN;
    SLD = NaN;
    F2LA = NaN;
    % trajectory angle
    y = data{1,3}(end,2) - data{1,3}(1,2);
    x = data{1,3}(end,1) - data{1,3}(1,1);
    TA = atan2(y,x);
    MSL = NaN;
    SSL = NaN;
elseif length(IoS) > 2
%     C = 1; % countervariable for all calculated distances
    % calculate the distance of points to the lines connecting switch points
    for i = 1:length(IoS)-1
        % switch vectors: between switch-points
        SV(1,i) = data{1,3}(IoS(i+1),1) - data{1,3}(IoS(i),1); %x
        SV(2,i) = data{1,3}(IoS(i+1),2) - data{1,3}(IoS(i),2); %y

        % Switch vector angle: angle of the current segment
        SVA(i) = atan2(SV(2,i),SV(1,i));
        
       	% length of SVs
        SVL(i) = norm(SV(:,i));
%         % loop through all points regarding this segment to calculate the
%         % "area"
%         c = 1; %another counter variable for each segment
%         for ii = IoS(i)+1:IoS(i+1)-1
%             % distance of a point from the line-point (former switch)
%             D = data{1,3}(ii,:) - data{1,3}(IoS(i),:);
%             D(3) = 0; % for cross product
%             % Cross product
%             CP = cross(SV(:,i),D);
%             % norm of CP
%             NCP = norm(CP);
%             % distance of the point to the line
%             d(c) = NCP/SVL(i);
%             AD(C) = d(c);
%             c = c + 1;
%             C = C + 1;
%         end
%         %area under curve
%         AV(i) = sum(d)/length(d);
%         clear d
        
        % the length between intersegment points        
        ML(i) = sum(data{1,5}(IoS(i):IoS(i+1)));
                
    end

    %% first to last switch angle
    F2E(1) = data{1,3}(IoS(end),1) - data{1,3}(IoS(1),1);
    F2E(2) = data{1,3}(IoS(end),2) - data{1,3}(IoS(1),2);

    F2LA = atan2(F2E(2),F2E(1));
    
    %% trajectory angle
    y = data{1,3}(end,2) - data{1,3}(1,2);
    x = data{1,3}(end,1) - data{1,3}(1,1);
    TA = atan2(y,x);
    
    %% what's the median angular change between segments
    AC = Orienter(SVA);
    MAC = median(AC);
    SAC = std(AC);

    %% Median Length difference curve vs straight
    MLD = median(ML - SVL);
    SLD = std(ML - SVL);
    
    %% Median switch segment lengths
    MSL = median(SVL);
    SSL = std(SVL);
    
    %%
    %TestPlotter(data,AC,MAC,MLD,F2LA,SSL,length(IoS),IoS)
    
else
    MAC = NaN;
    SAC = NaN;
    MLD = NaN;
    SLD = NaN;
    F2LA = NaN;
    % trajectory angle
    y = data{1,3}(end,2) - data{1,3}(1,2);
    x = data{1,3}(end,1) - data{1,3}(1,1);
    TA = atan2(y,x);
    MSL = NaN;
    SSL = NaN;
end

end