clear;
close all;

x = load('spiketimes_sample.mat');
AB_spikes = x.AB_spikes;
AB_spikes_lite = AB_spikes(151:160);

x1 = filter_spike_times(AB_spikes, 60000);
x2 = filter_spike_times(AB_spikes, 50000);
x3 = filter_spike_times(AB_spikes, 578);
x4 = filter_spike_times(AB_spikes, 199981);