% The no loops version of FindABcoupledPD_rand, for debugging and testing out parameters.
% Often subject to change due to the data that is being processed 

% Rest
clear;
close all;

load('FindABcPD_rand_high_2.mat');

parameters_to_vary = {
  'AB.ACurrent.gbar', ...
  'AB.CaS.gbar', ...
  'AB.CaT.gbar', ...
  'AB.HCurrent.gbar', ...
  'AB.KCa.gbar', ...
  'AB.Kd.gbar', ...
  'AB.Leak.gbar', ...
  'PD.ACurrent.gbar', ...
  'PD.CaS.gbar', ...
  'PD.CaT.gbar', ...
  'PD.HCurrent.gbar', ...
  'PD.KCa.gbar', ...
  'PD.Kd.gbar', ...
  'PD.Leak.gbar', ...
  'PD.NaV.gbar'
};

% params = [
%   10156.97662
%   1405.461902
%   1525.774192
%   0.331850596
%   2646.384772
%   25848.95074
%   0.68419207
%   18771.15729
%   1417.159625
%   881.2693615
%   3.767675721
%   2623.655281
%   22597.28546
%   3.358789683
%   85219.7604
% ];

% Have to do integrate call outside the parallel loop
x = xolotl;
x = PD(x, 'PD', params(8:15, 1), 5000, 0.12);
x = PD(x, 'AB', [params(1:7, 1); 0], 5000, 0.0628);
x.AB.NaV.destroy();
x = setPotential(x, -80, 24, ["AB" "PD"]);
x.snapshot('initial'); % for parallel search
x.integrate;


% Try to run this in parallel
% Turn on following if you want to do a bunch of params together
% tic
model = 2100; % debug mode
% parfor model = 1:10 % debug mode
% parfor model = 1:length(params) % full version

x.reset('initial');

x.set(parameters_to_vary, params(:, model));

all_ABPD_V = zeros(100000, 4);

% Part 1: Integrate pre-connection
% results_and_spiketimes = x.integrate;
% all_ABPD_V(1:50000, 1) = results_and_spiketimes.AB.V;
% all_ABPD_V(1:50000, 2) = results_and_spiketimes.PD.V;

% Under construction, trying to find frequency
% spike_threshold = -40;
% metrics_AB = xtools.V2metrics(results_and_spiketimes.AB.V, 'spike_threshold', spike_threshold, 'debug', true, 'sampling_rate', 1);
% n_spikes = xtools.findNSpikes(results_and_spiketimes.AB.V, spike_threshold);
% spiketimes = xtools.findNSpikeTimes(results_and_spiketimes.AB.V, n_spikes, spike_threshold);
% metrics_PD = xtools.V2metrics(results_and_spiketimes.PD.V, 'sampling_rate', 1);

% Part 2: Integrate with connection
x1 = copy(x);
synapse_type = 'Electrical';
base = 110;
x1.connect('AB','PD', synapse_type, 'gmax', base * 4);
x1.connect('PD','AB', synapse_type, 'gmax', base);

% results_and_spiketimes = x1.integrate;
% all_ABPD_V(50001:100000, 1) = results_and_spiketimes.AB.V;
% all_ABPD_V(50001:100000, 2) = results_and_spiketimes.PD.V;

% Under construction, trying to find frequency
% metrics_AB = xtools.V2metrics(results_and_spiketimes.AB.V, 'spike_threshold', spike_threshold, 'debug', true, 'sampling_rate', 1);
% n_spikes = xtools.findNSpikes(results_and_spiketimes.AB.V, spike_threshold);
% spiketimes = xtools.findNSpikeTimes(results_and_spiketimes.AB.V, n_spikes, spike_threshold);
% metrics_PD = xtools.V2metrics(results_and_spiketimes.PD.V, 'debug', true, 'sampling_rate', 1);

% Part 3: Integrate at high K
x1.t_end = 10000;
x1 = setPotential(x1, -56, 24, ["AB" "PD"]);
results_and_spiketimes = x1.integrate;
all_ABPD_V(1:100000, 1) = results_and_spiketimes.AB.V;
all_ABPD_V(1:100000, 2) = results_and_spiketimes.PD.V;

% Part 4: Integrate at changing gbars
% x1.set('PD.ACurrent.gbar', 5000);
% x1 = setPotential(x1, -80, 24, ["AB" "PD"]);
% results_and_spiketimes = x1.integrate;
% all_ABPD_V(50001:100000, 3) = results_and_spiketimes.AB.V;
% all_ABPD_V(50001:100000, 4) = results_and_spiketimes.PD.V;

% Part 5: Put it back to -80
x1 = setPotential(x1, -80, 24, ["AB" "PD"]);
results_and_spiketimes = x1.integrate;
all_ABPD_V(1:100000, 3) = results_and_spiketimes.AB.V;
all_ABPD_V(1:100000, 4) = results_and_spiketimes.PD.V;

x.myplot2({['Model ', int2str(model)]}, all_ABPD_V, {'AB80', 'PD80', 'AB70', 'PD70'});
% saveas(x1.handles.fig, ['./data/FindABcPD_rand_1/', num2str(model), '.png']);

% close all;

% end
% t = toc;
