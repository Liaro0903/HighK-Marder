function varargout = meta_criteria(x, req_1, req_2)
  arguments
    x (1,1) xolotl
    req_1 (1,1) string
    req_2 (1,1) string
  end
  % pause(1);
  x.t_end = 10000;
  x.output_type = 2;
  results_and_spiketimes = x.integrate;

  % Categorizing AB
  spike_threshold = -40; % requires this because built in integrate spiketimes is at 0mV, but we need at a different threshold
  n_spikes = xtools.findNSpikes(results_and_spiketimes.AB.V, spike_threshold);
  spiketimes = xtools.findNSpikeTimes(results_and_spiketimes.AB.V, n_spikes, spike_threshold);
  state = diff2000(filter_spike_times(spiketimes, 50000)); % so far this is the best
  % disp(state); 
  if (state == req_1)
    varargout{1} = 1.0;
  else
    varargout{1} = 0.0;
  end

  % Categorizing PD
  state = diff2000(filter_spike_times(results_and_spiketimes.PD.spiketimes, 50000)); % so far this is the best
  % disp(state);
  if (state == req_2)
    varargout{2} = 1.0;
  else
    varargout{2} = 0.0;
  end

  varargout{3} = results_and_spiketimes.AB.V;
  varargout{4} = results_and_spiketimes.PD.V;
end


