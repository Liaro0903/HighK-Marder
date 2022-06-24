% This will try to simulate three phases with different currents

% TODO: Prob try the mesh thing from parallel simulation demo

%% Reset
clear;
close all;

%%%%
%%%% 1) INITIAL SETUP
%%%%

x0 = xolotl;

% create three compartments named AB, LP and PY
x0.add('compartment', 'AB');
x0.add('compartment', 'LP');
x0.add('compartment', 'PY');
comps = x0.find('compartment');

% Read conductances
conds = {
  'prinz/NaV', 'prinz/CaT', 'prinz/CaS', ...
  'prinz/ACurrent', 'prinz/KCa', 'prinz/Kd', ...
  'prinz/HCurrent', 'Leak'
};

conds_name = {
  'ACurrent', 'CaS', 'CaT', 'HCurrent', ...
  'KCa', 'Kd', 'Leak', 'NaV'
};

gbars_raw = readmatrix('gbars.csv');
gbars{1} = gbars_raw(1:5, :);
gbars{2} = gbars_raw(6:10,:);
gbars{3} = gbars_raw(11:16,:);

% Setup gbar permutation matrix
gbar_scales = [1; 2; 3];
gbar_scale_permutation = gbar_scales;
for i = 1:7
  gbar_scale_permutation = setsprod(gbar_scale_permutation, gbar_scales);
end

% Adding Calcium Dynamics
for i = 1:length(comps)
  x0.(comps{i}).add('prinz/CalciumMech');
end

% Simulation Time
x0.t_end = 20000;

% Disable show calcium
x0.pref.show_Ca = 0;

% Read silent models
silent_models = readmatrix('silent_models.csv');

% Setup lists of states
% classdef NeuronState
%   enumeration
%     Silent, Bursting, Tonic
%   end 
% end
neuronstates = strings(length(gbar_scale_permutation), 6);

%%%%
%%%% 2) LOOP THROUGH SLIENT MODELS
%%%%

% for silent_model = 3:length(silent_models)
for silent_model = 14:14

% Set model array and directory name
select_model = silent_models(silent_model, :);
dir_title = '';
for i = 1:length(select_model)
  dir_title = strcat(dir_title, int2str(select_model(i)));
end
if ~exist(dir_title, 'dir')
  mkdir(dir_title);
end

%%%%
%%%% 3) LOOP THROUGH DIFFERENT GBAR_SCALE
%%%%

% for gbar_scale = 2:8 % for gbar_scale all
% for gbar_scale = 1:10 % for gbar_scale permutation debug mode
for gbar_scale = 1:length(gbar_scale_permutation) % for gbar_scale permutation all
disp(gbar_scale);

% Copy to a new model, x1 is the -80 simulation (for now -70mV)
x1 = copy(x0);

% Adding Conductances
for i = 1:length(comps)
  m = select_model(i);
  for j = 1:length(conds)
    if (i == 1)  % if the compartment is AB
      % disp(gbar_scale_permutation(gbar_scale, j) * gbars{i}(m, j));
      x1.(comps{i}).add(conds{j}, 'gbar', gbar_scale_permutation(gbar_scale, j) * gbars{i}(m, j));
    else
      x1.(comps{i}).add(conds{j}, 'gbar', gbars{i}(m, j));
    end
  end 
end

% Debug mode for each gbar
% x1.AB.ACurrent.gbar = x1.AB.ACurrent.gbar * 2.9;
% x1.AB.CaS.gbar      = x1.AB.CaS.gbar      * 3;
% x1.AB.CaT.gbar      = x1.AB.CaT.gbar      * 3;
% % x1.AB.HCurrent.gbar = x1.AB.HCurrent.gbar * 3;
% x1.AB.KCa.gbar      = x1.AB.KCa.gbar      * 3;
% x1.AB.Kd.gbar       = x1.AB.Kd.gbar       * 3;
% x1.AB.NaV.gbar      = x1.AB.NaV.gbar      * 3;
% x1.AB.Leak.gbar     = x1.AB.Leak.gbar     * 3;

% Notes: to simulate tonic, you can do CaS * 3, NaV * 1.5, and Leak * 2

% x1.LP.ACurrent.gbar = x1.LP.ACurrent.gbar * 7;
% x1.LP.CaS.gbar      = x1.LP.CaS.gbar      * 7;
% x1.LP.CaT.gbar      = x1.LP.CaT.gbar      * 7;
% x1.LP.HCurrent.gbar = x1.LP.HCurrent.gbar * 7;
% x1.LP.KCa.gbar      = x1.LP.KCa.gbar      * 7;
% x1.LP.Kd.gbar       = x1.LP.Kd.gbar       * 7;
% x1.LP.NaV.gbar      = x1.LP.NaV.gbar      * 7;

