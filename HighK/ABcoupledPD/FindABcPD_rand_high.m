% This is for the high K simulation

clear;
close all;

% 1) Initial Setup
x = xolotl;
x = PD(x, 'PD', 1, 10000, 0.12);
x = PD(x, 'AB', 1, 10000, 0.0628);
x.AB.NaV.destroy();
x = setPotential(x, -56, 24, ["AB" "PD"]);
synapse_type = 'Electrical';
base = 110;
x.connect('AB','PD', synapse_type, 'gmax', base * 4);
x.connect('PD','AB', synapse_type, 'gmax', base);

% 2) Do search
p = xfind;
p.x = x;

p.ParameterNames = p.x.find('*gbar');
p.Upper = [20000 2400 2000 4 4000 50000 4 20000 2400 2000 4 4000 50000 4 160000];
p.Upper = [2e3 240 200 0.2 400 5000 0.2 2e3 240 200 0.2 400 5000 0.2 16e3];
p.Lower = zeros(15, 1);

p.SampleFcn = @p.uniformRandom;

p.SimFcn = @ABcPD_criteria_high;

p.DiscardFcn = @(data) data == 0.0;

% p.parallelSearch;
p.simulate;

% cancel(p.workers)
% [params, data] = p.gather;