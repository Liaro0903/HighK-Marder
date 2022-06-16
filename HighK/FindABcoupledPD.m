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
x0.t_end = 5000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 2) LOOP THROUGH AB/PD MODELS 1-5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for model = 1:1 % debug
for model = 1:5 % full version
disp(model);

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
% x1.PD.NaV.gbar      = x1.PD.NaV.gbar      * 1;
% x1.PD.CaT.gbar      = x1.PD.CaT.gbar      * 1;
% x1.PD.CaS.gbar      = x1.PD.CaS.gbar      * 1;
% x1.PD.ACurrent.gbar = x1.PD.ACurrent.gbar * 0;
x1.PD.KCa.gbar      = x1.PD.KCa.gbar      * 0;
% x1.PD.Kd.gbar       = x1.PD.Kd.gbar       * 1;
% x1.PD.HCurrent.gbar = x1.PD.HCurrent.gbar * 0;
% x1.PD.Leak.gbar     = x1.PD.Leak.gbar     * 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 3) LOOP THROUGH DIFFERENT SYNAPTIC GMAX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Connect
synapse_type = 'Electrical';

% for base = 100:10:50 % debug mode
for base = 10:10:500 % full version
disp(base);

x2 = copy(x1);

% Plot
% Base case
pot0    = -80;  pot_dV = 10; 
leak_E0 = -50; leak_dV = 5;

all_ABPD_V = zeros(x0.t_end * 10, 4);
B_freq_before = 0;
B_freq_after = 0;

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

  % Plot
  % x2.plot();
  % x2.manipulate(); 

  % myplot2
  x2.output_type = 2;
  results_and_spiketimes = x2.integrate;

  % all_ABPD_V(x2.t_end * steps * 10 + 1: x2.t_end * 10 * (steps + 1), 1) = results_and_spiketimes.AB.V; % save in array for later plotting
  % all_ABPD_V(x2.t_end * steps * 10 + 1: x2.t_end * 10 * (steps + 1), 2) = results_and_spiketimes.PD.V; % save in array for later plotting
  all_ABPD_V(1:50000, 2 * steps + 1) = results_and_spiketimes.AB.V;
  all_ABPD_V(1:50000, 2 * steps + 2) = results_and_spiketimes.PD.V;
  if pot == -80 % get bursting frequency
    x2.connect('AB','PD', synapse_type, 'gmax', base * 4);
    x2.connect('PD','AB', synapse_type, 'gmax', base);
    results_and_spiketimes = x2.integrate;
    all_ABPD_V(50001:100000, 1) = results_and_spiketimes.AB.V;
    all_ABPD_V(50001:100000, 2) = results_and_spiketimes.PD.V; 
    [IBI, B_freq] = burstinginterval(filter_spike_times(results_and_spiketimes.PD.spiketimes, 10000));
    B_freq_before = B_freq;
  end
  if pot == -70 % integrate with the change of gbars
    x2.PD.ACurrent.gbar = x2.PD.ACurrent.gbar * 2;
    % x2.AB.ACurrent.gbar = x2.AB.ACurrent.gbar * 1.67;
    x2.AB.ACurrent.gbar = x2.AB.ACurrent.gbar * 2;
    % x2.AB.CaS.gbar = x2.AB.CaS.gbar - 20;
    % x2.AB.CaT.gbar = x2.AB.CaT.gbar - 5;
    results_and_spiketimes = x2.integrate;
    all_ABPD_V(50001:100000, 3) = results_and_spiketimes.AB.V;
    all_ABPD_V(50001:100000, 4) = results_and_spiketimes.PD.V;
    [IBI, B_freq] = burstinginterval(filter_spike_times(results_and_spiketimes.PD.spiketimes, 10000));
    B_freq_after = B_freq;
  end
  
  % Categorize neuron state
  % filter_time = 50000;
  % AB_spikes = filter_spike_times(results_and_spiketimes.AB.spiketimes, filter_time);
  % PD_spikes = filter_spike_times(results_and_spiketimes.PD.spiketimes, filter_time);

  % neuronstates_index = (base - 10) / 10 + 1;
  % % AB
  % neuronstates{model}(neuronstates_index, 1 + (steps * 4)) = diff2000(AB_spikes);
  % neuronstates{model}(neuronstates_index, 2 + (steps * 4)) = mycluster(AB_spikes);
  % % PD
  % neuronstates{model}(neuronstates_index, 3 + (steps * 4)) = diff2000(PD_spikes);
  % neuronstates{model}(neuronstates_index, 4 + (steps * 4)) = mycluster(PD_spikes);

end

x2_title = {
  ['Model ', int2str(model)],
  'Initial gmax: AB.NaV * 0 | PD.KCa * 0',
  ['Synaptic gmax AB-PD: ', int2str(base * 4), ' | gmax PD-AB: ', int2str(base)],
  ['Bursting freq before: ', num2str(B_freq_before), ' | Bursting freq after: ', num2str(B_freq_after)],
  'change of gmax at -70mV: PD.Acurrent * 2 | AB.Acurrent * 2',
};
x2.myplot2(x2_title, all_ABPD_V, {'AB80', 'PD80', 'AB70', 'PD70'});
x2_filename = strcat('./', dir_title, '/', int2str(model), '- ', int2str(base), '.png');
saveas(x2.handles.fig, x2_filename);

close all;
end % 3 LOOP THROUGH DIFFERENT SYNAPTIC GMAX
end % 2 LOOP THROUGH AB/PD MODELS 1-5

% save('FindABcoupledPD_neuronstates.mat', 'neuronstates');