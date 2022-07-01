function qualifies = ABcPD_criteria_high(x)
  arguments
    x (1,1) xolotl
  end
  % pause(2);
  x = setPotential(x, -56, 24, ["AB" "PD"]);
  [AB_isBursting, PD_isBursting, ~, PD_V] = meta_criteria(x, "bursting", "bursting");
  metrics_PD = xtools.V2metrics(PD_V(50001:100000), 'sampling_rate', 1);
  % disp([num2str(AB_isBursting), ' | ', num2str(PD_isBursting), ' | ', num2str(metrics_PD.n_spikes_per_burst_mean)]);
  % x.myplot('hi');
  if (AB_isBursting && PD_isBursting && 1 < metrics_PD.n_spikes_per_burst_mean)
    x = setPotential(x, -80, 24, ["AB" "PD"]);
    [AB_isBursting, PD_isBursting, ~, PD_V] = meta_criteria(x, "bursting", "bursting");
    metrics_PD = xtools.V2metrics(PD_V(50001:100000), 'sampling_rate', 1);
    % disp(num2str(metrics_PD.n_spikes_per_burst_mean));
    if (AB_isBursting && PD_isBursting && 1 < metrics_PD.n_spikes_per_burst_mean)
      % x.myplot('hi2');
      % disp('Found burst at -80');
      qualifies = 1.0; 
    else
      qualifies = 0.0;
    end
  else
    qualifies = 0.0;
  end
end