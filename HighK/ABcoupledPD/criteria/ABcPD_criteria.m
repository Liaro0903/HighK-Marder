% ARCHIVED, everything moved to FindABcPD_rand class

function qualifies = ABcPD_criteria(x)
  arguments
    x (1,1) xolotl
  end
  % pause(1);
  x.set('AB.ElectricalPD.gmax', 0);
  x.set('PD.ElectricalAB.gmax', 0);
  [AB_isWave, PD_isTonic, AB_V, PD_V] = meta_criteria(x, "bursting", "tonic");
  metrics_AB = xtools.V2metrics(AB_V(50001:100000), 'spike_threshold', -40, 'sampling_rate', 1);
  metrics_PD = xtools.V2metrics(PD_V(50001:100000), 'sampling_rate', 1);
  % disp([
  %   num2str(AB_isWave), ' | ', num2str(PD_isTonic), ...
  %   ' | ', num2str(metrics_AB.firing_rate), ' | ', num2str(metrics_PD.firing_rate), ...
  %   ' | ', num2str(metrics_PD.n_spikes_per_burst_mean), ' | ', num2str(metrics_PD.isi_std) ...
  % ]);
  % all_ABPD_V = zeros(x.t_end * 10, 2);
  % all_ABPD_V(1:50000, 1) = AB_V(1:50000);
  % all_ABPD_V(1:50000, 2) = PD_V(1:50000);
  if (AB_isWave && ...
    0.5 < metrics_AB.firing_rate && metrics_AB.firing_rate < 1.5 && ...
    3 < metrics_PD.firing_rate && metrics_PD.firing_rate < 20 && ...
    metrics_PD.n_spikes_per_burst_mean <= 1.1 && metrics_PD.isi_std < 200 ...
  ) % restrict isi_std so isi are consistent not having 2 spikes that are close (which is more like a bursts than tonic)
    x.set('AB.ElectricalPD.gmax', 110);
    x.set('PD.ElectricalAB.gmax', 440);
    [AB_isWave, PD_isBursting, AB_V, PD_V] = meta_criteria(x, "bursting", "bursting");
    if (AB_isWave && PD_isBursting)
      % all_ABPD_V(50001:100000, 1) = AB_V(1:50000);
      % all_ABPD_V(50001:100000, 2) = PD_V(1:50000);
      % x.myplot2({[num2str(metrics_PD.firing_rate), ' | ', num2str(metrics_PD.isi_std)]}, all_ABPD_V);
      qualifies = 1.0;
    else
      qualifies = 0.0;
    end
  else
    qualifies = 0.0;
  end
end