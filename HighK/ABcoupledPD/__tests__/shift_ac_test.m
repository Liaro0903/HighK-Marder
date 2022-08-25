% Code to check if shifting curves of prinz-ac conductances are working correctly

clear;
close all;

hx = HKX(10000, -50, 24);
hx.add_pyloric_neuron('ABPD', 'PD', 'prinz', 1, 0.12);
hx.x.myplot('Original prinz');

hx1 = HKX(10000, -50, 24);
hx1.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', 1, 0.12);
hx1.x.myplot('With prinz-ac, but have not shift curve yet'); % hx1 and x should have the same graph

hx2 = HKX(10000, -50, 24);
hx2.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', 1, 0.12);
NaV_gbar = hx2.x.PD.NaV.gbar;
hx2.x.PD.NaV.destroy();
hx2.x.PD.add('prinz-ac/NaV', 'gbar', NaV_gbar, 'ac_shift_m', 4, 'ac_shift_h', -4);
hx2.x.myplot('With prinz-ac, shifts m and h'); 