function [training_set, test_set] = preprocess_spkdata(spkdata, parameters)
%PREPROCESS_SPKDATA Preprocess spike data for MNE analysis
%   Process spike data saved as .mat files in preparation of MNE analysis
%   spkdata: struct with fields:
%               -original_filename,
%               -trode, 
%               -unit,
%               -sets : -stimulus (stimulus waveform)
%                       -sweeps (spike times)
%
%   parameters: parameters defining spectrogram calculation and 
%               psth generation, struct with fields:
%               -nLFbins, 
%               -nHFbins, 
%               -minfreq, 
%               -HFcutfreq, 
%               -maxfreq, 
%               -binsize, 
%               -nlags, 
%               -njacks, 
%               -setidx
%   training_set: Data to use for training MNE model, struct containing:
%               -stim,
%               -resp,
%               -times,
%               -freqs
%
%   test_set: Data to use for testing MNE model, struct containing:
%               -stim,
%               -resp,
%               -times,
%               -freqs
    setidx = parameters.setidx;
    %% Get stimulus waveform and response psth
    sig=spkdata.sets(setidx).stimulus.values; %to replace with filtered spike
    fs=spkdata.sets(setidx).stimulus.fs;

    % Calculate the PSTH
    binsize = parameters.binsize
    stimdur=numel(sig)/fs;
    edgetimes=0:binsize:stimdur;

    psth = calc_psth(cell2mat(spkdata.sets(setidx).sweeps), edgetimes);

    [train_sig, test_sig] = train_test_split(sig', 0.8); %0.7
    [train_psth, test_psth] = train_test_split(psth', 0.8); %0.7
    
    
    [train_stim, train_resp, train_times, train_freqs] = get_setRay(train_sig, fs, train_psth, parameters);
    [test_stim, test_resp, test_times, test_freqs] = get_setRay(test_sig, fs, test_psth, parameters);
  
    %% Save to structs
    training_set=struct(...
    'stim',train_stim,...
    'resp',train_resp,...
    'times',train_times,...
    'freqs',train_freqs);
    
    test_set=struct(...
    'stim',test_stim,...
    'resp',test_resp,...
    'times',test_times,...
    'freqs',test_freqs);


end


function stim_lagged = include_lags(input_stim, nlags)
  stim=input_stim';
  shifted=cell2mat(arrayfun(@(x) circshift(stim,x),1:nlags,'uni',0));
  stim_lagged=shifted(nlags+1:end,:);
end

function stim_centred = centre_stimulus(input_stim)
  nsamples=size(input_stim,1);
  stim_centred=input_stim-repmat(mean(input_stim),nsamples,1);
  stim_centred=stim_centred./repmat(std(stim_centred),nsamples,1);

end

function psth = calc_psth(spike_times_matrix, edgetimes)
  psth=histcounts(spike_times_matrix,edgetimes);
  psth=psth'/max(psth);
end

function [stim, times, freqs] = compress_spec(input_spec, edgefreqs,  signal, fs, binsize, t, f)
  % Average across frequency bins
  nfreqs=numel(edgefreqs)-1;
  stim=zeros(nfreqs,numel(t));
  for i=1:nfreqs
    idx=f>=edgefreqs(i)&f<=edgefreqs(i+1);
    stim(i,:)=mean(input_spec(idx,:));
  end
  freqs=edgefreqs(1:end-1)+0.5*diff(edgefreqs);
  
  % Average across time bins
  s=stim;
  stimdur=numel(signal)/fs;
  edgetimes=0:binsize:stimdur;
  nbins = numel(edgetimes)-1;
  stim=zeros(nfreqs,nbins);
  for i=1:nbins
    idx=t>=edgetimes(i)&t<=edgetimes(i+1);
    stim(:,i)=mean(s(:,idx),2);
  end
  times=edgetimes(1:end-1)+0.5*diff(edgetimes);
end

function [spec, f, t] = get_spec(signal, fs)
  % Calculate the raw spectrogram
  nfft = 1024;
  %nfft=1024;
  [spec,f,t]=spectrogram(signal,hann(nfft),0.5*nfft,nfft,fs);

  % Convert to log scale
  
  epsilon=1e-6;
  spec=log(abs(max(spec,epsilon)));
  %spec(isnan(spec))=epsilon;

end

