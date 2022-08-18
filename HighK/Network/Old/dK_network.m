%% Reset
clear;
close all;

x0 = xolotl;

% create three compartments named AB, LP and PY
x0.add('compartment', 'AB');
x0.add('compartment', 'LP');
x0.add('compartment', 'PY');
comps = x0.find('compartment');

% Read conductances
% conds = {
%   'prinz/NaV', 'prinz/CaT', 'prinz/CaS', ...
%   'prinz/ACurrent', 'prinz/KCa', 'prinz/Kd', ...
%   'prinz/HCurrent', 'Leak'
% };

conds = {
  'prinz/ACurrent', 'prinz/CaS', 'prinz/CaT', ...
  'prinz/HCurrent', 'prinz/KCa', 'prinz/Kd', ...
  'Leak', 'prinz/NaV'
};

gbars_raw = readmatrix('gbars.csv');
gbars{1} = gbars_raw(1:5, :);
gbars{2} = gbars_raw(6:10,:);
gbars{3} = gbars_raw(11:16,:);

% Adding Calcium Dynamics
for i = 1:length(comps)
  x0.(comps{i}).add('prinz/CalciumMech');
end

% Simulation Time
x0.t_end = 10000;

% Disable show calcium
x0.pref.show_Ca = 0;

for AB = 2:2
for LP = 4:4
for PY = 1:1

% Set model array and directory name
select_model = [AB, LP, PY];
dir_title = '';
for i = 1:length(select_model)
  dir_title = strcat(dir_title, int2str(select_model(i)));
end
if ~exist(dir_title, 'dir')
  mkdir(dir_title);
end

% Copy to a new model
x1 = copy(x0);

% Adding Conductances
for i = 1:length(comps)
  m = select_model(i);
  for j = 1:length(conds)
    x1.(comps{i}).add(conds{j}, 'gbar', gbars{i}(m, j));
  end
end

% Change to K Potential and Leak
x1_leak_E = -60; % mV
% x1_leak_E = -50; % mV
for pot = -100:10:-40
    x2 = copy(x1);
    % Update pot
    for i = 1:length(comps)
        x2.(comps{i}).Kd.E = pot;
        x2.(comps{i}).ACurrent.E = pot;
        x2.(comps{i}).KCa.E = pot;
        x2.(comps{i}).Leak.E = x1_leak_E;
    end
    % Adding Synapses
    x2.connect('AB','PY','prinz/Chol','gmax',3);
    x2.connect('AB','LP','prinz/Glut','gmax',30);
    x2.connect('AB','PY','prinz/Glut','gmax',10);
    x2.connect('LP','PY','prinz/Glut','gmax',1);
    x2.connect('PY','LP','prinz/Glut','gmax',30);
    x2.connect('LP','AB','prinz/Glut','gmax',30);
    % Printing out
    x2_title = [dir_title, '- Potentials: ', int2str(pot), '; Leak: ', int2str(x1_leak_E)];
    x2.myplot(x2_title);
    x2_filename = ['./', dir_title, '/', dir_title, int2str(pot), int2str(x1_leak_E*-1), '.png'];
    % saveas(x2.handles.fig, x2_filename, 'png');
    x1_leak_E = x1_leak_E + 5;
    % close all;
end

end
end
end