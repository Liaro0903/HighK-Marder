%% Reset
clear;
close all;


x = xolotl;
x.add('compartment', 'HH', 'A', .01); % name HH (hodgkin-huxley) and surface area A 0.01mm^2

x.HH.add('liu/NaV', 'gbar', 1e3, 'E', 30);  % 1e3 means max conductance of 1000 uS/mm^2
x.HH.add('liu/Kd', 'gbar', 300, 'E', -80);
x.HH.add('Leak', 'gbar', 1);

x.t_end = 100; %ms
% x.plot;

x.pref.plot_color = true;
x.I_ext = .2; %nA

x2 = copy(x);

x.output_type = 1;
results = x.integrate;

% x.plot;

tvec = 0.1:x.sim_dt:x.t_end;
tvec = tvec.';
figure;
plot(tvec, results.HH.V);
title('V');

figure;
subplot(3,1,1);
plot(tvec, results.HH.Leak.I);
hold on;
title('Leak');

% figure;
% subplot(3,1,2);
subplot(3,1,2);
plot(tvec, results.HH.NaV.I);
hold on;
title('NaV');

% figure;
subplot(3,1,3);
% subplot(3,1,3);
plot(tvec, results.HH.Kd.I);
title('Kd');


% x.manipulate('*gbar');
x2.I_ext = .2;

[V, Ca, ~, currents] = x2.integrate;
V2 = [V; V];
Ca2 = [Ca; Ca];
currents2 = [currents; currents];
x2.myplot2('x2', V2, Ca2, currents2);
