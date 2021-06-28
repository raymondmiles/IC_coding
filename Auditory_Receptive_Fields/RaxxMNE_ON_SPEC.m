%% This is to obtain the MNE models of the spectrograms
close all, clear all, clc
%% Add utils
addpath('C:\Users\User\Desktop\FYP\Code\CodeSihao\Code\steadman2020\SihaoMNE\utils')
prepare_env() %check this, there is a list of 
% Define directories containing .mat files for spikes
datadir='C:\Users\User\Desktop\FYP\Code\DATA_Spikes\INPUTFILES'%'C:\Users\User\Desktop\Year 4\FYP\Code\CodeSihao\Code\steadman2020\DATA_Manuscript\DATA_Spikes';
files=dir(fullfile(datadir,'*.mat'));
outdir='C:\Users\User\Desktop\FYP\SpectrogramMan';
% Load the analysis parameters
params = load('C:\Users\User\Desktop\FYP\Code\CodeSihao\Code\steadman2020\MNEaux\PARAMETERS_RAY.mat');%load('C:\Users\User\Desktop\FYP\Code\CodeSihao\Code\steadman2020\MNEaux\DEFAULT_MNE_PARAMETERS.mat');
% Settings for parallel processing pool = parpool(8);
% Response = vector Stimulus = 2-d matrix with a vector for each frequency bin
%load 'C:\Users\User\Desktop\FYP\Code\CodeSihao\Code\steadman2020\RayTest\20170324_loc1_trode6_unit1_MNE_model.mat'
%% Train models for all spike data
addpath 'C:\Users\User\Desktop\FYP'
load('bestNeurons.mat')
%%
for i = 1:1:numel(files)%numel(idx)   %numel(files) % 1:length(idx)    
    %fname=fullfile(datadir,files(idx(i)).name);
    fname=fullfile(datadir,files(i).name);

    % Check if MNE_model.mat already exists
    [~,name]=fileparts(fname);
    savename=fullfile(outdir,[name,'Sparse_Model_Final.mat']);
    
    % Skip if file exists already 
    if exist(savename, 'file')~= 0
        disp(['Skipping: ' savename])
        continue
    end
    
    spikes = load(fname);
    
    % Check if starling data present
    nsets=numel(spikes.spkdata.sets);

    % Process USV repsonses
    current_file_params = params.params;
    current_parameters = current_file_params.params.parameters; 
    %    current_parameters = current_file_params.parameters;

    current_parameters.setidx=1;
    
    % Preprocess
    [training_set_usv, test_set_usv] = preprocess_spkdata_vanilla(spikes.spkdata, current_parameters);
    
    % Run MNE
    njack_model_parameters_usv = train_mne_model(training_set_usv, current_parameters);
    
    % Test model
    predictions_usv = test_mne_model(njack_model_parameters_usv, test_set_usv);
    
    % Run MNE for starling song responses (if included)
    if nsets>1
        current_parameters.setidx=2;
        [training_set_starling, test_set_starling] = preprocess_spkdata_vanilla(spikes.spkdata, current_parameters);
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
for i = 1:1:4
hold on; plot(predictions_usv(i).real); plot(predictions_usv(i).predicted)
end
%%
addpath 'C:\Users\User\Desktop\FYP'
%load('20170324_loc1_trode6_unit1_MNE_model')


%%
filesMNE=dir(fullfile(outdir,'*.mat'));

for i = 1%:1:numel(files)%numel(idx)   %numel(files) % 1:length(idx)    
fname=fullfile(outdir,filesMNE(i).name);
% Check if MNE_model.mat already exists
spikes = load(fname);

% njack_model_parameters_usv
% njack_model_parameters_starling
%
% predictions_usv
% predictions_starling

% Check if starling data present
Real = spikes.predictions_usv.real;
Predicted = spikes.predictions_usv.predicted;
%[h,p,ks2stat] = kstest2(reshape(normalize(spectrogramFriend),[],1),reshape(normalize(Stimulus1),[],1))
%[h,p,ks2stat] = kstest2(normalize(Real)',normalize(Predicted));
%[h,p,ci,stats] = ttest2(normalize(Real)',normalize(Predicted));
[h,p,ci,stats] = ttest2(Real',Predicted)

%[h,p,ks2stat] = kstest2(reshape(normalize(spectrogramFriend),[],1),reshape(normalize(Stimulus1),[],1))
end
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