function qualifies = ABcPD_criteria_high(x)
  arguments
    x (1,1) xolotl
  end
  % pause(2);
  x = setPotential(x, -56, 24, ["AB" "PD"]);
  results_and_spiketimes = x.integrate;
  AB_V = results_and_spiketimes.AB.V(50001:100000);
  PD_V = results_and_spiketimes.PD.V(50001:100000);

  max_n_spikes_per_burst = 0;
  max_n_spikes_per_burst_V = 10;
  for spike_threshold = -40:5:0
    metrics_AB = xtools.V2metrics(AB_V, 'sampling_rate', 1, 'spike_threshold', spike_threshold);
    if max_n_spikes_per_burst < metrics_AB.n_spikes_per_burst_mean
      max_n_spikes_per_burst = metrics_AB.n_spikes_per_burst_mean;
      max_n_spikes_per_burst_V = spike_threshold;
    end 
  end
  metrics_AB = xtools.V2metrics(AB_V, 'sampling_rate', 1, 'spike_threshold', max_n_spikes_per_burst_V);
  metrics_PD = xtools.V2metrics(PD_V, 'sampling_rate', 1);
  % disp([
  %   'n_spikes_PD: ', num2str(metrics_PD.n_spikes_per_burst_mean) ...
  %   ' | PD_ibi_mean: ', num2str(metrics_PD.ibi_mean) ...
  %   ' | PD_ibi_std: ', num2str(metrics_PD.ibi_std) ...
  %   ' | n_spikes_AB: ', num2str(metrics_AB.n_spikes_per_burst_mean), ...
  %   ' | ibi_std: ', num2str(metrics_AB.ibi_std) ...
  %   ' | AB_ibi_mean: ', num2str(metrics_AB.ibi_mean) ...
  % ]);
  % x.myplot('hi');
  if ( ...
    1 < metrics_PD.n_spikes_per_burst_mean && metrics_PD.ibi_mean > 500 && ...
    metrics_AB.n_spikes_per_burst_mean >= 3 && metrics_AB.ibi_std < 100 ...
  )
    % disp('Found bursts at -56');
    x = setPotential(x, -80, 24, ["AB" "PD"]);
    results_and_spiketimes_80 = x.integrate;
    AB_V_80 = results_and_spiketimes_80.AB.V(50001:100000);
    PD_V_80 = results_and_spiketimes_80.PD.V(50001:100000);

    max_n_spikes_per_burst = 0;
    max_n_spikes_per_burst_V = 10;
    for spike_threshold = -40:5:0
      metrics_AB_80 = xtools.V2metrics(AB_V_80, 'sampling_rate', 1, 'spike_threshold', spike_threshold);
      if max_n_spikes_per_burst < metrics_AB_80.n_spikes_per_burst_mean
        max_n_spikes_per_burst = metrics_AB_80.n_spikes_per_burst_mean;
        max_n_spikes_per_burst_V = spike_threshold;
      end 
    end
    metrics_AB_80 = xtools.V2metrics(AB_V_80, 'sampling_rate', 1, 'spike_threshold', max_n_spikes_per_burst_V);
    metrics_PD_80 = xtools.V2metrics(PD_V_80, 'sampling_rate', 1);
    % disp([
    %   'n_spikes_PD: ', num2str(metrics_PD_80.n_spikes_per_burst_mean) ...
    %   ' | PD_ibi_mean: ', num2str(metrics_PD_80.ibi_mean) ...
    %   ' | PD_ibi_std: ', num2str(metrics_PD_80.ibi_std) ...
    %   ' | n_spikes_AB: ', num2str(metrics_AB_80.n_spikes_per_burst_mean), ...
    %   ' | ibi_std: ', num2str(metrics_AB_80.ibi_std) ...
    %   ' | AB_ibi_mean: ', num2str(metrics_AB_80.ibi_mean) ...
    % ]);
    % x.myplot('hi2');
    % pause(10);
    if (1 < metrics_AB_80.n_spikes_per_burst_mean && 500 < metrics_PD_80.ibi_mean && 1 < metrics_PD_80.n_spikes_per_burst_mean)
      % disp('Found burst at -80');
      qualifies = 1.0; 
    else
      qualifies = 0.0;
    end
  else 
    qualifies = 0.0;
  end
end