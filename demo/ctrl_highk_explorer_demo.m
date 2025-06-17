clear; close all;

hx0 = HKX(10000, -50, 24);
hx0.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', 1);
hx0.setKPot(-80);

hx_ctrl = hx0.copyHKX();
hx_highK = hx0.copyHKX();
hx_highK.setKPot(-56);

res_ctrl = hx_ctrl.x.integrate;
res_highK = hx_highK.x.integrate;

f = figure('outerposition',[0 0 1800 1200]);
tl = tiledlayout(4, 2, 'TileSpacing', 'tight', 'Padding', 'compact');

time = hx_ctrl.x.time;
timerange = 6*1e4:10*1e4;

nexttile;
plot(time(timerange), res_ctrl.PD.V(timerange));
title('Control');

nexttile;
plot(time(timerange), res_highK.PD.V(timerange));
title('High [K^+]');

nexttile;
hk_plots.hk_currentscape(hx_ctrl.x, 'I', res_ctrl.PD, 'timeranges', [6 10]);

nexttile;
hk_plots.hk_currentscape(hx_highK.x, 'I', res_highK.PD, 'timeranges', [6 10]);

% hx0.x.integrate;
hx0.x.manipulate_plot_func = {@ctrl_highk_plot_fn};

hx0.x.manipulate('*ac_shift_*');

figlib.pretty('PlotLineWidth', 1, 'LineWidth', 0.5);

function ctrl_highk_plot_fn(x)

  %% Integrate
  hx = HKX(x, -50, 24);
  hx2 = hx.copyHKX();

  hx.setKPot(-80);
  hx2.setKPot(-56);

  t80 = hx.x.time;
  t56 = hx2.x.time;
  timerange = 6*1e4:10*1e4;

  results_ctrl = hx.x.integrate;
  results_highK = hx2.x.integrate;

  V80 = results_ctrl.PD.V;
  V56 = results_highK.PD.V;

  %% Plotting

  if isempty(x.handles) || ~isfield(x.handles, 'ctrl_highk')
    % disp('in initial setup'); % for debug

    nexttile;
    ctrl_highk.plots.ctrl_V = plot(t80(timerange), V80(timerange), 'k');
    title('Control shifted');

    nexttile;
    ctrl_highk.plots.highk_V = plot(t56(timerange), V56(timerange), 'k');
    title('High [K^+] shifted');

    nexttile;
    hk_plots.hk_currentscape(hx.x, 'I', results_ctrl.PD, 'timeranges', [6 10]);

    nexttile;
    hk_plots.hk_currentscape(hx2.x, 'I', results_highK.PD, 'timeranges', [6 10]);

    x.handles.ctrl_highk = ctrl_highk;
    x.handles.hk2_currentscape = hx2.x.handles.hk_currentscape; % saving it in hx.x because next time hx2 is going to be a new variable
    x.handles.puppeteer_object.attachFigure(gcf);
  else
    % disp('in repeated manipulate'); % for debug

    ctrl_highk = x.handles.ctrl_highk;

    % Update plots
    ctrl_highk.plots.ctrl_V.YData = V80(timerange);
    ctrl_highk.plots.highk_V.YData = V56(timerange);

    % hx.x.handles % for debug

    % Update currentscapes
    hk_plots.hk_currentscape(hx.x, 'I', results_ctrl.PD, 'timeranges', [6 10]);
    hx2.x.handles.hk_currentscape = x.handles.hk2_currentscape; % restoring the previous hx2 currentscape variables
    hk_plots.hk_currentscape(hx2.x, 'I', results_highK.PD, 'timeranges', [6 10]);
  end
end
