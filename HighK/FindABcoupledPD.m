% Rest
clear;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 1) INITIAL SETUP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x0 = xolotl;

% AB and PD
x0.add('compartment', 'AB', 'A', 0.0628); % 0.0628
x0.add('compartment', 'PD', 'A', 0.12);

% Conductances
conds = {
  'prinz/NaV', 'prinz/CaT', 'prinz/CaS', ...
  'prinz/ACurrent', 'prinz/KCa', 'prinz/Kd', ...
  'prinz/HCurrent', 'Leak'
};

gbars_raw = readmatrix('gbars.csv');
gbars = gbars_raw(1:5, :);

% Adding Calcium Dynamics
x0.AB.add('prinz/CalciumMech');
x0.PD.add('prinz/CalciumMech');

% set up neuronstates
neuronstates = cell(5, 1);
for i = 1:5
  neuronstates{i} = strings((500 - 10) / 10 + 1, 8);
end

% Other configs
% x0.pref.plot_color = 1;
x0.pref.show_Ca = 0;
x0.t_end = 10000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 2) LOOP THROUGH AB/PD MODELS 1-5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for model = 1:1 % debug

for model = 1:5 % full version

x1 = copy(x0);

dir_title = ['FindABcoupledPD- ', int2str(model)];
if ~exist(dir_title, 'dir')
  mkdir(dir_title);
end

for i = 1:length(conds)
  if (string(conds{i}) ~= "prinz/NaV")
    x1.AB.add(conds{i}, 'gbar', gbars(model, i))
  end
  x1.PD.add(conds{i}, 'gbar', gbars(model, i))
end

% Debug mode for each gbar
% x0.PD.ACurrent.gbar = x0.PD.ACurrent.gbar * 0;
% x0.PD.CaS.gbar      = x0.PD.CaS.gbar      * 1;
% x0.PD.CaT.gbar      = x0.PD.CaT.gbar      * 1;
% x0.PD.HCurrent.gbar = x0.PD.HCurrent.gbar * 0;
x1.PD.KCa.gbar      = x1.PD.KCa.gbar      * 0;
% x0.PD.Kd.gbar       = x0.PD.Kd.gbar       * 1;
% x0.PD.NaV.gbar      = x0.PD.NaV.gbar      * 1;
% x0.PD.Leak.gbar     = x0.PD.Leak.gbar     * 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 3) LOOP THROUGH DIFFERENT SYNAPTIC GMAX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Connect
synapse_type = 'Electrical';

for base = 10:10:50 % debug mode
% for base = 10:10:500 % full version

x2 = copy(x1);

x2.connect('AB','PD', synapse_type, 'gmax', base * 4);
x2.connect('PD','AB', synapse_type, 'gmax', base);

% Plot
% Base case
pot0    = -80;  pot_dV = 10; 
leak_E0 = -50; leak_dV = 5;

all_ABPD_V = zeros(0);

for pot = -80:pot_dV:-70
  steps = (pot - pot0) / pot_dV;
  leak_E = leak_E0 + leak_dV * steps;

  x2.AB.Kd.E = pot;
  x2.AB.ACurrent.E = pot;
  x2.AB.KCa.E = pot;
  x2.AB.Leak.E = leak_E;
  x2.PD.Kd.E = pot;
  x2.PD.ACurrent.E = pot;
  x2.PD.KCa.E = pot;
  x2.PD.Leak.E = leak_E;

  % x0.output_type = 0
  % x0_title = ['Potential: ', int2str(pot), '; Leak: ', int2str(leak_E)];  % strcat("Potential: ", int2str(pot), "; Leak: ", int2str(x_leakE));
  % [~, ~, ~, f] = x0.myplot(x0_title);
  % x0.plot();
  % x0.manipulate();

  x2.output_type = 2;
  results_and_spiketimes = x2.integrate;

  all_ABPD_V(:, 2 * steps + 1) = results_and_spiketimes.AB.V;
  all_ABPD_V(:, 2 * steps + 2) = results_and_spiketimes.PD.V;
  
  filter_time = 50000;
  AB_spikes = filter_spike_times(results_and_spiketimes.AB.spiketimes, filter_time);
  PD_spikes = filter_spike_times(results_and_spiketimes.PD.spiketimes, filter_time);

  neuronstates_index = (base - 10) / 10 + 1;
  % AB
  neuronstates{model}(neuronstates_index, 1 + (steps * 4)) = diff2000(AB_spikes);
  neuronstates{model}(neuronstates_index, 2 + (steps * 4)) = mycluster(AB_spikes);
  % PD
  neuronstates{model}(neuronstates_index, 3 + (steps * 4)) = diff2000(PD_spikes);
  neuronstates{model}(neuronstates_index, 4 + (steps * 4)) = mycluster(PD_spikes);

  % Debug
  % x0.myplot2('Title', [results_and_spiketimes.AB.V, results_and_spiketimes.PD.V]);
end

x2_title = ['Model: ', int2str(model), ' | gmax AB-PD: ', int2str(base * 4), ' | gmax PD-AB: ', int2str(base)];
x2.myplot2(x2_title, all_ABPD_V, {'AB80', 'PD80', 'AB70', 'PD70'});
x2_filename = strcat('./', dir_title, '/', int2str(model), '- ', int2str(base), '.png');
saveas(x2.handles.fig, x2_filename);

% close all;
end % 3 LOOP THROUGH DIFFERENT SYNAPTIC GMAX
end % 2 LOOP THROUGH AB/PD MODELS 1-5

save('FindABcoupledPD_neuronstates.mat', 'neuronstates');