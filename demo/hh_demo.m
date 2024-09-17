% This demo 

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
x.pref.show_Ca = false;
x.I_ext = .2; %nA

x.plot;
