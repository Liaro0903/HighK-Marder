% To find PD models that can be used try to coupling
% The PD models should be bursting

% Rest
clear;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 1) INITIAL SETUP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x0 = xolotl;

% AB
x0.add('compartment', 'PD');

% Adding conductances
conds = {
  'prinz/NaV', 'prinz/CaT', 'prinz/CaS', ...
  'prinz/ACurrent', 'prinz/KCa', 'prinz/Kd', ...
  'prinz/HCurrent', 'Leak'
};

gbars_raw = readmatrix('gbars.csv');
gbars = gbars_raw(1:5, :);

% Setup gbar permutation matrix
gbar_scales = [0; 1;];
gbar_scale_permutation = gbar_scales;
for i = 1:7
  gbar_scale_permutation = setsprod(gbar_scale_permutation, gbar_scales);
end
neuronstates = cell(5, 1);
for i = 1:5
  neuronstates{i} = cell(3, 1);
  neuronstates{i}{3} = strings(length(gbar_scale_permutation), 2);
end

% Adding Calcium Dynamics
x0.PD.add('prinz/CalciumMech');

% x0.pref.plot_color = 1;
x0.pref.show_Ca = 0;
x0.t_end = 10000;
filter_time = 50000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 2) LOOP THROUGH AB/PD MODELS 1-5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for model = 3:3 % for debug
% for model = 1:5 % for full

% Set model array and directory name
dir_title = int2str(model);
if ~exist(dir_title, 'dir')
  mkdir(dir_title);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 3) LOOP THROUGH DIFFERENT GBAR_SCALE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for gbar_scale = 251:251 % for gbar_scale permutation debug mode
% for gbar_scale = 1:length(gbar_scale_permutation) % for gbar_scale permutation all
disp(gbar_scale);

x1 = copy(x0);

% Add conductances
for i = 1:length(conds)
  x1.PD.add(conds{i}, 'gbar', gbar_scale_permutation(gbar_scale, i) * gbars(model, i));
end

% Debug mode for each gbar
% x0.PD.ACurrent.gbar = x0.PD.ACurrent.gbar * 1;
% x0.PD.CaS.gbar      = x0.PD.CaS.gbar      * 1;
% x0.PD.CaT.gbar      = x0.PD.CaT.gbar      * 1;
% x0.PD.HCurrent.gbar = x0.PD.HCurrent.gbar * 1;
% x0.PD.KCa.gbar      = x0.PD.KCa.gbar      * 1;
% x0.PD.Kd.gbar       = x0.PD.Kd.gbar       * 1;
% x0.PD.NaV.gbar      = x0.PD.NaV.gbar      * 1;
% x0.PD.Leak.gbar     = x0.PD.Leak.gbar     * 1;

% Adding leak E
x1.PD.Leak.E = -50; % mV

% Integrate
x1.output_type = 2;
results_and_spiketimes = x1.integrate;
neuronstates{model}{1} = results_and_spiketimes.PD.V;
neuronstates{model}{2} = results_and_spiketimes.PD.spiketimes;
AB_spikes = filter_spike_times(results_and_spiketimes.PD.spiketimes, filter_time);

if isempty(AB_spikes)
  neuronstates{model}{3}(gbar_scale, 1) = 'silent';
  neuronstates{model}{3}(gbar_scale, 2) = 'silent';
else
  if (diff2000(AB_spikes)) 
    neuronstates{model}{3}(gbar_scale, 1) = 'bursting';
  else
    neuronstates{model}{3}(gbar_scale, 1) = 'tonic';
  end

  if (mycluster(AB_spikes))
    neuronstates{model}{3}(gbar_scale, 2) = 'bursting';
  else
    neuronstates{model}{3}(gbar_scale, 2) = 'tonic';
  end
end
gbar_title = '';
for i = 1:8
  gbar_title = strcat(gbar_title, int2str(gbar_scale_permutation(gbar_scale, i)));
end
x1_title = ['Model- ', int2str(model), '; gbar- ', gbar_title];
x1.myplot2(x1_title, results_and_spiketimes.PD.V);
x1_filename = strcat('./', dir_title, '/', dir_title, '-', gbar_title, '.png');
saveas(x1.handles.fig, x1_filename);
close all;

end % 3) LOOP THROUGH DIFFERENT GBAR_SCALE
end % 2) LOOP THROUGH AB/PD MODELS 1-5

save('FindPD_neuronstates.mat', 'neuronstates');