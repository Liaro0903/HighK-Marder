% Tutorial following the generate database of models using random search guide on xolotl

clear;
close all;

p = xfind;
p.x = xolotl.examples.neurons.BurstingNeuron;

p.ParameterNames = p.x.find('*gbar');
p.Upper = [1e3 200 200 10 500 1e3 10 1e3];
p.Lower = zeros(8, 1);

p.SampleFcn = @p.uniformRandom;

p.SimFcn = @xolotl.firingRate;

p.DiscardFcn = @(data) data <= 0;

% p.parallelSearch; % for parallel computing
% p.simulate;

% [params, data] = p.gather;