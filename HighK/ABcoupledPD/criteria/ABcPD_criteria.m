function qualifies = ABcPD_criteria(x)
  arguments
    x (1,1) xolotl
  end
  % pause(1);
  [AB_isWave, PD_isTonic, AB_V, PD_V] = meta_criteria(x, "bursting", "tonic");
  disp([num2str(AB_isWave), ' | ', num2str(PD_isTonic)]);
  % all_ABPD_V = zeros(x.t_end * 10, 2);
  % all_ABPD_V(1:50000, 1) = AB_V(1:50000);
  % all_ABPD_V(1:50000, 2) = PD_V(1:50000);
  if (AB_isWave && PD_isTonic)
    x1 = copy(x);
    synapse_type = 'Electrical';
    base = 110;
    x1.connect('AB','PD', synapse_type, 'gmax', base * 4);
    x1.connect('PD','AB', synapse_type, 'gmax', base);
    [AB_isWave, PD_isBursting, AB_V, PD_V] = meta_criteria(x1, "bursting", "bursting");
    if (AB_isWave && PD_isBursting)
      % all_ABPD_V(50001:100000, 1) = AB_V(1:50000);
      % all_ABPD_V(50001:100000, 2) = PD_V(1:50000);
      % x.myplot2({'hi'}, all_ABPD_V);
      qualifies = 1.0;
    else
      qualifies = 0.0;
    end
  else
    qualifies = 0.0;
  end
end