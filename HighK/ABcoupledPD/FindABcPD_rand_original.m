% The original FindABcPD_rand, but it has been converted to a class holding all the methods. Keeping this for reference

clear;
close all;


% 1) Initial setup
x = xolotl;
x = PD(x, 'PD', 'prinz', 1, 10000, 0.12);
x = PD(x, 'AB', 'prinz', 1, 10000, 0.0628);
x.AB.NaV.destroy();
x = setPotential(x, -80, 24, ["AB" "PD"]);
synapse_type = 'Electrical';
x.connect('AB','PD', synapse_type, 'gmax', 0);
x.connect('PD','AB', synapse_type, 'gmax', 0);
x.snapshot('initial');

% 2) Do search
p = xfind;
p.x = x;

p.ParameterNames = p.x.find('*gbar');
% p.Upper = [1e3 120 100 0.2 200 2500 0.2];
% p.Upper = [1e3 120 100 0.2 200 2500 0.2 8e3];
% p.Upper = [1e3 120 100 0.2 200 2500 0.2 1e3 120 100 0.2 200 2500 0.2 8e3];
p.Upper = [2e3 240 200 0.2 400 5000 0.2 2e3 240 200 0.2 400 5000 0.2 16e3];
% p.Upper = [2e3 240 200 0.2 400 5000 0.2 16e3 2e3 240 200 0.2 400 5000 0.2 16e3];
% p.Lower = zeros(7, 1);
% p.Lower = zeros(8, 1);
p.Lower = zeros(15, 1);
% p.Lower = zeros(16, 1);

p.SampleFcn = @p.uniformRandom;

% p.SimFcn = @AB_criteria;
% p.SimFcn = @PD_criteria;
p.SimFcn = @ABcPD_criteria;

p.DiscardFcn = @(data) data == 0.0;

p.parallelSearch;
% p.simulate;

% cancel(p.workers)
% [params, data] = p.gather;