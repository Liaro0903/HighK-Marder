function varargout = burstinginterval(spiketimes)
  ISI = diff(spiketimes);
  ISIsorted = sort(ISI);
  IBI = filter_spike_times(ISIsorted, 2000);
  if ~isempty(IBI)
    B_freq = 1 / (mean(IBI) / 10000); % divide by 1000 to convert to seconds
  else
    B_freq = 0;
  end 
  varargout{1} = IBI;
  varargout{2} = B_freq;
  varargout{3} = ISI;
end