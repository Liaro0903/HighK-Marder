% New features is 2:
% 1. Now updating E in synaptic currents
% 2. Now also plotting currents for each conductance

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
conds = {
  'prinz/NaV', 'prinz/CaT', 'prinz/CaS', ...
  'prinz/ACurrent', 'prinz/KCa', 'prinz/Kd', ...
  'prinz/HCurrent', 'Leak'
};

conds_name = {
  'ACurrent', 'CaS', 'CaT', 'HCurrent', ...
  'KCa', 'Kd', 'Leak', 'NaV'
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

for AB = 3:3
for LP = 2:2
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

%% Change to K Potential, leak, and synapses
% Baseline
pot0    = -80;  pot_dV = 10; 
leak_E0 = -50; leak_dV = 5;
glut_E0 = -70; glut_dV = 7.5;

% Looping through potentials
for pot = -80:pot_dV:-60
  % Copy to a new model
  x2 = copy(x1);

  % Calculate new leak and glut
  steps = (pot - pot0) / pot_dV;
  leak_E = leak_E0 + leak_dV * steps;
  glut_E = glut_E0 + glut_dV * steps;

  % Update pot
  for i = 1:length(comps)
    x2.(comps{i}).Kd.E = pot;
    x2.(comps{i}).ACurrent.E = pot;
    x2.(comps{i}).KCa.E = pot;
    x2.(comps{i}).Leak.E = leak_E;
  end

  % x2.PY.KCa.gbar = 32;

  % Adding Synapses
  x2.connect('AB','PY','prinz/Chol','gmax', 3, 'E', pot);
  x2.connect('AB','LP','prinz/Glut','gmax',30, 'E', glut_E);
  x2.connect('AB','PY','prinz/Glut','gmax',10, 'E', glut_E);
  x2.connect('LP','PY','prinz/Glut','gmax', 1, 'E', glut_E);
  x2.connect('PY','LP','prinz/Glut','gmax',30, 'E', glut_E);
  x2.connect('LP','AB','prinz/Glut','gmax',30, 'E', glut_E);

  % Snapshot x2
  x2.snapshot('x2');

  % Integrate, plot network, and save figure
  x2_title = [dir_title, '- E_K: ', int2str(pot), '; E_L: ', int2str(leak_E), '; E_{glut}: ', num2str(glut_E), '; E_{chol}: ', int2str(pot)];
  x2.myplot(x2_title);
  % x2.plot();
  % x2.manipulate('*gbar');
  % x2_filename = ['./', dir_title, '/', dir_title, int2str(pot), int2str(leak_E*-1), num2str(glut_E*-1), '.png'];
  % saveas(x2.handles.fig, x2_filename, 'png');

  % Reset to x2
  % x2.reset('x2');

  % Integrating, plot currents, and save figure
  % x2.output_type = 1;
  % x2_results = x2.integrate;
  % V_AB = x2_results.AB.V;
   
  % tvec = 0.1:x0.sim_dt:x0.t_end;
  % tvec = tvec.';

  % figure('outerposition', [0 0 1200 1200]); 
  % x2_currents_fig = subplot(length(conds_name)+1, 1, 1);
  % plot(tvec, V_AB, 'LineWidth', 1.5);
  % box off;
  % title('V_{AB}');
  % %% 2/22/2022, there might be an error here that I didn't see.
  % for i = 1:length(conds_name)
  %   subplot(length(conds_name)+1, 1, i+1);
  %   plot(tvec, x2_results.AB.(conds_name{i}).I, 'Color', 'k', 'LineWidth', 1.5);
  %   box off;
  %   title(conds_name{i});
  % end
  % sgtitle(x2_title);
  % x2_filename = ['./', dir_title, '/', dir_title, int2str(pot), int2str(leak_E*-1), num2str(glut_E*-1), '_I.png'];
  % saveas(x2_currents_fig, x2_filename);
    
  % close all;
end

end
end
end


