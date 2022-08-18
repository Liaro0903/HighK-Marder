% A search on the 5 prinz models

% Reset
clear;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 1) INITIAL SETUP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x0 = xolotl;

% set up neuronstates
neuronstates = cell(5, 1);
min_PD_A_gbar = cell(5, 1); % for recording what's the min value for gbar at each synaptic strength
for i = 1:5
  neuronstates{i} = strings((500 - 10) / 10 + 1, 8);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 2) LOOP THROUGH AB/PD MODELS 1-5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
parfor model = 1:5 % use parallal 
% for model = 1:5 % full version
disp(model);

x1 = copy(x0);

% Set up AB and PD
x1 = PD(x1, 'PD', model, 5000, 0.12);
x1 = PD(x1, 'AB', model, 5000, 0.12);
x1.set({'AB.NaV.gbar', 'PD.KCa.gbar'}, [0 0]);

dir_title = ['FindABcoupledPD- ', int2str(model)];
if ~exist(dir_title, 'dir')
  mkdir(dir_title);
end

my_min_PD_A_gbar = zeros(50, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 3) LOOP THROUGH DIFFERENT SYNAPTIC GMAX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Connect
synapse_type = 'Electrical';

for base = 10:10:500 % debug mode
% for base = 10:10:500 % full version
disp(base);

x2 = copy(x1);

all_ABPD_V = zeros(x0.t_end * 10, 4);
B_freq_before = 0;
B_freq_after = 0;

% Part 1: Integrate pre-connection
x2 = setPotential(x2, -80, 24, ["AB" "PD"]);
results_and_spiketimes = x2.integrate;
all_ABPD_V(1:50000, 1) = results_and_spiketimes.AB.V;
all_ABPD_V(1:50000, 2) = results_and_spiketimes.PD.V;

% Part 2: Integrate with connecting
x2.connect('AB','PD', synapse_type, 'gmax', base * 4);
x2.connect('PD','AB', synapse_type, 'gmax', base);
results_and_spiketimes = x2.integrate;
all_ABPD_V(50001:100000, 1) = results_and_spiketimes.AB.V;
all_ABPD_V(50001:100000, 2) = results_and_spiketimes.PD.V; 
[IBI, B_freq] = burstinginterval(filter_spike_times(results_and_spiketimes.PD.spiketimes, 10000));
B_freq_before = B_freq;

% Part 3: Integrate with connecting at high K
x2 = setPotential(x2, -56, 24, ["AB" "PD"]);
results_and_spiketimes = x2.integrate;
all_ABPD_V(1:50000, 3) = results_and_spiketimes.AB.V;
all_ABPD_V(1:50000, 4) = results_and_spiketimes.PD.V;

% Part 4: Finding minimal gbar up regulation to burst again at high K
PD_A_gbar0 = x2.PD.ACurrent.gbar;
bot = 0;
top = 20;
mid = 0;

while(top - bot > 0.1)
  mid = (bot + top) / 2;
  disp(mid);
  x2.set('PD.ACurrent.gbar', PD_A_gbar0 * mid);
  % x2.myplot('hi');
  results_and_spiketimes = x2.integrate;
  PD_spikes = filter_spike_times(results_and_spiketimes.PD.spiketimes, 10000);
  state = diff2000(PD_spikes);
  if state~= "tonic"
    top = mid;
    % disp('go lower')
  else
    bot = mid;
    % disp('go higher')
  end
end

% x2.PD.ACurrent.gbar = x2.PD.ACurrent.gbar * 10;
% x2.AB.ACurrent.gbar = x2.AB.ACurrent.gbar * 1.67;
% x2.AB.ACurrent.gbar = x2.AB.ACurrent.gbar * 2;
% x2.AB.CaS.gbar = x2.AB.CaS.gbar - 20;
% x2.AB.CaT.gbar = x2.AB.CaT.gbar - 5;
% results_and_spiketimes = x2.integrate;
all_ABPD_V(50001:100000, 3) = results_and_spiketimes.AB.V;
all_ABPD_V(50001:100000, 4) = results_and_spiketimes.PD.V;
% [IBI, B_freq] = burstinginterval(filter_spike_times(results_and_spiketimes.PD.spiketimes, 10000));
% B_freq_after = B_freq; 
  
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

x2_title = {
  ['Model ', int2str(model)], ...
  'Initial gmax: AB.NaV * 0 | PD.KCa * 0', ...
  ['Synaptic gmax AB-PD: ', int2str(base * 4), ' | gmax PD-AB: ', int2str(base)], ...
  ['Bursting freq before: ', num2str(B_freq_before), ' | Bursting freq after: ', num2str(B_freq_after)], ...
  ['Change of gmax at -56mV: PD.Acurrent * ', num2str(mid)],
};
x2.myplot2(x2_title, all_ABPD_V, {'AB80', 'PD80', 'AB70', 'PD70'});
x2_filename = strcat('./', dir_title, '/', int2str(model), '- ', int2str(base), '.png');
saveas(x2.handles.fig, x2_filename);
my_min_PD_A_gbar(base / 10) = mid;

% close all;
end % 3 LOOP THROUGH DIFFERENT SYNAPTIC GMAX

min_PD_A_gbar{model} = my_min_PD_A_gbar;

end % 2 LOOP THROUGH AB/PD MODELS 1-5
t = toc;

% save('FindABcoupledPD_neuronstates.mat', 'neuronstates');