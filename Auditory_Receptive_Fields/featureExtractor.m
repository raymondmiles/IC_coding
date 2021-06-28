function [optW2,transformWeights, img, spectrogramPatches] = featureExtractor(outPutFile, varNameNumBoss, soundOrigin, nfft, start, resizeFactFreq, resizeFactTime, exampleSizeTime, numExamples, saveImages, q, Location, iterationNum)
%function [optW2,transformWeights, img] = featureExtractor(outPutFile, varNameNum, soundOrigin, nfft, start, resizeFactFreq, resizeFactTime, exampleSizeTime, numExamples, saveImages, q, Location, iterationNum)
% this function returns optW2 that is the sparse filtered model, the
% transform weights from the same model and the img patches that correspond
% to the sparsefiltered features
% soundOrigin = 1 for USV and = 2 for Starling
%Fs = 250000; nfft = 128;%start = 0;%resizeFactFreq = 1/2;%resizeFactTime = 1/8;
%exampleSizeTime = 64;%4 is around 30ms 8 is around 60ms 16 is around 120ms and 24 is around 200ms 
%numExamples = 1104; %1587;%saveImages = 0; %q = 64; %number of features to extract
%Location = 'C:\Users\User\Desktop\FYP\';
%G = sprintf(outPutFile, '.mat');
%save(fullfile(Location,G), 'img');

addpath 'C:\Users\User\Desktop\FYP\FYPSparse\FYPSparse 31.5\FYPSparse';
addpath 'C:\Users\User\Desktop\FYP\Code\DATA_Spikes';
addpath 'C:\Users\User\Desktop\FYP\Code\RaymondCode';

load(varNameNumBoss)
if size(spkdata.sets,2)==2
Stimulus = spkdata.sets(soundOrigin).stimulus.values; 
else
    Stimulus = spkdata.sets(1).stimulus.values; 
   
end
Fs = 250000;
audibleFrequenciesBounduary = [2200 89000];
duration = size(Stimulus,1)/Fs;
% Spectrogram for the whole duration
[spectrogramFriend,f, ~, ~] = SparseFilteringSpectrogram(Stimulus, nfft,  duration, start, 0);
[smallerSpectrogram, fResized] = SparseFilteringResize(spectrogramFriend, audibleFrequenciesBounduary, f, resizeFactFreq, resizeFactTime);
[spectrogramPatches] = SparseFilteringPatches(smallerSpectrogram,exampleSizeTime, numExamples, saveImages);
InputMan = normalize(spectrogramPatches);
optW2 = sparsefilt(InputMan', q,'IterationLimit',iterationNum,'Standardize', true); 
%optW2 = sparsefilt(spectrogramPatches', q,'IterationLimit',iterationNum, 'InitialTransformWeights',optW.TransformWeights); 
transformWeightsInit =optW2.TransformWeights();
transformWeights = reshape(transformWeightsInit, [fResized, exampleSizeTime, 1, q]);

colorman = 1;
[dx,dy,~,~] = size(transformWeights);
for f = 1:q
    Wvec = transformWeights(:,:,:,f);
    Wvec = Wvec(:);
    Wvec =(Wvec - min(Wvec))/(max(Wvec) - min(Wvec));
    transformWeights(:,:,:,f) = reshape(Wvec,dx,dy,colorman);
end
m   = ceil(sqrt(q)); n   = m; img = zeros(m*dx,n*dy,colorman); f   = 1;
for i = 1:m
    for j = 1:n
        if (f <= q)
            img((i-1)*dx+1:i*dx,(j-1)*dy+1:j*dy,:) = transformWeights(:,:,:,f);
            f = f+1;
        end
    end
end

%figure(999);colormap parula; imagesc(img); colorbar;
G = sprintf(outPutFile, '.mat');
abbacus = struct('sparseFiltImg',img,'origin',soundOrigin);
fullfile(Location,G);
save(fullfile(Location,G),'-struct', 'abbacus');

X = ['Original Dimensions Spec ', num2str(size(spectrogramFriend)),' smallerSpectrogram ', num2str(size(smallerSpectrogram))];
Y = ['Original Dimensions Stim ', num2str(size(Stimulus)),' Patches ', num2str(size(spectrogramPatches))];
disp(X);
disp(Y);
Z = ['Weights ', num2str(size(transformWeightsInit))];

disp(Z);

end

