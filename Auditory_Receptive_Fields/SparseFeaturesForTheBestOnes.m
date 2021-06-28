%% This is to obtain the MNE models of the spectrograms
close all, clear all, clc
%% Train models for all spike data
addpath 'C:\Users\User\Desktop\FYP' % for BestNeuron
datadir='C:\Users\User\Desktop\FYP\Code\DATA_Spikes\INPUTFILES'%'C:\Users\User\Desktop\Year 4\FYP\Code\CodeSihao\Code\steadman2020\DATA_Manuscript\DATA_Spikes';
addpath('C:\Users\User\Desktop\FYP\Code\DATA_Spikes\INPUTFILES')
addpath('C:\Users\User\Desktop\FYP\Code\RaymondCode')
load('bestNeurons.mat')
files=dir(fullfile(datadir,'*.mat'));
%%
for i = 1:1:numel(idx)
varNameNum = idx(i);
fname= fullfile(datadir,files(varNameNum).name);
varName = files(varNameNum).name;
soundOrigin = 1; % soundOrigin = 1 for USV and = 2 for Starling
nfft = 128;
start = 0;
resizeFactFreq = 1;
resizeFactTime = 1/16;
exampleSizeTime = 25;
numExamples = 1000;
saveImages = 0;
q = 100;
Location = 'C:\Users\User\Desktop\FYP\';
outPutFile = append("Value",varName);
outPutFilePatch = append('Patch', varName);
iterationNum = 400;
[optW2,transformWeights, img, spectrogramPatches] = featureExtractor(outPutFile, varName, soundOrigin, nfft, start, resizeFactFreq, resizeFactTime, exampleSizeTime, numExamples, saveImages, q, Location, iterationNum);
NewFeatures = spectrogramPatches'*optW2.TransformWeights();
outPutFileFeatures = append('C:\Users\User\Desktop\FYP\Code\SparseFilteringData\SparseFeatures_', varName)
save(outPutFileFeatures,'NewFeatures');
end
%%
NewFeatures = spectrogramPatches'*optW2.TransformWeights()
% PatchExtraction
%addpath("C:\Users\User\Desktop\FYP")
%featureNum = 64;
%timeSize = 64;
%freqSize = 22; 
%load('20170324_loc1_trode4_unit1')
%[patchCell] = patchExtractor(featureNum,timeSize, freqSize, img)

%%
imagesc(NewFeatures)
save(SparseFiltered,'NewFeatures')
%%
load(varNameNum)
Stimulus = spkdata.sets(1).stimulus.values; 
%%
load('20170324_loc1_trode6_unit1')
    Stimulus = spkdata.sets(1).stimulus.values; 

[spec, f, t, p] = GetSpec(Stimulus, 250000, 128, 100 , 0, 1);

