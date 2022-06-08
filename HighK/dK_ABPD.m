% Rest
clear;
close all;

x0 = xolotl;

% AB
x0.add('compartment', 'AB');

% Adding conductances
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

for i = 1:length(conds)
    x0.AB.add(conds{i}, 'gbar', gbars(3, i))
end

% Adding leak E
x0.AB.Leak.E = -50; % mV

% Adding Calcium Dynamics
x0.AB.add('prinz/CalciumMech');

% Plot
% x0.pref.plot_color = 1;
x0.pref.show_Ca = 0;
x0.t_end = 5000;
x_leakE = -50; % mV
for pot = -80:10:-70
    x1 = copy(x0);
    x1.AB.Kd.E = pot;
    x1.AB.ACurrent.E = pot;
    x1.AB.KCa.E = pot;
    x1.AB.Leak.E = x_leakE;
    x1_title = ['Potential: ', int2str(pot), '; Leak: ', int2str(x_leakE)];  % strcat("Potential: ", int2str(pot), "; Leak: ", int2str(x_leakE));
    x1.myplot(x1_title);
    x_leakE = x_leakE + 5;
end
