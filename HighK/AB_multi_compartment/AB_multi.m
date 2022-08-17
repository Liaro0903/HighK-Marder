clear;
close all;

load('FindAB_multi_rand_1.mat');

x = xolotl;
x = PD(x, 'ABsn', 'prinz', 1, 10000, 0.12);
x = PD(x, 'ABaxon', 'prinz', 1, 10000, 0.0628);
x = setPotential(x, -80, 24, ["ABsn" "ABaxon"]);
x.ABsn.NaV.destroy();
x.ABaxon.CaS.destroy();
x.ABaxon.CaT.destroy();
x.ABaxon.HCurrent.destroy();
x.ABaxon.KCa.destroy();

x.set(x.find('*gbar'), params(:, 2)); 

synapse_type = 'Electrical';
x.connect('ABsn','ABaxon', synapse_type, 'gmax', 110);
x.connect('ABaxon','ABsn', synapse_type, 'gmax', 110);
x.snapshot('initial');

results_and_spiketimes = x.integrate;
% ABsn_V = results_and_spiketimes.ABsn.V(50001:100000);
ABsn_V = results_and_spiketimes.ABsn.V;
% ABaxon_V = results_and_spiketimes.ABaxon.V(50001:100000);
ABaxon_V = results_and_spiketimes.ABaxon.V;

ABsn_n_spikes = xtools.findNSpikes(ABsn_V, -40);
ABsn_spiketimes = xtools.findNSpikeTimes(ABsn_V, ABsn_n_spikes, -40);
ABaxon_n_spikes = xtools.findNSpikes(ABaxon_V);
ABaxon_spiketimes = xtools.findNSpikeTimes(ABaxon_V, ABaxon_n_spikes);

metrics_ABsn = xtools.V2metrics(ABsn_V, 'spike_threshold', -40, 'sampling_rate', 1, 'ibi_thresh', 1000);
metrics_ABaxon = xtools.V2metrics(ABaxon_V, 'sampling_rate', 1, 'ibi_thresh', 1000);

disp([
  'n_spikes_ABaxon: ', num2str(metrics_ABaxon.n_spikes_per_burst_mean) ...
  ' | PD_ibi_mean: ', num2str(metrics_ABaxon.ibi_mean) ...
  ' | PD_ibi_std: ', num2str(metrics_ABaxon.ibi_std) ...
]);

% x.myplot2({'hi'}, [ABsn_V, ABaxon_V], {'ABsn', 'ABaxon'});
x.plot();
% x.manipulate();

x = setPotential(x, -56, 24, ["ABsn", "ABaxon"]);
x.plot();