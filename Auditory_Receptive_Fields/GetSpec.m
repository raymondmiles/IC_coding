function [spec, f, t, p] = GetSpec(signal, fs, nfft, duration , startTime, plot)
  % function [spec, f, t, p] = GetSpec(signal, fs, nfft, duration , startTime, plot)
  % Calculate the raw spectrogram from signal, sampling frequency = fs,
  % nfft = window size, duration = time length of signal, startTime = where
  % to start for the spectrogram. when plot is 1 the spectrogram is also
  % plotted
  if startTime ~= 0
      signal = signal(startTime*fs:1:duration*fs);
  else
  signal = signal(1:1:duration*fs);
  end
  figure
  [spec, f, t, p]=spectrogram(signal,hann(nfft),0.5*nfft,nfft,fs,'yaxis'); %% plots frequency on 'yaxis'
  if plot == 1
  spectrogram(signal,hann(nfft),0.5*nfft,nfft,fs,'yaxis');
  end
  epsilon= 1e-6;
  spec= log(abs(max(spec,epsilon))); % returns the highest value between epsilon or the spec
  %to avoid Nan or outliers.
end
