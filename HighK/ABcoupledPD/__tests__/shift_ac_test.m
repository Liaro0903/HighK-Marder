% Code to check if shifting curves of prinz-ac conductances are working correctly

clear;
close all;

x = xolotl;
x = PD(x, 'PD', 'prinz', 1, 10000, 0.12);
x.myplot('Original prinz');

x1 = xolotl;
x1 = PD(x1, 'PD', 'prinz-ac', 1, 10000, 0.12);
x1.myplot('With prinz-ac, but have not shift curve yet');  % x1 and x should have the same graph

x2 = xolotl;
x2 = PD(x2, 'PD', 'prinz-ac', 1, 10000, 0.12);
NaV_gbar = x2.PD.NaV.gbar;
x2.PD.NaV.destroy();
x2.PD.add('prinz-ac/NaV', 'gbar', NaV_gbar, 'ac_shift_m', 4, 'ac_shift_h', -4);
x2.myplot('With prinz-ac, shifts m and h'); 