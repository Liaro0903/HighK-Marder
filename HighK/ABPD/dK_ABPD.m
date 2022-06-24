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

gbars_raw = readmatrix('gbars.csv');

% gbars = [
%   4000 25 60 500 100 1000 0.1 0 ; % AB/PD 1 on the paper
%   1000 25 60 500  50 1000 0.1 0 ; % AB/PD 2
%   2000 25 40 500  50  500 0.1 0 ; % AB/PD 3
%   2000 50 40 400  50 1250 0.1 0 ; % AB/PD 4
%   3000 25 20 100  50 1250 0.1 0 ; % AB/PD 5
% ];

gbars = gbars_raw(1:5, :);

model = 1;

for i = 1:length(conds)
  x0.AB.add(conds{i}, 'gbar', gbars(model, i))
end

% Adding leak E
x0.AB.Leak.E = -50; % mV

% Adding Calcium Dynamics
x0.AB.add('prinz/CalciumMech');

% Plot
% x0.pref.plot_color = 1;
x0.pref.show_Ca = 0;
x0.t_end = 10000;

pot0    = -80;  pot_dV = 10; 
leak_E0 = -50; leak_dV = 5;

for pot = -80:pot_dV:-80
  % Copy to a new model
  x1 = copy(x0);

  % Calculate new leak
  steps = (pot - pot0) / pot_dV;
  leak_E = leak_E0 + leak_dV * steps;

  x1.AB.Kd.E = pot;
  x1.AB.ACurrent.E = pot;
  x1.AB.KCa.E = pot;
  x1.AB.Leak.E = leak_E;

  % regular plot
  % x1.plot();
  % x1.manipulate();

  % myplot1
  % x1_title = ['Potential: ', int2str(pot), '; Leak: ', int2str(leak_E)];  % strcat("Potential: ", int2str(pot), "; Leak: ", int2str(x_leakE));
  % x1.myplot(x1_title);

  % myplot2
  x1.output_type = 2;
  results_and_spiketimes = x1.integrate; 
  [IBI, B_freq, ISI] = burstinginterval(results_and_spiketimes.AB.spiketimes);
  x1.myplot2(x1_title, results_and_spiketimes.AB.V);

end
