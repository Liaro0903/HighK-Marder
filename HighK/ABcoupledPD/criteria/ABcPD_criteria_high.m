function qualifies = ABcPD_criteria_high(x)
  arguments
    x (1,1) xolotl
  end
  pause(2);
  x = setPotential(x, -56, 24, ["AB" "PD"]);
  [AB_isBursting, PD_isBursting, ~, ~] = meta_criteria(x, "bursting", "bursting");
  disp([num2str(AB_isBursting), ' | ', num2str(PD_isBursting)]);
  x.myplot('hi');
  if (AB_isBursting && PD_isBursting)
    x = setPotential(x, -80, 24, ["AB" "PD"]);
    [AB_isBursting, PD_isBursting, ~, ~] = meta_criteria(x, "bursting", "bursting");
    if (AB_isBursting && PD_isBursting)
      x.myplot('hi2');
      disp('Found burst at -80');
      qualifies = 1.0; 
    else
      qualifies = 0.0;
    end
  else
    qualifies = 0.0;
  end
end