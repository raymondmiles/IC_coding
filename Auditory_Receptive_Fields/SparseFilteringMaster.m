clear all, clc, close all
addpath 'C:\Users\User\Desktop\FYP\Code\DATA_Spikes'
addpath 'C:/Users/User/Desktop/FYP/Code/DATA_Spikes/INPUTFILES/' 
addpath 'C:\Users\User\Desktop\FYP\Code\RaymondCode'
%addpath 'C:\Users\User\Desktop\FYP\Code\SparseFiltering'
%addpath 'C:\Users\User\Desktop\FYP\Code\SparseFiltering\minFunc_2012_rememberCitation\minFunc_2012\minFunc'
%addpath 'C:\Users\User\Desktop\FYP\Code\SparseFiltering\minFunc_2012_rememberCitation\minFunc_2012\minFunc\mex'
load '20171002_loc1_trode5_unit1' 

fileName = spkdata.original_filename
Stimulus1 = spkdata.sets(1).stimulus.values; % Audio File?
%Stimulus2 = spkdata.sets(2).stimulus.values; % some files don't have a
%second stimulus??

Sweeps1 = spkdata.sets(1).sweeps; % a cell array
%Sweeps2 = spkdata.sets(2).sweeps;
freq = 30025000/120 % the signal lasts for 120 seconds


%% Spectrogram for the first 120Second
duration = 211.2005; % Duration in seconds
[spec, f, t, p] = GetSpec(Stimulus1, 250000, 128, duration,0, 0);%GetSpec(signal, fs, nfft, duration , startTime)
%surf(t,f,10*log10(abs(p)),'EdgeColor','none');
%%
spectrogramFriend = 10*log10(abs(p));
figure(2)
surf(t,f,spectrogramFriend,'EdgeColor','none');
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time (secs)');
colorbar;
ylabel('Frequency(HZ)');


%%


%%
size(t)
size(f)
size(spectrogramFriend)

%% Remove Mice Inaudible Frequencies less than 1KHz and above 91KHz
audibleFrequencies = f>1000&f<91000;
spectrogramFriend = spectrogramFriend(audibleFrequencies,:);
f = f(audibleFrequencies)%./1000;

figure(3)
surf(t,f,spectrogramFriend,'EdgeColor','none');
axis xy; axis tight;  view(0,90);
xlabel('Time (secs)');
colorbar;
ylabel('Frequency(KHz)');

%%
imagesc('XData',t,'YData',f,'CData',spectrogramFriend);
colorbar



%% Stimulus features

resisedImaged = imresize(spectrogramFriend, 'Scale', [0.5 0.03125] );
smallerSpectrogram = resisedImaged;

%% Examples Extraction
% columns = Examples
%row = features
numExamples = 1104;
exampleSizeTime = 16;
smallerSpectrogramSmol = [];
counter = 1;

for i = 1:1:numExamples
    
example = smallerSpectrogram(:,counter:1:exampleSizeTime*i-1);
size(example);

example = reshape(example, 1, []);
smallerSpectrogramSmol = [smallerSpectrogramSmol; (example - mean(example))];
counter = exampleSizeTime*i+1;
example = [];
end
%
%save('Spectrogram.mat', 'spectrogramFriend')
% Mdl = sparsefilt(spectrogramFriend', 10) doesnt work since we have the
% sparse filtering from Ngiam


%% Remove DC component per example
firstOne = smallerSpectrogramSmol ; %smallerSpectrogramSmol;
q = 64;

optW = sparsefilt(firstOne', q,'IterationLimit',1000,'Standardize', true); 
% We can run this again with: optW = sparsefilt(firstOne', q,'IterationLimit',90000, 'InitialTransformWeights',optW); 

%Undefined function 'lbfgsAddC' for input arguments of type 'int32'.
display(size(optW.TransformWeights));

%%

transformWeightsInit =optW.TransformWeights;

transformWeights = reshape(transformWeightsInit, [23, 16, 3, q]);
W =transformWeights;
size(transformWeights);
%% % reshape(wts,[6,6,3,q]);
[dx,dy,~,~] = size(W);
for f = 1:q
    Wvec = W(:,:,:,f);
    Wvec = Wvec(:);
    Wvec =(Wvec - min(Wvec))/(max(Wvec) - min(Wvec));
    W(:,:,:,f) = reshape(Wvec,dx,dy,3);
end
m   = ceil(sqrt(q));
n   = m;
img = zeros(m*dx,n*dy,3);
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

%imagesc(img)
imshow(img,'InitialMagnification',300);
colorbar
 %%



optW = SparseFiltering(30, X(:)); 
imagesc(optW)
%c = 'turbo';
%colormap(c);
colorbar

%%
optW = SparseFiltering(30, matrixOfColumns); 
%Undefined function 'lbfgsAddC' for input arguments of type 'int32'.


%optW = SparseFiltering(5, spec(:,1:65))
% Undefined function or variable 'lbfgsAddC'.

%run on spectrogram
imagesc(optW)
%c = 'turbo';
%colormap(c);
colorbar
%%

optW = l2row(optW)

imagesc(optW)


%c = 'turbo';
%colormap(c);

colorbar

%%

optW =l2grad(optW)

imagesc(optW)


%c = 'turbo';
%colormap(c);

colorbar
%%
function [Y,N] = l2row(X) % L2 Normalize X by rows
% We also use this to normalize by column with l2row(X')
N = sqrt(sum(X.^2,2) + 1e-8);
Y = bsxfun(@rdivide,X,N);
end
%%
function [G] = l2grad(X,Y,N,D) % Backpropagate through Normalization
G = bsxfun(@rdivide, D, N) - bsxfun(@times, Y, sum(D.*X, 2) ./ (N.^2));
end













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