function [barChartCentresTime,Counts] = PSTHRay(nbins,concatenatedSpikes)
%function [barChartCentresTime,Counts] = PSTHRay(nbins,concatenatedSpikes)
% PSTH function that plots the peristimulus time histogram of the spikecounts
% obtained from RasterPlotRay
%   nbins = number of bins in the histogram. concatenatedSpikes =
%   the cell matrix obtained by RasterPlotRay

barChartCentres = [];
Num = zeros(1,nbins)

for i = 1:1:length(concatenatedSpikes)
[N, edges] = histcounts(cell2mat(concatenatedSpikes(i)),nbins);
Num = Num + N
end

for i = 1:1:length(edges)-1
    barChartCentres = [barChartCentres (edges(i)+ edges(i+1))/2]
end

h = bar(barChartCentres,Num );
 ylabel('Spikes/Bin'); % xlabel('Time');

barChartCentresTime = barChartCentres;
Counts = Num;
end

