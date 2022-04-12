function[SDF] = sdfGauss(spikeTimes)
% SpikeTimes - list of spike times
% kernel - array containing the kernel values
% dt - time step

if sum(spikeTimes) == 0
    SDF = zeros(1,length(spikeTimes)); % return zeros if nothing happens
else
    dt = 1e-3; % temporal resolution
    %% Gaussian Kernel
    sigma = 0.05;
    mu = 0;
    resolution = dt;
    x = linspace(-1,1,2/resolution);
    kernelGauss = 1/(sigma*sqrt(2*pi))*exp(-0.5*((x-mu).^2/(sigma^2))); %Gaussian(x,mu,sigma);

    spk = (find(spikeTimes ~= 0)-1)*dt; %when do spikes occur

    start = 0;
    stop = spk(end);
    sz = length(start:dt:(stop+(length(kernelGauss)+1)*dt)); % length timeseries plus overreach from kernel

    s = zeros(sz,2); % final vector
    s(:,1) = reshape(start:dt:(stop+(length(kernelGauss)+1)*dt),size(s,1),1);
    kernelGauss = reshape(kernelGauss,length(kernelGauss),1);
    %% add the kernels to spike times
    for i = 1:length(spk)
        % spike position in original data
        pos = floor((spk(i))/dt)+1;
        % if the kernel does not fit in the front
        if pos <= floor(length(kernelGauss)/2)
            lBound = 1;
            uBound = pos + floor(length(kernelGauss)/2);
            s(lBound:uBound,2) =...
                s(lBound:uBound,2) +...
                kernelGauss(end - length(1:uBound) + 1:end);
        else
            lBound = pos - floor(length(kernelGauss)/2) + 1;
            uBound = pos + floor(length(kernelGauss)/2);
            s(lBound:uBound,2) =...
                s(lBound:uBound,2) + kernelGauss;
        end
    end
    %% clean up
    SDF = s(:,2)';
    if length(SDF) < length(spikeTimes)
        SDF(length(SDF):length(spikeTimes)) = 0;
    elseif length(SDF) > length(spikeTimes)
        SDF = SDF(1:length(spikeTimes));
    end
end

end
