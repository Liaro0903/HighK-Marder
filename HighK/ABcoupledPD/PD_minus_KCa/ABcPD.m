% The no loops version of FindABcoupledPD, for debuggin and testing out parameters

% Rest
clear;
close all;

x0 = xolotl;

% AB
x0.add('compartment', 'AB', 'A', 0.0628); % 0.0628
x0.add('compartment', 'PD', 'A', 0.12);

% Adding conductances
conds = {
  'prinz/NaV', 'prinz/CaT', 'prinz/CaS', ...
  'prinz/ACurrent', 'prinz/KCa', 'prinz/Kd', ...
  'prinz/HCurrent', 'Leak'
};

gbars_raw = readmatrix('gbars.csv');
gbars = gbars_raw(1:5, :);

model = 1;

for i = 1:length(conds)
  if (string(conds{i}) == "prinz/ACurrent")
    x0.AB.add("ian/ACurrent", 'gbar', gbars(model, i));
    x0.PD.add("ian/ACurrent", 'gbar', gbars(model, i));
  else
    if (string(conds{i}) ~= "prinz/NaV")
      x0.AB.add(conds{i}, 'gbar', gbars(model, i));
    end
    x0.PD.add(conds{i}, 'gbar', gbars(model, i));
  end
  
  
end

% Debug mode for each gbar
% x0.PD.ACurrent.gbar = x0.PD.ACurrent.gbar * 2;
% x0.PD.CaS.gbar      = x0.PD.CaS.gbar      * 1;
% x0.PD.CaT.gbar      = x0.PD.CaT.gbar      * 1;
% x0.PD.HCurrent.gbar = x0.PD.HCurrent.gbar * 0;
x0.PD.KCa.gbar      = x0.PD.KCa.gbar      * 0;
% x0.PD.Kd.gbar       = x0.PD.Kd.gbar       * 1;
% x0.PD.NaV.gbar      = x0.PD.NaV.gbar      * 1;
% x0.PD.Leak.gbar     = x0.PD.Leak.gbar     * 1;

% Adding leak E
x0.AB.Leak.E = -50; % mV
x0.PD.Leak.E = -50; % mV

% Adding Calcium Dynamics
x0.AB.add('prinz/CalciumMech');
x0.PD.add('prinz/CalciumMech');

% Connect
synapse_type = 'Electrical';
base = 160;
x0.connect('AB','PD', synapse_type, 'gmax', base * 4);
x0.connect('PD','AB', synapse_type, 'gmax', base);

% Plot
% x0.pref.plot_color = 1;
x0.pref.show_Ca = 0;
x0.t_end = 10000;

% Base case
pot0    = -80;  pot_dV = 24; 
leak_E0 = -50; leak_dV = pot_dV / 2;

pot = -56;
steps = (pot - pot0) / pot_dV;
leak_E = leak_E0 + leak_dV * steps;

x0.AB.Kd.E = pot;
x0.AB.ACurrent.E = pot;
x0.AB.KCa.E = pot;
x0.AB.Leak.E = leak_E;
x0.PD.Kd.E = pot;
x0.PD.ACurrent.E = pot;
x0.PD.KCa.E = pot;
x0.PD.Leak.E = leak_E;

x0.PD.ACurrent.add('ChannelProbe');

% x0.AB.ACurrent.gbar = 4000;
% x0.PD.ACurrent.gbar = 715;

x0.snapshot('initial');

x0.output_type = 2;
results_and_spiketimes = x0.integrate;
tvec = 0.1:x0.sim_dt:x0.t_end;
tvec = tvec.';
figure;
subplot(4, 1, 1);
plot(tvec, results_and_spiketimes.AB.V);
subplot(4, 1, 2);
plot(tvec, results_and_spiketimes.PD.V);
subplot(4, 1, 3);
plot(tvec, results_and_spiketimes.PD.ACurrent.I);
subplot(4, 1, 4);
plot(tvec, results_and_spiketimes.PD.ACurrent.ChannelProbe(:, 1), 'k');
hold on;
plot(tvec, results_and_spiketimes.PD.ACurrent.ChannelProbe(:, 2), 'r');
x0.reset('initial');

x0.output_type = 0;
x0.plot();
x0.manipulate();

% x0.myplot2()  
% filter_time = 50000;
% AB_spikes = filter_spike_times(results_and_spiketimes.PD.spiketimes, filter_time);