function ABPD_ac_debug_highK(x)


  % let's figure out if we need to make the plot or not
  if isempty(x.handles) || ~isfield(x.handles,'debug_highK')

    % in figure

    % make the figure
    debug_highK.main_fig = figure('outerposition',[0 0 1800 900],'PaperUnits','points','PaperSize',[1200 1200]); hold on
    tl = tiledlayout(3, 2);
  
    % make the nexttiles
    % example_plot.v_trace = subplot(2,3,1:2); hold on
    % example_plot.gbars = subplot(2,3,4); hold on
    % example_plot.burst_metrics = subplot(2,3,5); hold on
    % example_plot.Ca_embedding = subplot(2,3,6); hold on
  
    debug_highK.axes.control_V = nexttile([2 1]);
    debug_highK.axes.earlyK_V = nexttile([2 1]);
    debug_highK.axes.control_text = nexttile();
    debug_highK.axes.earlyK_text = nexttile();
    % debug_highK.axes.control_currentscape = nexttile([2 1]);
    % debug_highK.axes.earlyK_currentscape = nexttile([2 1]);
    % debug_highK.axes.lateK_V = nexttile; hold on
    % debug_highK.axes.wash_V = nexttile; hold on
    % debug_highK.axes.lateK_currentscape = nexttile([2 1]); hold on
    % debug_highK.axes.wash_currentscape = nexttile([2 1]); hold on 

    set(debug_highK.axes.control_V, 'YLim', [-80 55]);
    set(debug_highK.axes.earlyK_V, 'YLim', [-80 55]);
    % set(debug_highK.axes.lateK_V, 'YLim', [-85 55]);
    % set(debug_highK.axes.wash_V, 'YLim', [-85 55]);
    
    % make the plots 
    % example_plot.plots.Ca_embedding = plot(example_plot.Ca_embedding,NaN,NaN,'k');
    % example_plot.plots.burst_metrics_all = plot(example_plot.burst_metrics,NaN,NaN,'.','Color',[.5 .5 .5]);
    % example_plot.plots.burst_metrics_this = plot(example_plot.burst_metrics,NaN,NaN,'r+','MarkerSize',29);

    debug_highK.plots.control_V = plot(debug_highK.axes.control_V, NaN, NaN, 'k');
    debug_highK.plots.earlyK_V = plot(debug_highK.axes.earlyK_V, NaN, NaN, 'k');

    debug_highK.plots.ctrl.spikes_per_bursts = text(debug_highK.axes.control_text, 0.1, 0.9, '', 'FontSize', 14);
    debug_highK.plots.ctrl.ibi_mean = text(debug_highK.axes.control_text, 0.1, 0.7, '', 'FontSize', 14);
    debug_highK.plots.ctrl.ibi_std = text(debug_highK.axes.control_text, 0.1, 0.5, '', 'FontSize', 14);
    debug_highK.plots.ctrl.isi_mean = text(debug_highK.axes.control_text, 0.1, 0.3, '', 'FontSize', 14);
    debug_highK.plots.ctrl.isi_std = text(debug_highK.axes.control_text, 0.1, 0.1, '', 'FontSize', 14);
    debug_highK.plots.ctrl.state = text(debug_highK.axes.control_text, 0.3, 0.1, '', 'FontSize', 14);

    debug_highK.plots.highK.spikes_per_bursts = text(debug_highK.axes.earlyK_text, 0.1, 0.9, '', 'FontSize', 14);
    debug_highK.plots.highK.ibi_mean = text(debug_highK.axes.earlyK_text, 0.1, 0.7, '', 'FontSize', 14);
    debug_highK.plots.highK.ibi_std = text(debug_highK.axes.earlyK_text, 0.1, 0.5, '', 'FontSize', 14);
    debug_highK.plots.highK.isi_mean = text(debug_highK.axes.earlyK_text, 0.1, 0.3, '', 'FontSize', 14);
    debug_highK.plots.highK.isi_std = text(debug_highK.axes.earlyK_text, 0.1, 0.1, '', 'FontSize', 14);
    debug_highK.plots.highK.state = text(debug_highK.axes.earlyK_text, 0.3, 0.1, '', 'FontSize', 14);

    % debug_highK.plots.control_currentscape = plot(debug_highK.axes.control_currentscape, NaN, NaN, 'k');
    % fakeY = zeros(length(x.time), 8);
    % for p = 3:4
      % debug_highK.plots.control_currentscape(p) = area(debug_highK.axes.control_currentscape, x.time, fakeY); hold on;
      % debug_highK.plots.earlyK_currentscape(p) = area(x.time, fakeY); hold on;
    % end
    % debug_highK.plots.earlyK_currentscape = plot(debug_highK.axes.earlyK_currentscape, NaN, NaN, 'k');
    % debug_highK.plots.lateK_V = plot(debug_highK.axes.lateK_V, NaN, NaN, 'k');
    % debug_highK.plots.wash_V = plot(debug_highK.axes.wash_V, NaN, NaN, 'k');
    % debug_highK.plots.lateK_currentscape = plot(debug_highK.axes.lateK_currentscape, NaN, NaN, 'k');
    % debug_highK.plots.wash_currentscape = plot(debug_highK.axes.wash_currentscape, NaN, NaN, 'k');
  
    % attach to puppeteer so that it can be closed automatically
    x.handles.puppeteer_object.attachFigure(debug_highK.main_fig)
   
    % labels
    % xlabel(example_plot.burst_metrics,'Duty Cycle')
    % ylabel(example_plot.burst_metrics,'Burst period (ms)')
    % example_plot.burst_metrics.XLim = [0 .4];
    % example_plot.burst_metrics.YLim = [0 1e3];
  
    % xlabel(example_plot.v_trace,'Time (s)')
    % ylabel(example_plot.v_trace,'V_m (mV)')
    % xlabel(example_plot.Ca_embedding,'[Ca^2^+] (uM)')
    % ylabel(example_plot.Ca_embedding,'d [Ca^2^+] /dt (uM/ms)')
    
  
    x.handles.debug_highK = debug_highK; 
  
  end
  
  debug_highK = x.handles.debug_highK;
  
  % make the plots
  x.output_type = 2;
  hx = HKX(x, -50, 24);
  hx2 = hx.copyHKX();

  hx.setKPot(-80);
  hx2.setKPot(-56);

  results_control = hx.x.integrate;
  results_highK = hx2.x.integrate;

  V_80 = results_control.PD.V;
  V_56 = results_highK.PD.V;

  % Metrics
  [metrics_80, ctrl_category] = classifier_2312(V_80);
  [metrics_56, highK_category] = classifier_2312(V_56);

  % Updates

  time = hx.x.time;

  debug_highK.plots.control_V.XData = time;
  debug_highK.plots.control_V.YData = results_control.PD.V;
  debug_highK.plots.earlyK_V.XData = time;
  debug_highK.plots.earlyK_V.YData = results_highK.PD.V;

  debug_highK.plots.ctrl.spikes_per_bursts.String = ['spikes per bursts: ', num2str(metrics_80.n_spikes_per_burst_mean)];
  debug_highK.plots.ctrl.ibi_mean.String = ['ibi mean: ', num2str(metrics_80.ibi_mean)];
  debug_highK.plots.ctrl.ibi_std.String = ['ibi std: ', num2str(metrics_80.ibi_std)];
  debug_highK.plots.ctrl.isi_mean.String = ['isi mean: ', num2str(metrics_80.isi_mean)];
  debug_highK.plots.ctrl.isi_std.String = ['isi std: ', num2str(metrics_80.isi_std)];
  debug_highK.plots.ctrl.state.String = ['state: ', ctrl_category{2}];

  debug_highK.plots.highK.spikes_per_bursts.String = ['spikes per bursts: ', num2str(metrics_56.n_spikes_per_burst_mean)];
  debug_highK.plots.highK.ibi_mean.String = ['ibi mean: ', num2str(metrics_56.ibi_mean)];
  debug_highK.plots.highK.ibi_std.String = ['ibi std: ', num2str(metrics_56.ibi_std)];
  debug_highK.plots.highK.isi_mean.String = ['isi mean: ', num2str(metrics_56.isi_mean)];
  debug_highK.plots.highK.isi_std.String = ['isi std: ', num2str(metrics_56.isi_std)];
  debug_highK.plots.highK.state.String = ['state: ', highK_category{2}];



  % hx.x.mycurrentscape(results_control.PD, debug_highK.plots.control_currentscape);
  % hx2.x.mycurrentscape(results_highK.PD, debug_highK.plots.earlyK_currentscape);
  
  % x.plotgbars(example_plot.gbars,'AB');
  
  % % get the burst metrics
  % metrics = xtools.V2metrics(V,'sampling_rate',1/x.dt);
   
  % example_plot.plots.burst_metrics_this.XData = metrics.duty_cycle_mean;
  % example_plot.plots.burst_metrics_this.YData = metrics.burst_period;
  
  % example_plot.plots.burst_metrics_all.XData = [example_plot.plots.burst_metrics_all.XData metrics.duty_cycle_mean];
  % example_plot.plots.burst_metrics_all.YData = [example_plot.plots.burst_metrics_all.YData metrics.burst_period];
  
  % Ca = Ca(:,1); Ca = Ca(:);
  % dCa = [NaN; diff(Ca)];
  % example_plot.plots.Ca_embedding.XData = Ca;
  % example_plot.plots.Ca_embedding.YData = dCa;