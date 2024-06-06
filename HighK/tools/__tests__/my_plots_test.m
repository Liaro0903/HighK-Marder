% 
clear; close all;

hx = HKX(10000, -50, 24);
hx.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', 1);

Vrange = [-80, -40];
ac_shifts = [0, 3];
plot_hp = true;

figure('outerposition',[0 0 1000 1030],'PaperUnits','points','PaperSize',[1000 1030]); hold on;

Y_m = my_plots.plot_ac(hx.x.PD.ACurrent, Vrange, 'h_inf', ac_shifts, plot_hp);