% x1.PY.ACurrent.gbar = x1.PY.ACurrent.gbar * 7;
% x1.PY.CaS.gbar      = x1.PY.CaS.gbar      * 7;
% x1.PY.CaT.gbar      = x1.PY.CaT.gbar      * 7;
% x1.PY.HCurrent.gbar = x1.PY.HCurrent.gbar * 7;
% x1.PY.KCa.gbar      = x1.PY.KCa.gbar      * 7;
% x1.PY.Kd.gbar       = x1.PY.Kd.gbar       * 7;
% x1.PY.NaV.gbar      = x1.PY.NaV.gbar      * 7;


% Set potential
pot0    = -80;  pot_dV = 10;
leak_E0 = -50; leak_dV = 5;
glut_E0 = -70; glut_dV = 7.5;

% % Temp for -70 testing 
pot0 = pot0 + pot_dV;
leak_E0 = leak_E0 + leak_dV;
glut_E0 = glut_E0 + glut_dV;

for i = 1:length(comps)
  x1.(comps{i}).Kd.E = pot0;
  x1.(comps{i}).ACurrent.E = pot0;
  x1.(comps{i}).KCa.E = pot0;
  x1.(comps{i}).Leak.E = leak_E0;
end

% Adding synapses
x1.connect('AB','PY','prinz/Chol','gmax', 3, 'E', pot0);
x1.connect('AB','LP','prinz/Glut','gmax',30, 'E', glut_E0);
x1.connect('AB','PY','prinz/Glut','gmax',10, 'E', glut_E0);
x1.connect('LP','PY','prinz/Glut','gmax', 1, 'E', glut_E0);
x1.connect('PY','LP','prinz/Glut','gmax',30, 'E', glut_E0);
x1.connect('LP','AB','prinz/Glut','gmax',30, 'E', glut_E0);

% snapshot
x1.snapshot('initial')

% integrate with output_type 0
% x1.output_type = 0;
% [V, Ca, ~, currents] = x1.integrate;
% x1.myplot2('hi', V, Ca, currents);
% x1.reset('initial');

% integrate with output_type 1
% x1.output_type = 1;
% results_and_spiketimes = x1.integrate;
% x1.reset('initial');

% integrate with output_type 2
% x1.output_type = 2;
% results_and_spiketimes = x1.integrate;
% filter_time = 100000;
% AB_spikes = filter_spike_times(results_and_spiketimes.AB.spiketimes, filter_time);
% LP_spikes = filter_spike_times(results_and_spiketimes.LP.spiketimes, filter_time);
% PY_spikes = filter_spike_times(results_and_spiketimes.PY.spiketimes, filter_time);

% New syntax for categorizing, but I just added here haven't tested yet
% ABPD
% neuronstates(gbar_scale, 1) = diff2000(AB_spikes);
% neuronstates(gbar_scale, 2) = mycluster(AB_spikes);
% LP
% neuronstates(gbar_scale, 3) = diff2000(LP_spikes);
% neuronstates(gbar_scale, 4) = mycluster(LP_spikes);
% PY
% neuronstates(gbar_scale, 5) = diff2000(PY_spikes);
% neuronstates(gbar_scale, 6) = mycluster(PY_spikes);

x1.reset('initial');

% Debug mode
% x1.plot();
% x1.manipulate();

% Make plot title, plot, and, save file

% gbar_scale all
% plot_title = ['Model ', dir_title, ', -70mV, gbar x ', int2str(gbar_scale)];
% x1.myplot(plot_title);
% x1_filename = ['./', dir_title, '/', dir_title, '-gbar x ', int2str(gbar_scale), '.png'];
% saveas(x1.handles.fig, x1_filename);
% close all;

% gbar_scale with permutation
plot_title = '';
for i = 1:8
  plot_title = strcat(plot_title, int2str(gbar_scale_permutation(gbar_scale, i)));
end
x1.myplot(plot_title);
x1_filename = strcat('./', dir_title, '/', dir_title, '-', plot_title, '.png');
saveas(x1.handles.fig, x1_filename);
close all;

% reset
% x1.reset('initial');

end % (3) gbar_scale for loop
end % (2) silent model for loop
