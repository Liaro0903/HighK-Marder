% Function for random search

function isTonic = PD_criteria(x)
  arguments
    x (1,1) xolotl
  end
  % pause(2);
  x.t_end = 10000;
  x.output_type = 2;
  results_and_spiketimes = x.integrate;

  % Using xolotl's burst metric, currenlty there is some bug, but I haven't have time to fix this because diff2000 is better in this scenarios
  % V_filtered = results_and_spiketimes.PD.V(60e3:100e3);
  % Ca_filtered = results_and_spiketimes.PD.Ca(60e3:100e3);
  % [burst_metrics, spike_times, ~, ~] = xtools.findBurstMetrics(V_filtered, Ca_filtered);
  % state = detect_burst_state(burst_metrics, spike_times);
  % disp([state, ' | ', state2]);
  % if (state == "bursting")
    % x.myplot2({'tonic'}, results_and_spiketimes.PD.V);
    % isTonic = 1.0;
  % else
    % isTonic = 1.0;
  % end 

  % Using diff2000 method, but diff2000 might be deleted in the future
  % state = diff2000(filter_spike_times(results_and_spiketimes.PD.spiketimes, 50000)); % so far this is the best
  % disp(state);

  % if (state == "tonic")
  %   % x.myplot('hi');
  %   isTonic = 1.0;
  % else
  %   isTonic = 0.0;
  % end
  
  % Using xtools v2 metrics
  metrics_PD = xtools.V2metrics(results_and_spiketimes.PD.V(50001:100000), 'sampling_rate', 1);
  disp([num2str(metrics_PD.firing_rate), ' | ', num2str(metrics_PD.n_spikes_per_burst_mean), ' | ', num2str(metrics_PD.isi_std)]);
  if (3 < metrics_PD.firing_rate && metrics_PD.firing_rate < 20 && ...
    metrics_PD.n_spikes_per_burst_mean <= 1.1 && metrics_PD.isi_std < 100)
    x.myplot(num2str(metrics_PD.firing_rate));
    isTonic = 1.0;
  else
    isTonic = 0.0;
  end
 
end