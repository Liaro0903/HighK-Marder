% Test file for plotting activation curve
clear; close all;

hx = HKX(10000, -50, 24);
hx.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', 1);

Vrange = [-80, -40];
ac_shifts = [0, 3];
plot_hp = true;
legend_titles = ["Control", "Late High [K^+]"];

figure('outerposition',[0 0 1000 600],'PaperUnits','points','PaperSize',[1000 1030]); hold on;
tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

nexttile;
Y_m = hk_plots.plot_ac(hx.x.PD.ACurrent, Vrange, 'h_inf', ac_shifts, plot_hp, legend_titles);

Vrange = [-55, -5];
ac_shifts = [0, 5, 10];
plot_hp = true;
legend_titles = ["ΔV = 0mV", "ΔV = -5mV", "ΔV = -10mV"];

nexttile;
hk_plots.plot_ac(hx.x.PD.KCa, Vrange, "m_inf", ac_shifts, plot_hp, legend_titles);

axis square
figlib.pretty();
