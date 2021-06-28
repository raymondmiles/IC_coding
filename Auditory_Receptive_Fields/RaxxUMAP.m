%% This is to obtain the MNE models of the spectrograms
close all, clear all, clc
%% Add paths
addpath('C:\Users\User\Desktop\FYP\Code\umapFileExchange (2.2)\umap')
addpath('C:\Users\User\Desktop\FYP\Code\CodeSihao\Code\steadman2020\SihaoMNE\utils')
addpath('C:\Users\User\Desktop\FYP')
addpath('C:\Users\User\Desktop\FYP\Code\CodeSihao\Code\steadman2020\')
prepare_env() %check this, there is a lùist of 

%% Define directories containing .mat files for spikes
datadir = 'C:\Users\User\Desktop\FYP\Code\DATA_Spikes\INPUTFILES';%'C:\Users\User\Desktop\Year 4\FYP\Code\CodeSihao\Code\steadman2020\DATA_Manuscript\DATA_Spikes';
files = dir(fullfile(datadir,'*.mat'));
outdir = 'C:\Users\User\Desktop\FYP\MNE_on_SPECTROGRAMS';
sparsedir = 'C:\Users\User\Desktop\FYP\Code\SparseFilteringData';
sparse_files=dir(fullfile(sparsedir,'*.mat'));
% Load the analysis parameters
params = load('C:\Users\User\Desktop\FYP\Code\CodeSihao\Code\steadman2020\MNEaux\DEFAULT_MNE_PARAMETERS.mat');%load('C:\Users\User\Desktop\FYP\Code\CodeSihao\Code\steadman2020\MNEaux\DEFAULT_MNE_PARAMETERS.mat');
% Settings for parallel processing 
%pool = parpool(8);
% Response = vector Stimulus = 2-d matrix with a vector for each frequency bin
%load 'C:\Users\User\Desktop\FYP\Code\CodeSihao\Code\steadman2020\RayTest\20170324_loc1_trode6_unit1_MNE_model.mat'
%% Train models for all spike data
addpath('C:\Users\User\Desktop\FYP\Code\CodeSihao\Code\steadman2020\')

addpath 'C:\Users\User\Desktop\FYP'
load('bestNeurons.mat')
for i = 1:1:numel(idx)   %numel(files) % 1:length(idx)    
    numOfFile = idx(i);
    fname=fullfile(datadir,files(numOfFile).name);
    sparse_fname=fullfile(sparsedir,sparse_files(i).name);
%     % Check if MNE_model.mat already exists
    [~,name]=fileparts(fname);
    savename=fullfile(outdir,[name,'_MNE_model_SparseRes.mat']);
% Skip if file exists already 
%     if exist(savename, 'file')~= 0
%         disp(['Skipping: ' savename])
%         continue
%     end
    spikes = load(fname);
    sparseMatrix = load(sparse_fname);
    % Check if starling data present
    nsets=numel(spikes.spkdata.sets);
    % Process USV repsonses
    current_file_params = params;
    current_parameters = current_file_params.parameters; 
    %    current_parameters = current_file_params.parameters;
    current_parameters.setidx=1;
    % Preprocess
    [training_set_usv, test_set_usv] = preprocess_spkdata_UMAP(sparseMatrix,spikes.spkdata, current_parameters);
    % Run MNE
    njack_model_parameters_usv = train_mne_model(training_set_usv, current_parameters);
    % Test model
    predictions_usv = test_mne_model(njack_model_parameters_usv, test_set_usv);
    % Run MNE for starling song responses (if included)
    if nsets>1
        current_parameters.setidx=2;
        [training_set_starling, test_set_starling] = preprocess_spkdata_UMAP(sparseMatrix, spikes.spkdata, current_parameters);
        njack_model_parameters_starling = train_mne_model(training_set_starling, current_parameters);
        predictions_starling = test_mne_model(njack_model_parameters_starling, test_set_starling);
    else
        njack_model_parameters_starling = [];
        predictions_starling = [];
    end
    % Save the results
    parsave(savename, ...
        njack_model_parameters_usv, ...
        njack_model_parameters_starling, ...
        predictions_usv, ...
        predictions_starling, ...
        current_parameters);
end
%%
addpath 'C:\Users\User\Desktop\FYP'
load('20170324_loc1_trode6_unit1_MNE_model')
%%
results = njack_model_parameters_starling%(1).J
%nstrfs = njack_model_parameters_starling(1).strfs
mne_display_results(results(1),parameters,5)
%saveas(figure,.png)
%%
function parsave(savename, njack_model_parameters_usv, ...
        njack_model_parameters_starling, ...
        predictions_usv, ...
        predictions_starling, ...
        parameters)
% Need this function to save in parfor loop
    save(savename, ...
            'njack_model_parameters_usv', ...
            'njack_model_parameters_starling', ...
            'predictions_usv', ...
            'predictions_starling', ...
            'parameters');
end