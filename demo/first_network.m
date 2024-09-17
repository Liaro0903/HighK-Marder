%% Reset
clear;
close all;

x = xolotl;

% create three compartments named AB, LP and PY
x.add('compartment', 'AB');
x.add('compartment', 'LP');
x.add('compartment', 'PY');

% Adding conductances
conds = {
    'prinz/NaV', 'prinz/CaT', 'prinz/CaS', ...
    'prinz/ACurrent', 'prinz/KCa', 'prinz/Kd', ...
    'prinz/HCurrent', 'Leak'
};

gbars(:, 1) = [1000, 25, 60, 500, 50, 1000, 0.1,   0]; % Model AB/PD 2 on the paper
gbars(:, 2) = [1000,  0, 40, 200,  0,  250, 0.5, 0.3]; % Model LP 4 on the paper
gbars(:, 3) = [1000, 25, 20, 500,  0, 1250, 0.5, 0.1]; % Model PY 1 on the paper

comps = x.find('compartment'); % Returns 3x1 cell array {'AB'}, {'LP'}, {'PY'}
for i = 1:length(comps)
    for j = 1:length(conds)
        x.(comps{i}).add(conds{j}, 'gbar', gbars(j, i));
    end
end

% Addking leak E
x.AB.Leak.E = -50; % mV
x.LP.Leak.E = -50; % mV
x.PY.Leak.E = -50; % mV

% Adding Calcium Dynamics
for i = 1:length(comps)
    x.(comps{i}).add('prinz/CalciumMech');
end

% Disable show calcium
x.pref.show_Ca = 0;

% Adding Synapses
x.connect('AB','PY','prinz/Chol','gmax',3);
x.connect('AB','LP','prinz/Glut','gmax',30);
x.connect('AB','PY','prinz/Glut','gmax',10);
x.connect('LP','PY','prinz/Glut','gmax',1);
x.connect('PY','LP','prinz/Glut','gmax',30);
x.connect('LP','AB','prinz/Glut','gmax',30);

% Simulating
x.t_end = 5000; % milliseconds
x.plot;

% x.AB.currentscape;
