function [concatenatedSpikes] = RasterPlotRay(timeStart, timeEnd, Sweeps)
% function [concatenatedSpikes] = RasterPlotRay(timeStart, timeEnd, Sweeps)
%Raster Plot function. Plots the raster plot and returns the
%concatenatedSpikes to be used in the PSTHRay function.
%   timeStart and timeEnd define the time period to plot. Sweeps contains
%   the neuronal spiking data to plot.
%    When timeEnd = 0 the whole data is plotted and when timeEnd != 0
%   then its for the time period between timeStart and timeEnd.
hold on
concatenatedSpikes = {};
if timeEnd == 0
    for i = 1:1:length(Sweeps)
    FirstSweep = cell2mat(Sweeps(i));
    yspikes = ones(size(FirstSweep));
    yspikes(1:1:end) = i;
    plot(FirstSweep', yspikes', 'k.');
       ylabel('Neuronal unit'); %xlabel('Time (ms)'); 
    concatenatedSpikes = [concatenatedSpikes, Sweeps(i)];
    end

elseif timeEnd ~= 0 
    for i = 1:1:length(Sweeps)
    FirstSweep = cell2mat(Sweeps(i));
    [index, ~] = find((timeStart <FirstSweep ) & (FirstSweep<timeEnd) );
    yspikes = ones(size(FirstSweep(index)));
    yspikes(1:1:end) = i;
    plot(FirstSweep(index)', yspikes', 'r.');
     ylabel('Neuronal unit'); % xlabel('Time (ms)');
    end
end
end

