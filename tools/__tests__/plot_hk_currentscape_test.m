clear; close all;

hx = HKX(10000, -50, 24);
hx.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', 1);
hx.setKPot(-80);

hx2 = hx.copyHKX();

result = hx.x.integrate;

trange = 1:length(hx.x.time);

manipulate = true;

f = figure('outerposition', [0 0 1200 1000]);
tl = tiledlayout(3, 1, 'TileSpacing', 'tight', 'Padding', 'compact');

nexttile;
plot(hx.x.time, result.PD.V);

nexttile;

% Uncomment below for individual use cases / tests, can test with or without manipulate

% Testing with no I
% [~, sum_currents] = hk_plots.hk_currentscape(hx.x);

% Testing timeranges
% [~, sum_currents] = hk_plots.hk_currentscape(hx.x, 'I', result.PD);
% [~, sum_currents] = hk_plots.hk_currentscape(hx.x, 'I', result.PD, 'timeranges', [7 10]);

% Testing plot_sum
% [~, sum_currents] = hk_plots.hk_currentscape(hx.x, 'I', result.PD, 'timerange', [7 10], 'plot_sum', false);
% [~, sum_currents] = hk_plots.hk_currentscape(hx.x, 'I', result.PD, 'timerange', [7 10], 'plot_sum', true);

% Testing plot_mode
% hk_plots.hk_currentscape(hx.x, 'I', result.PD, 'timerange', [7 10], 'plot_sum', true, 'plot_mode', 'multi');
% nexttile;
% hk_plots.hk_currentscape(hx.x, 'I', result.PD, 'timerange', [1 5], 'plot_sum', true, 'plot_mode', 'multi');

% Testing legend
[~, sum_currents] = hk_plots.hk_currentscape(hx.x, 'I', result.PD, 'timeranges', [7 10], 'plot_sum', true, 'make_legend', true);

if manipulate
  hx.x.manipulate_plot_func = {@hk_plots.hk_currentscape};
  hx.x.manipulate('*ac_shift*');
end

figlib.pretty('PlotLineWidth', 1, 'LineWidth', 0.5);

%% Compare with built in currentscape in xolotl

hx2.x.output_type = 0;
hx2.x.currentscape;

% hx2.x.manipulate_plot_func = {@currentscape};
% hx2.x.manipulate('*ac_shift*');