% Reset
clear;
close all;

x = xolotl;
x = PD(x, 'PD', 1, 10000, 0.12);
x = PD(x, 'AB', 1, 10000, 0.0628);
x.AB.NaV.destroy();
x = setPotential(x, -56, 24, ["AB" "PD"]);
synapse_type = 'Electrical';
base = 110;
x.connect('AB','PD', synapse_type, 'gmax', base * 4);
x.connect('PD','AB', synapse_type, 'gmax', base);

x.set('PD.ACurrent.gbar', 4000);

qualifies = ABcPD_criteria_high(x);