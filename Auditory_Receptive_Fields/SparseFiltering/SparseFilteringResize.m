function [smallerSpectrogram, fResized] = SparseFilteringResize(spectrogram, audibleFrequenciesBounduary, f, resizeFactFreq, resizeFactTime )
%function [smallerSpectrogram, fResized] = SparseFilteringResize(spectrogram, audibleFrequenciesBounduary, f, resizeFactFreq, resizeFactTime )
%Remove inaudible frequencies that are ouside audibleFrequencies (1) and (2)
%Resizes by resizeFactFreq and resizeFactTime 
% Remove Mice Inaudible Frequencies less than 1KHz and above 91KHz
audibleFrequencies = f>audibleFrequenciesBounduary(1)&f<audibleFrequenciesBounduary(2);
spectrogramFriend = spectrogram(audibleFrequencies,:);
%fResized = f(audibleFrequencies)./1000; %Divide by 1000 to get values in kHz
%Resize 
smallerSpectrogram = imresize(spectrogramFriend, 'Scale', [resizeFactFreq resizeFactTime] );
fResized = size(smallerSpectrogram,1);
end

