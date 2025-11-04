clear; close all;

%% Simulation
model = 1;
conds = ["Kd", "NaV"];

dhp_m_mags.Kd = -7;
dhp_m_slopes.Kd = -2;
dhp_m_offsets.Kd = -45;

dhp_m_mags.NaV = -2;
dhp_m_slopes.NaV = -2;
dhp_m_offsets.NaV = -45;

for i = 1:length(conds)
  cond = conds(i);
  dhp_m_mag = dhp_m_mags.(cond);
  dhp_m_slope = dhp_m_slopes.(cond);
  dhp_m_offset = dhp_m_offsets.(cond);

  hx = HKX(500*1000, -50, 10);
  hx.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', model);
  hx.x.PD.add('huang/EkSwitcher'); % changes the EK
  hx.x.PD.add('huang/AlphaSensor');
  hx.x.PD.(cond).add('huang/ACSensor', 'dhp_m_mag', dhp_m_mag, 'dhp_m_slope', dhp_m_slope, 'dhp_m_offset', dhp_m_offset);
  E_L = hx.setKPot(-80);

  results.(cond) = hx.x.integrate;
  results.(cond).PD = trim_result(results.(cond).PD, length(hx.x.time), 100); % trim first 100 sec

  hxs.(cond) = hx; % store for currentscape later
end

%% Plotting
% figure('outerposition',[0 0 1300 1500],'PaperUnits','points','PaperSize',[1200 1200], 'renderer', 'Painters');
figure('outerposition',[0 0 1300 1500], 'PaperUnits', 'points');
tl = tiledlayout(6, 4, 'TileSpacing', 'tight', 'Padding', 'compact');

threesec_timeranges = {[
  48.99, 51.99; 106, 109; 330.21, 333.21; 352.67, 355.67; % Kd
], [
  48.68, 51.68; 106, 109; 330.10, 333.10; 352.69, 355.69; % NaV
]
};
currentscape_timeranges = {[
  48.99, 51.05; 106, 106.15; 330.21, 331.22; 352.67, 354.63; % Kd
], [
  48.68, 50.78; 106.004, 106.154; 330.10, 331.09; 352.69, 354.43; % NaV
]
};
currentscape_timebars = {[
  48.99, 49.99; 106, 106.05; 330.21, 330.46; 352.67, 353.17; % Kd
], [
  48.67, 49.67; 106.004, 106.054; 330.10, 330.35; 352.69, 353.19; % NaV
]
};

background_color = [42 45 108; 59 130 81; 157 106 53] ./ 255;
tvec = hxs.Kd.x.time;
tvec = tvec(1:400*1e4); % Cut off the first 100 sec
minus50line = [-50 -50];

for m = 1:length(conds) % plot Kd and Na
  cond = conds(m);

  % 1: Plot 3 sec plots
  for tp = 1:length(threesec_timeranges{m})
    nexttile;
    trange = uint32(threesec_timeranges{m}(tp,1)*1e4:threesec_timeranges{m}(tp,2)*1e4);
    plot(tvec(trange), results.(cond).PD.V(trange), 'k');
    hold on;
    plot(threesec_timeranges{m}(tp, :), minus50line, '--r', 'LineWidth', 2); % minus 50 line
    % box off;
    axis off;
    if (m == 1 && tp == 1) % 1 second indication
      plot([49 50], [-80 -80], 'k');
      plot([49 49], [-60 -80], 'k');
    end
    ylim([-80, 60]);
  end

  % 2: Plot currentscapes
  for tr = 1:length(currentscape_timeranges{m})
    % 0: Plot setup
    nexttile([2 1]);
    show_legend = false;
    trange = uint32(currentscape_timeranges{m}(tr,1)*1e4:currentscape_timeranges{m}(tr,2)*1e4);

    % 1: Plot currentscape
    [~, sum_currents] = hk_plots.hk_currentscape(hxs.(cond).x, 'I', results.(cond).PD, 'timeranges', currentscape_timeranges{m}(tr, :), 'plot_sum', true, 'plot_mode', 'multi');
    hold on;

    % 2: Plot voltage traces
    plot(tvec(trange), results.(cond).PD.V(trange) / 100 + 3, 'k');
    hold on;

    % 3: Plot lines
    for p = -1:2:1
      for l = p*1.25:p*0.25:p*2
        plot(currentscape_timeranges{m}(tr, :), [l l], 'k:', 'LineWidth', 0.25);
      end
    end
    minus50point = -50 / 100 + 3;
    plot(currentscape_timeranges{m}(tr, :), [minus50point minus50point], '--r', 'LineWidth', 1);
    plot(currentscape_timebars{m}(tr, :), [3.7 3.7], 'k');

    % 4: Plot configurations
    xlim(currentscape_timeranges{m}(tr,:));
    ylim([-2, 3.7]);
    set(gca, 'YTick', []);
    axis off;
  end
end

figlib.pretty('PlotLineWidth', 1, 'LineWidth', 0.5);