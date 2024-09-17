% This demo is just a injected with some currents
% 

clear;
close all;

% Setup
x = xolotl;
x.add('compartment', 'LC', 'A', 0.01); % name LC (leak cell) and surface area A 0.01mm^2
x.LC.add('Leak', 'gbar', 1);  % conductance of 1 uS/mm^2. Without specifying E, default value is -55mV (look at source code)
x.t_end = 400; % ms

x.pref.plot_color = false;
x.pref.show_Ca = false;

% I_app
input = zeros(x.t_end/x.sim_dt, 1);
for i = 1:1000
  input(i) = 0;
end
for i = 1001:3000
  input(i) = .5;
end
for i = 3001:4000
  input(i) = 0;
end

% I_app visualization
tvec = 0.1:x.sim_dt:x.t_end;
tvec = tvec.';
figure('outerposition', [0 550 1200 400], 'PaperUnits', 'points', 'PaperSize', [1200 400]);
plot(tvec./1000, input);
title('I_{app}');
xlabel('Time (s)');
ylabel('Current (nA)');
ylim([-0.05 0.6]);

figlib.pretty('PlotLineWidth', 1, 'LineWidth', 0.5);

x.I_ext = input;
x.plot;

% This means that V_infinity = E_L + I_app / G_L = -0.055V + 0.5*10^-9A / 1*10^-6uS/mm^2 *
% 0.01mm^2 = -0.005V = -5mV
