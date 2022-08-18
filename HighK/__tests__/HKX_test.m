% Test file for HKX object
clear;
close all;

hx = HKX(10000, -50, 10); % 10 seconds simulation time and base leak equilibrium at -50
hx.add_pyloric_neuron('ABPD', 'AB', 'prinz', 1); % still works without supplying area (will just use default)
hx.add_pyloric_neuron('LP', 'LP', 'prinz', 2);
hx.add_pyloric_neuron('PY', 'PY', 'prinz', 5);

pot = -80;
glut_E = -80;
hx.x.connect('AB','PY','prinz/Chol','gmax', 3, 'E', pot);
hx.x.connect('AB','LP','prinz/Glut','gmax',30, 'E', glut_E);
hx.x.connect('AB','PY','prinz/Glut','gmax',10, 'E', glut_E);
hx.x.connect('LP','PY','prinz/Glut','gmax', 1, 'E', glut_E);
hx.x.connect('PY','LP','prinz/Glut','gmax',30, 'E', glut_E);
hx.x.connect('LP','AB','prinz/Glut','gmax',30, 'E', glut_E);

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

% Add a case where cond_author is different


% connect default pyloric test