% Code to check if shifting curves of liu-ac conductances are working correctly

clear; close all;

%% Original liu
hx = HKX(10000, -50, 24);
hx.add_pyloric_neuron('ABPD', 'PD', 'liu', 1, 0.12);
hx.x.plot;

%% With liu-ac, but have not shift curve yet, hx1 and hx should have the same graph
hx1 = HKX(10000, -50, 24);
hx1.add_pyloric_neuron('ABPD', 'PD', 'liu-ac', 1, 0.12);
hx1.setKPot(-80);
result = hx1.x.integrate;
hx1.x.plot;

%% With liu-ac, shifts m and h, graph should be different
hx2 = HKX(10000, -50, 24);
hx2.add_pyloric_neuron('ABPD', 'PD', 'liu-ac', 1, 0.12);
NaV_gbar = hx2.x.PD.NaV.gbar;
hx2.x.PD.NaV.destroy();
hx2.x.PD.add('liu-ac/NaV', 'gbar', NaV_gbar, 'ac_shift_m', 4, 'ac_shift_h', -7);
hx2.setKPot(-80);
hx2.x.plot;

%% With manipulate function
hx3 = HKX(10000, -50, 24);
hx3.add_pyloric_neuron('ABPD', 'PD', 'liu-ac', 1, 0.12);
NaV_gbar = hx3.x.PD.NaV.gbar;
hx3.x.PD.NaV.destroy();
hx3.x.PD.add('liu-ac/NaV', 'gbar', NaV_gbar, 'ac_shift_m', 4, 'ac_shift_h', -7);
hx3.setKPot(-80);
hx3.x.plot;
hx3.x.manipulate('*ac_shift*');