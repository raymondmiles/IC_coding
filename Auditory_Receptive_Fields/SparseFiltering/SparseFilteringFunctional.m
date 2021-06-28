function [outputArg1,outputArg2] = SparseFilteringSpectrogram(spec, f, t, p, audibleFrequencies)
%function [outputArg1,outputArg2] = SparseFilteringFunctional(spkdata,GetSpec,duration)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

fileName = spkdata.original_filename
Stimulus1 = spkdata.sets(1).stimulus.values; % Audio File?
%Stimulus2 = spkdata.sets(2).stimulus.values; % some files don't have a%second stimulus??
Sweeps1 = spkdata.sets(1).sweeps; % a cell array
Fs =250000;

[spec, f, t, p] = GetSpec(Stimulus1, 250000, 128, duration, 0);%GetSpec(signal, fs, nfft, duration , startTime)






spectrogramFriend = 10*log10(abs(p));
if(sum(isnan(spectrogramFriend),'all')~= 0)
    fig = uifigure;
    uialert(fig, "we have detected a NaN")
end
figure(2)
surf(t,f,spectrogramFriend,'EdgeColor','none');
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time (secs)');
colorbar;
ylabel('Frequency(HZ)');
%%
disp(size(t)); disp(size(f));disp(size(spectrogramFriend));

%% Remove Mice Inaudible Frequencies less than 1KHz and above 91KHz
audibleFrequencies = f>1100&f<91000;
spectrogramFriend = spectrogramFriend(audibleFrequencies,:);
f = f(audibleFrequencies)./1000; %Divide by 1000 to get values in kHz
% 
% figure(3)
% surf(t,f,spectrogramFriend,'EdgeColor','none');
% axis xy; axis tight;  view(0,90);
% xlabel('Time (secs)');
% colorbar;
% ylabel('Frequency(KHz)');
%figure;imagesc('XData',t,'YData',f,'CData',spectrogramFriend);colorbar



%% Resize 
frequecyResised = 1/2;
timeResised = 1/16;

resisedImage = imresize(spectrogramFriend, 'Scale', [frequecyResised timeResised] );
smallerSpectrogram = resisedImage;
%imagesc(smallerSpectrogram)





outputArg1 = spec;
outputArg2 = f;
end

