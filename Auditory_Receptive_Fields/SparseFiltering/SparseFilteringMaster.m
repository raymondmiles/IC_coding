clear all, clc, close all
addpath '\\icnas2.cc.ic.ac.uk\rcm17\Desktop\FYPSparse'

%addpath 'C:\Users\User\Desktop\FYP\Code\DATA_Spikes'
%addpath 'C:\Users\User\Desktop\FYP\Code\RaymondCode'
%addpath 'C:\Users\User\Desktop\FYP\Code\SparseFiltering'
%addpath 'C:\Users\User\Desktop\FYP\Code\SparseFiltering\minFunc_2012_rememberCitation\minFunc_2012\minFunc'
%addpath 'C:\Users\User\Desktop\FYP\Code\SparseFiltering\minFunc_2012_rememberCitation\minFunc_2012\minFunc\mex'
load '20170324_loc1_trode6_unit1' 

fileName = spkdata.original_filename
Stimulus1 = spkdata.sets(1).stimulus.values; % Audio File?
%Stimulus2 = spkdata.sets(2).stimulus.values; % some files don't have a
%second stimulus??

Sweeps1 = spkdata.sets(1).sweeps; % a cell array
%Sweeps2 = spkdata.sets(2).sweeps;
Fs =250000;
%Period = 1./freq

%% Spectrogram for the whole duration
duration = size(Stimulus1,1)/Fs

%duration = 211.2005; % Duration in seconds
[spec, f, t, p] = GetSpec(Stimulus1, 250000, 128, duration, 0);%GetSpec(signal, fs, nfft, duration , startTime)
%surf(t,f,10*log10(abs(p)),'EdgeColor','none');

%%
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
%% Examples Extraction
% columns = Examples
%row = features
numExamples = 1104; %1587;
exampleSizeTime = 23;%16;
smallerSpectrogramSmol = [];
counter = 1;

for i = 1:1:numExamples
    
example = smallerSpectrogram(:,counter:1:exampleSizeTime*i);
%size(example);

example = reshape(example, 1, []);

smallerSpectrogramSmol = [smallerSpectrogramSmol; (example)];% - mean(example))];
counter = exampleSizeTime*i+1;

example = [];
end
%
%save('Spectrogram.mat', 'spectrogramFriend')
% Mdl = sparsefilt(spectrogramFriend', 10) doesnt work since we have the
% sparse filtering from Ngiam

%% Example Observation
smallerSpectrogramSmol = smallerSpectrogramSmol'
for j = 10:10:100
%rng('default') % For reproducibility
numrows = size(smallerSpectrogramSmol',1);
ims = randi(numrows,4,1);
imgs = smallerSpectrogramSmol(ims,:);
for i = 1:4
    pp{i} = mat2gray(reshape(imgs(i,:),23,23));
end

ppf = [pp{1},pp{2};pp{3},pp{4}];

figure(j)
imshow(ppf,'InitialMagnification',300);
colorbar

end
%% Remove DC component per example
firstOne = smallerSpectrogramSmol ; %smallerSpectrogramSmol;
q = 64;

optW = sparsefilt(firstOne, q,'IterationLimit',1000,'Standardize', true); 
% We can run this again with: optW = sparsefilt(firstOne', q,'IterationLimit',90000, 'InitialTransformWeights',optW); 

%Undefined function 'lbfgsAddC' for input arguments of type 'int32'.
display(size(optW.TransformWeights));
%%
optW2 = sparsefilt(firstOne, q,'IterationLimit',100, 'InitialTransformWeights',optW.TransformWeights); 

%%

transformWeightsInit =optW2.TransformWeights();

transformWeights = reshape(transformWeightsInit, [23, 23, 1, q]);%[23, 16, 3, q]); %23 23 
W =transformWeights;
size(transformWeights);
%% % reshape(wts,[6,6,3,q]);
colorman = 1
[dx,dy,~,~] = size(W);
for f = 1:q
    Wvec = W(:,:,:,f);
    Wvec = Wvec(:);
    Wvec =(Wvec - min(Wvec))/(max(Wvec) - min(Wvec));
    W(:,:,:,f) = reshape(Wvec,dx,dy,colorman);
end
m   = ceil(sqrt(q));
n   = m;
img = zeros(m*dx,n*dy,colorman);
f   = 1;
for i = 1:m
    for j = 1:n
        if (f <= q)
            img((i-1)*dx+1:i*dx,(j-1)*dy+1:j*dy,:) = W(:,:,:,f);
            f = f+1;
        end
    end
end
colormap(parula)
%%
colormap parula
imagesc(img)%,'InitialMagnification',300)
%imshow(img,'InitialMagnification',300);
colorbar

%%
colormap default
geaImg = rgb2gray(img)
imshow(geaImg)
%%

clear fileName
clear spkdata
clear Stimulus1
clear Sweeps1
load '20170324_loc1_trode4_unit1' 
 
fileName = spkdata.original_filename
Stimulus1 = spkdata.sets(1).stimulus.values; % Audio File?
%Stimulus2 = spkdata.sets(2).stimulus.values; % some files don't have a
%second stimulus??

Sweeps1 = spkdata.sets(1).sweeps; % a cell array
%Sweeps2 = spkdata.sets(2).sweeps;

%%

 function [s,parameters]=calculate_spectrogram(values, fs, parameters,logarithmic)

  %if nargin<4,normalise=true;end
  if nargin<4,logarithmic=false;end

  stimulusDuration=numel(values)/fs;
  parameters.derived.binsize=parameters.binsize;
  totalNumberOfTimeBins=round(stimulusDuration/parameters.derived.binsize);
  
  if logarithmic
    if parameters.addLFbin
      f=cat(2,parameters.LFbinFreq,logspace(...
        log10(parameters.minSpectrogramFrequency),...
        log10(parameters.maxSpectrogramFrequency),...
        parameters.numberOfFrequencyBins-1));
    else
      f_low=logspace(...
        log10(parameters.minSpectrogramFrequency),...
        log10(parameters.HFcutfreq),...
        parameters.nLFbins);
      f_high=logspace(...
        log10(parameters.HFcutfreq),...
        log10(parameters.maxSpectrogramFrequency),...
        parameters.nHFbins);
      f = cat(2, f_low, f_high);
    end
  else
     if parameters.addLFbin
      f=cat(2,parameters.LFbinFreq,linspace(...
        parameters.minSpectrogramFrequency,...
        parameters.maxSpectrogramFrequency,...
        parameters.numberOfFrequencyBins-1));
    else
      f=linspace(...
        parameters.minSpectrogramFrequency,...
        parameters.maxSpectrogramFrequency,...
        parameters.numberOfFrequencyBins);
    end
  end
  
  nfft=parameters.nfft;
  [s,f,t]=spectrogram(values,hamming(nfft),nfft*0.5,f,fs);
  
  epsilon=1e-6;
  s=imresize(log10(max(abs(s),epsilon)),...
    [parameters.numberOfFrequencyBins,totalNumberOfTimeBins],'bicubic');
  t=linspace(t(1),t(end),totalNumberOfTimeBins);
  
  parameters.derived.time=t;
  parameters.derived.freqs=f;

  % Normalise the spectrogram
  % if normalise, s=(s-mean(s(:)))/std(s(:)); end
end