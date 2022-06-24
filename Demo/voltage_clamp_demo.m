% This was an example I created to see the activation_inf change by using a voltage clamp experiment.
% TODO: Do out the math in this example

clear;
close all;

x = xolotl;
x.add('compartment', 'HH', 'A', .01); % name HH (hodgkin-huxley) and surface area A 0.01mm^2

% x.HH.add('prinz/NaV', 'gbar', 1e3, 'E', 30);  % 1e3 means max conductance of 1000 uS/mm^2
x.HH.add('liu/Kd', 'gbar', 300, 'E', -80);
% x.HH.add('Leak', 'gbar', 1);

x.t_end = 500;

% x.I_ext = 0.2;

% If want to see what it looks like
% x.pref.plot_color = true;
% x.pref.show_Ca = false;
% x.plot();

x.snapshot('initial');

for pot = -100:10:30
  x.V_clamp = pot;
  I = x.integrate;
  time = (1:length(I))*x.dt*1e-3;
  plot(time,I);
  hold on;
  x.reset('initial');
end
% set(gca,'XScale','log');
ylabel('I_{clamp} (nA)');
xlabel('Time (s)');