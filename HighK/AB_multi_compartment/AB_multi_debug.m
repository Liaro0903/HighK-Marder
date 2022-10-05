% The purpose for this file is to just play around and debug without messing the code for AB_multi_traces_sub

% Reset
clear;
close all;

load('FindAB_multi_rand_1.mat');

hx = HKX(5000, -50, 24);
hx.add_pyloric_neuron('ABPD', 'ABsn', 'prinz', 1, 0.12);
hx.add_pyloric_neuron('ABPD', 'axon', 'prinz', 1, 0.0628);
% Delete the channels that we don't want
hx.x.ABsn.NaV.destroy();
hx.x.axon.CaS.destroy();
hx.x.axon.CaT.destroy();
hx.x.axon.HCurrent.destroy();
hx.x.axon.KCa.destroy();
base = 110;
hx.connect_ABPD('ABsn', 'axon', base, base);

model = 6;

hx.x.set([hx.x.find('axon*gbar'); hx.x.find('ABsn*gbar')], params(:, model));

hx.setKPot(-56);

hx.x.plot();
hx.x.manipulate;