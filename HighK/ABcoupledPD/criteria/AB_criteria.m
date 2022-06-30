function isWave = AB_criteria(x)
  arguments
    x (1,1) xolotl
  end
  pause(2);
  x.t_end = 10000;
  x.output_type = 2;
  results_and_spiketimes = x.integrate;

  % Using built in xtools.findBurstMetrics, but so far not that reliable and requires further investigation
  % V_filtered = results_and_spiketimes.AB.V(60e3:100e3);
  % Ca_filtered = results_and_spiketimes.AB.Ca(60e3:100e3);
  % [burst_metrics, spike_times, ~, ~] = xtools.findBurstMetrics(V_filtered, Ca_filtered, 0.3, 0.1, -25);
  % state = detect_burst_state(burst_metrics, spike_times);
  % if (state == "bursting")
  %   isWave = 1.0;
  % else
  %   isWave = 0.0;
  % end 

  % Using diff2000, so far is more reliable
  spike_threshold = -40; % requires this because built in integrate spiketimes is at 0mV, but we need at a different threshold
  n_spikes = xtools.findNSpikes(results_and_spiketimes.AB.V, spike_threshold);
  spiketimes = xtools.findNSpikeTimes(results_and_spiketimes.AB.V, n_spikes, spike_threshold);
  state = diff2000(filter_spike_times(spiketimes, 50000)); % so far this is the best
  disp(state);
  if (state == "bursting")
    isWave = 1.0;
  else
    isWave = 0.0;
  end
end