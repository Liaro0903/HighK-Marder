% This is an attempt of attaching models found in ABcPD to the network 

clear;
close all;

load('FindABcPD_rand_3.mat');
% load('FindABcPD_rand_high_7.mat');

% Have to do integrate call outside the parallel loop
x = xolotl;
x = PD(x, 'PD', 'prinz', 1, 5000, 0.12);
x = PD(x, 'AB', 'prinz', 1, 5000, 0.0628);
x.AB.NaV.destroy();
x = setPotential(x, -80, 24, ["AB" "PD"]);
model = 156;
x.set(x.find('*gbar'), params(:, model));

x.add('compartment', 'LP');
x.add('compartment', 'PY');
comps = {'LP', 'PY'};

gbars_raw = readmatrix('gbars.csv');
gbars{1} = gbars_raw(6:10,:);
gbars{2} = gbars_raw(11:16,:);

% Adding Calcium Dynamics
for i = 1:length(comps)
  x.(comps{i}).add('prinz/CalciumMech');
end

for LP = 2:2
for PY = 1:1
select_model = [LP, PY];

x1 = copy(x);

% Adding Conductances
conds = {
  'prinz/NaV', 'prinz/CaT', 'prinz/CaS', ...
  'prinz/ACurrent', 'prinz/KCa', 'prinz/Kd', ...
  'prinz/HCurrent', 'Leak'
};
for i = 1:length(comps)
  m = select_model(i);
  for j = 1:length(conds)
    x1.(comps{i}).add(conds{j}, 'gbar', gbars{i}(m, j));
  end
end

x1.LP.Leak.E = -50; % mV
x1.PY.Leak.E = -50; % mV

synapse_type = 'Electrical';
base = 110;
x1.connect('AB','PD', synapse_type, 'gmax', base * 4);
x1.connect('PD','AB', synapse_type, 'gmax', base);

pot = -80;
glut_E = -70;

x1.connect('PD','PY','prinz/Chol','gmax', 3, 'E', pot);
% x1.connect('PD','LP','prinz/Chol','gmax', 3, 'E', pot);
x1.connect('AB','LP','prinz/Glut','gmax',30, 'E', glut_E);
x1.connect('AB','PY','prinz/Glut','gmax',10, 'E', glut_E);
x1.connect('LP','PY','prinz/Glut','gmax', 1, 'E', glut_E);
x1.connect('PY','LP','prinz/Glut','gmax',30, 'E', glut_E);
x1.connect('LP','PD','prinz/Glut','gmax',30, 'E', glut_E);

x1.myplot(['LP: ', num2str(LP), ' | PY: ', num2str(PY)]);
end
end

