%% Reset
clear;
close all;


x = xolotl;
x.add('compartment', 'HH', 'A', .01); % name HH (hodgkin-huxley) and surface area A 0.01mm^2

x.HH.add('prinz-ac/NaV', 'gbar', 1e3, 'E', 30);
% x.HH.add('prinz/NaV', 'gbar', 1e3, 'E', 30);
x.HH.add('prinz-ac/Kd', 'gbar', 300, 'E', -80);
% x.HH.add('prinz/Kd', 'gbar', 300, 'E', -80);
x.HH.add('Leak', 'gbar', 1);

% let's probe the NaV channel
x.HH.NaV.add('ChannelProbe');
% x.HH.NaV.add('ian/ACProbe');
% x.HH.NaV.add('ian/ACSensor');
% x.HH.Kd.add('ChannelProbe');
x.HH.Kd.add('ian/ACProbe');
x.HH.add('ian/AlphaSensor');
% x.HH.AlphaSensor.add('ian/IanProbe');
% x.HH.add('ian/EkSwitcher');

x.t_end = 100; %ms
x.I_ext = .15; %nA
% x.pref.plot_color = true;
x.output_type = 1;

% [V, Ca, mech_state, I] = x.integrate;
results = x.integrate;

tvec = 0.1:x.sim_dt:x.t_end;
tvec = tvec.';
figure;
plot(tvec, results.HH.V);
% plot(tvec, V);
figure;
plot(tvec, results.HH.NaV.ChannelProbe(:, 1), 'k');
hold on;
plot(tvec, results.HH.NaV.ChannelProbe(:, 2));
figure;
plot(tvec, results.HH.AlphaSensor);

% x.plot;


%%%%%%%%%%%

% load('FindABPD_ac_rand_1.mat');
hx = HKX(10000, -50, 10);
hx.add_pyloric_neuron('ABPD', 'AB', 'prinz-ac', 2);
% hx.x.set([hx.x.find('*ac_shift_m'); hx.x.find('*ac_shift_h')], params(:, 2));
% hx.x.AB.KCa.add('ian/ACSensor', 'tau_AC', 20000, 'ac_shift', hx.x.AB.KCa.ac_shift_m);
hx.x.AB.KCa.add('ian/ACSensor', 'tau_AC', 4000, 'ac_shift', 0);
hx.x.AB.KCa.add('ian/ACProbe');
pot = -56;
E_L = hx.setKPot(pot);
% hx.x.plot;
results_hx = hx.x.integrate;

% tvec = 0.1:hx.x.sim_dt:hx.x.t_end;
% figure;
% plot(tvec, results_hx.AB.V);
% % plot(tvec, V);
% figure;
% plot(tvec, results_hx.AB.KCa.ACProbe(:, 1), 'k');
% hold on;
% plot(tvec, results_hx.AB.KCa.ACProbe(:, 2));


%%%%%%%%%%%%%

hx2 = HKX(40000, -50, 10);
hx2.add_pyloric_neuron('ABPD', 'AB', 'prinz-ac', 2);
hx2.x.AB.add('ian/EkSwitcher');
hx2.x.AB.add('ian/AlphaSensor');
hx2.x.AB.KCa.add('ian/ACSensor');
hx2.x.AB.KCa.ACSensor.add('ian/IanProbe');
pot = -80;
E_L = hx2.setKPot(pot);

results_hx2 = hx2.x.integrate;

tvec = 0.1:hx.x.sim_dt:hx2.x.t_end;
figure;
plot(tvec, results_hx2.AB.V);
% figure;
% plot(tvec, results_hx2.AB.EkSwitcher(:, 1), 'k');
figure;
plot(tvec, results_hx2.AB.AlphaSensor(:, 1), 'k');
figure;
plot(tvec, results_hx2.AB.KCa.ACSensor.IanProbe(:, 1), 'k');
hold on;
plot(tvec, results_hx2.AB.KCa.ACSensor.IanProbe(:, 2), 'k');

%%%%%%%%%%%%%
