function [spectrogramFriend,f, t, p] = SparseFilteringSpectrogram(Stimulus1, nfft,  duration, start, plotSpec)
%function [outputArg1,outputArg2] = SparseFilteringFunctional(spkdata,GetSpec,duration, plotSpec)
%SparseFilteringSpectrogram leverages GetSpec and Matlab's Spectrogram to 
%extract he spectrogram of the audiofile and remove any NaN present
%plotSpec Allows to plot spectrogram if = 1

%Stimulus1 = spkdata.sets(1).stimulus.values; 

Fs =250000;
[~, f, t, p] = GetSpec(Stimulus1, 250000, nfft, duration, start,plotSpec);%GetSpec(signal, fs, nfft, duration , startTime)
spectrogramFriend = 10*log10(abs(p));
if(sum(isnan(spectrogramFriend),'all')~= 0)
    %fig = uifigure;
    %uialert(fig, "we have detected a NaN")
    spectrogramFriend(isnan(spectrogramFriend)) = 0.000001;
end
end

