% This basically prints out the f2 trace in ABcPD_traces_sub or ABcPD_traces_tight
% The purpose for this file is to just play around and debug without messing the code for ABcPD_traces

% Reset
clear;
close all;

load('FindABcPD_rand_ac_1.mat');

hx = HKX(10000, -50, 24);
hx.add_pyloric_neuron('ABPD', 'AB', 'prinz-ac', 1, 0.0628);
hx.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', 1, 0.12);
hx.x.AB.NaV.destroy();
base = 110;
hx.connect_ABPD('AB', 'PD', base * 4, base);

model = 3;
hx.x.set([hx.x.find('*gbar'); hx.x.find('*ac_shift_m'); hx.x.find('*ac_shift_h')], params(:, model));

hx.x.plot();
hx.x.manipulate;
