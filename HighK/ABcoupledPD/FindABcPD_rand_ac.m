clear;
close all;

% 1) Initial setup
x = xolotl;
x = PD(x, 'PD', 'ian', 1, 10000, 0.12);
x = PD(x, 'AB', 'ian', 1, 10000, 0.628);
x.AB.NaV.destroy();
x = setPotential(x, -80, 24, ["AB" "PD"]);

% 2) Do search
p = xfind;
p.x = x;


p.ParameterNames = [p.x.find('*gbar'); p.x.find('*ac_shift_m'); p.x.find('*ac_shift_h')];
p.Upper = [2e3 240 200 0.2 400 5000 0.2 2e3 240 200 0.2 400 5000 0.2 16e3 (10*rand(1, 20) - 5)];
p.Lower = zeros(1, 35);

p.SampleFcn = @p.uniformRandom;

p.SimFcn = @ABcPD_criteria_high;

p.DiscardFcn = @(data) data == 0.0;

% p.parallelSearch;
p.simulate;

% cancel(p.workers);
% [params, data] = p.gather;
