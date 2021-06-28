close all, clear all, clc
%%This script Extracts patches from the audiofiles and cluster them with
%%the UMAP algorithm adaptation
%Connor Meehan, Jonathan Ebrahimian, Wayne Moore, and Stephen Meehan (2021). 
%Uniform Manifold Approximation and Projection (UMAP) 
%(https://www.mathworks.com/matlabcentral/fileexchange/71902), MATLAB Central File Exchange.
matrixCol = [];
addpath 'C:\Users\User\Desktop\FYP\Code\RaymondCode';
addpath 'C:\Users\User\Desktop\FYP\Code\DATA_Spikes\FilesForUMAP';
addpath 'C:\Users\User\Desktop\FYP\Code\DATA_Spikes\INPUTFILES';
addpath 'C:\Users\User\Desktop\FYP\Code\DATA_Spikes\USVs_Sihao_Cleaned_250k-01'
datadir='C:\Users\User\Desktop\FYP\Code\DATA_Spikes\INPUTFILES'
files = dir(fullfile('C:\Users\User\Desktop\FYP\Code\DATA_Spikes\INPUTFILES','*.mat'))
Location = 'C:\Users\User\Desktop\FYP\';
outPutFile = sprintf(strcat("SparseFilteredBoss",files(ioMano).name), '.mat');

%%
for ioMano = 1:numel(files)
    varNameNum = fullfile(datadir,files(ioMano).name);
for soundOrigin = [1 2] % 1 = USV, 2 = Starling Song
nfft = 128; % window size for ST-FT
start = 0;
resizeFactFreq = 1/2;
resizeFactTime = 1/8;
exampleSizeTime = 32;
numExamples = 1000;
saveImages = 0;
q = 64;
iterationNum = 350;
[~, ~, ~] = featureExtractor(outPutFile, varNameNum, soundOrigin, nfft, start, resizeFactFreq, resizeFactTime, exampleSizeTime, numExamples, saveImages, q, Location, iterationNum);
end
end


%% save the sparseFilteredPatches
close all, clear all, clc
exampleSizeTime = 32;%64
addpath("C:\Users\User\Desktop\FYP\SparseFilteredImages");
sparseImgFiles = dir(fullfile('C:\Users\User\Desktop\FYP\SparseFilteredImages','*.mat'));
LocationPatches = 'C:\Users\User\Desktop\FYP\SparseFilteredPatches';
for imagePatches = 1%:numel(sparseImgFiles)objective is to extract each feature
featureNum = 64;
freqSize = 22; 
load(sparseImgFiles(imagePatches).name)
patchCell = patchExtractor(featureNum,exampleSizeTime, freqSize, sparseFiltImg);
outPutFile = sprintf(strcat("patchFile",sparseImgFiles(imagePatches).name(1,19:end)), '.mat');
G = sprintf(outPutFile, '.mat');
patchStruct = struct('patchCell',patchCell,'origin',origin);
position = fullfile(LocationPatches,G);
save(position, 'patchCell');
end
%%
close all, clear all
addpath('C:\Users\User\Desktop\FYP\SparseFilteredPatches')
LocationPatches = 'C:\Users\User\Desktop\FYP\SparseFilteredPatches';
patchCells = dir(fullfile('C:\Users\User\Desktop\FYP\SparseFilteredPatches','*.mat'));
%% produce matrixCol with the necessary data
matrixCol = []
for patchCell = 1:1:numel(patchCells)
load(patchCells(patchCell).name)
k = 1;
for i = 1:1:8
    for j = 1:1:8
        singleCell = patchCell(i,j);
        matrixPatch = cell2mat(singleCell);
        columnMan =  reshape(matrixPatch,1,[]);
        matrixCol = [matrixCol; columnMan];
        k = k+1
    end
end
end
%% Save matrixCol
save('C:\Users\User\Desktop\FYP\Code\DATA_Spikes\FilesForUMAP\matrixCol.mat',"matrixCol")
%% run UMAP on the patches
addpath("C:\Users\User\Desktop\FYP\Code\DATA_Spikes\FilesForUMAP")
addpath("C:\Users\User\Desktop\FYP\Code\umapFileExchange (2.2)\umap")
rng(1)
load("matrixCol.mat")
for numNeighbour = [10 170 ]
    embedding = run_umap(matrixCol, 'n_epochs', 2000, 'min_dist', 0.090000001,'n_neighbors', numNeighbour, 'n_components',3 );
end