% For testing out parameters for just PD, maybe will turn this into a function that can be called later

clear;
close all;

x = xolotl;

% AB and PD
% x.add('compartment', 'AB');
x.add('compartment', 'PD', 'A', 0.12);

% Adding conductances
conds = {
  'ACurrent', 'CaS', 'CaT', ...
  'HCurrent', 'KCa', 'Kd', ...
  'Leak', 'NaV'
};

% gbars_raw = readmatrix('gbars.csv');
% gbars = gbars_raw(1:5, :);

for i = 1:length(conds) 
  if (conds{i} ~= "Leak")
    x.PD.add(['prinz' filesep conds{i}])
  end
end
x.PD.add('Leak');

custom_gbars = [
  461.4818186
  52.82030057
  60.50018482
  0.025404106
  119.8088278
  330.31419
  0.023067317
  0
];

for i = 1:length(conds)
  x.PD.(conds{i}).gbar = custom_gbars(i);
end

% Adding leak E
x.PD.Leak.E = -50; % mV

% Adding Calcium Dynamics
x.PD.add('prinz/CalciumMech');

x.t_end = 10000;

x.pref.show_Ca = 0;
x.snapshot('initial');
x.plot();
x.reset('initial');
x.output_type = 2;
results_and_spiketimes = x.integrate;
% V_filtered = results_and_spiketimes.PD.V(20000:100e3);
V_filtered = results_and_spiketimes.PD.V;
% Ca_filtered = results_and_spiketimes.PD.Ca(20000:100e3);
Ca_filtered = results_and_spiketimes.PD.Ca;
[burst_metrics, spike_times, ~, ~] = xtools.findBurstMetrics(V_filtered, Ca_filtered);
state = detect_burst_state(burst_metrics, spike_times);

N = xtools.findNSpikes(V_filtered, -40);
spike_times = xtools.findNSpikeTimes(V_filtered, N, -40);
