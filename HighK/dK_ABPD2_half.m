% New features is 2:
% 1. Now updating E in synaptic currents
% 2. Now also plotting currents for each conductance
% This basically switches potential half way

% Rest
clear;
close all;

x0 = xolotl;

% AB
x0.add('compartment', 'AB');

% Define conductances
conds = {
    'prinz/NaV', 'prinz/CaT', 'prinz/CaS', ...
    'prinz/ACurrent', 'prinz/KCa', 'prinz/Kd', ...
    'prinz/HCurrent', 'Leak'
};

gbars = [
    4000 25 60 500 100 1000 0.1 0 ; % AB/PD 1 on the paper
    1000 25 60 500  50 1000 0.1 0 ; % AB/PD 2
    2000 25 40 500  50  500 0.1 0 ; % AB/PD 3
    2000 50 40 400  50 1250 0.1 0 ; % AB/PD 4
    3000 25 20 100  50 1250 0.1 0 ; % AB/PD 5
];

% Adding Calcium Dynamics
x0.AB.add('prinz/CalciumMech');

%% Plot
x0.t_end = 5000;
x0.pref.show_Ca = 0;

for AB = 1:1

% Set model and directory name
dir_title = ['AB', int2str(AB)];
if ~exist(dir_title, 'dir')
  mkdir(dir_title);
end

x1 = copy(x0);

% Adding Conductances
for i = 1:length(conds)
  x1.AB.add(conds{i}, 'gbar', gbars(AB, i))
end

% Set leak E
x_leak_E = -60; % mV

for pot = -100:10:-40
  % Plot original
  x2 = copy(x1);
  [V, Ca, ~, currents] = x2.integrate;
  % time = x0.dt:x0.dt:x0.t_end;
  % plot(time, V, 'k'); % 'k' means draw black line
  % hold on;


  % Plot updated potential
  x3 = copy(x1);
  x3.AB.V = V(x0.t_end / x0.dt);
  x3.AB.Kd.E = pot;
  x3.AB.ACurrent.E = pot;
  x3.AB.KCa.E = pot;
  % x3.AB.Leak.E = x_leakE;
  [V2, Ca2, ~, currents2] = x3.integrate;
  % figure;
  % plot(time, V2, 'k');
  
  % Combine
  V3 = [V; V2];
  Ca3 = [Ca; Ca2];
  currents3 = [currents; currents2];
  temp_title = strcat(dir_title, "- Potential: ", int2str(pot), "; Leak: ", int2str(x_leakE));
  x3.myplot2(temp_title, V3, Ca3, currents3, x3.t_end*2);
  temp_filename = strcat("./", dir_title, "/", dir_title, int2str(pot), int2str(x_leakE*-1));
  % saveas(x3.handles.fig, temp_filename, 'png'); 
  x_leakE = x_leakE + 5;
  % close all;
end

end