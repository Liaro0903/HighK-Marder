% Test file for HKX object
clear;
close all;

hx = HKX(10000, -50, 10); % 10 seconds simulation time and base leak equilibrium at -50
hx.add_pyloric_neuron('ABPD', 'AB', 'prinz', 1); % still works without supplying area (will just use default)
hx.add_pyloric_neuron('LP', 'LP', 'prinz', 2);
hx.add_pyloric_neuron('PY', 'PY', 'prinz', 5);

custom_gbars = [
  461.4818186
  52.82030057
  60.50018482
  0.025404106
  119.8088278
  330.31419
  0.023067317
  0
];

hx2 = HKX(5000, -65, 24);
hx2.add_pyloric_neuron('ABPD', 'PD', 'prinz', custom_gbars, 0.0628);
hx2.x.plot();

% Test when you add an external xolotl
x = xolotl;
hx3 = HKX(x, -50, 24);

% Add a case where cond_author is different


% connect default pyloric test