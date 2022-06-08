%% Reset
clear;
close all;

x = xolotl;
x.add('compartment', 'LC', 'A', 0.01); % name LC (leak cell) and surface area A 0.01mm^2

x.LC.add('Leak', 'gbar', 1);  % conductance of 1 uS/mm^2. Without specifying E, default value is -55mV (look at source code)

x.t_end = 350; %ms

% I_app Perturbation
input = zeros(x.t_end/x.sim_dt,1);
for i = 1:500
    input(i) = 0;
end
for i = 501:2500
    input(i) = .5;
end
for i = 2501:3500
    input(i) = 0;
end

x.pref.plot_color = true;
% x.pref.show_Ca = true;

x2 = copy(x);

x.I_ext = input;
% x.plot;
x.output_type = 1;
results = x.integrate;

tvec = 0.1:x.sim_dt:x.t_end;
tvec = tvec.';
figure;
plot(tvec, results.LC.V);

figure;
plot(tvec, results.LC.Leak.I);

% This means that V_infinity = E_L + I_app / G_L = -0.055V + 0.5*10^-9A / 1*10^-6uS/mm^2 *
% 0.01mm^2 = -0.005V = -5mV

% Trying to plot the current
% tvec = 0.1:x.sim_dt:x.t_end;
% tvec = tvec.';
figure;
plot(tvec, input);

x2.I_ext = input;
x2.plot;