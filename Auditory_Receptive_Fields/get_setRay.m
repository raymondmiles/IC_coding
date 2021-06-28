function [stim, resp, times, freqs] = get_setRay(signal, fs, psth, parameters)
  % Define pre-processing parameters
  nLFbins   = parameters.nLFbins;         
  nHFbins   = parameters.nHFbins;         
  minfreq   = parameters.minfreq;   %8000      
  HFcutfreq = parameters.HFcutfreq;     
  maxfreq   = parameters.maxfreq;         
  nlags     = parameters.nlags; 
  binsize   = parameters.binsize;

  % Define the edge frequencies for the spectrogram
  LFedges=logspace(log10(minfreq),log10(HFcutfreq),nLFbins+1);
  HFedges=logspace(log10(HFcutfreq),log10(maxfreq),nHFbins+1);
  edgefreqs=cat(2,LFedges,HFedges(2:end));
  % Calculate the raw spectrogram
  [spec, f, t] = get_spec(signal, fs);
  
 
  % Compress spectrogram to create stimulus
  [stim, times, freqs] = %compress_spec(spec, edgefreqs, signal, fs, binsize, t, f);
  
[optW2,~, img, ~] = featureExtractor(outPutFile, varNameNum, soundOrigin ...
    , nfft, start, resizeFactFreq, resizeFactTime, exampleSizeTime, numExamples, ...
saveImages, q, Location, iterationNum);

  % Include time lags
  stim = include_lags(stim, nlags);

  % Do stimulus centering
  stim = centre_stimulus(stim);
  
  % Account for data being lagged
  resp=psth(nlags+1:end);
  times=times(nlags+1:end)';
  
  % Ensure number of time bins is the same
  [n_time_bins_stim, ~] = size(stim);
  if numel(resp) ~= n_time_bins_stim
      nbins_min = min(numel(resp), n_time_bins_stim);
      resp = resp(1:nbins_min);
      stim = stim(1:nbins_min, :);
  end
end
