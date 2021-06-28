close all, clear all
%%
addpath('C:\Users\User\Desktop\FYP\Code\for_raymond\for_raymond\manual_segmentation\USV\Manual_segmentation\Chabout_250k')
audioPath = 'C:\Users\User\Desktop\FYP\Code\for_raymond\for_raymond\manual_segmentation\USV\Manual_segmentation\Chabout_250k'
%%
filesMNE=dir(fullfile(audioPath,'*.wav'));
%%
matrixMan = []
for i = 1:1:200%numel(filesMNE)%numel(idx)   %numel(files) % 1:length(idx)    
fname=fullfile(audioPath,filesMNE(i).name);
% Check if MNE_model.mat already exists
[y,~] = audioread(fname);
matrixMan = cat(1,matrixMan,y);
end
o
%%
for i = 1:1:numel(idx)
soundOrigin = 1; % soundOrigin = 1 for USV and = 2 for Starling
nfft = 128;
start = 0;
resizeFactFreq = 1;
resizeFactTime = 1/16;
exampleSizeTime = 25;
numExamples = 1000;
saveImages = 0;
q = 100;
Location = 'C:\Users\User\Desktop\FYP\GabbaManna';
outPutFile = append("Value",varName);
outPutFilePatch = append('Patch', varName);
iterationNum = 400;
[optW2,transformWeights, img, spectrogramPatches] = featureExtractor(outPutFile, varName, soundOrigin, nfft, start, resizeFactFreq, resizeFactTime, exampleSizeTime, numExamples, saveImages, q, Location, iterationNum);
NewFeatures = spectrogramPatches'*optW2.TransformWeights();
outPutFileFeatures = append('C:\Users\User\Desktop\FYP\Code\SparseFilteringData\SparseFeatures_', varName)
save(outPutFileFeatures,'NewFeatures');
end