clear; close all;

%% Simulation

dhp_m_mags = [3, 8, 3]; % model B, C, D
dhp_m_slopes = [-2, -2, -10]; % model B, C, D
dhp_m_offsets = [-43.5, -45, -50]; % model B, C, D

% model b
i = 1;
hxs{i} = HKX(500*1000, -50, 10);
hxs{i}.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', 2);
hxs{i}.x.PD.add('huang/EkSwitcher'); % changes the EK
hxs{i}.x.PD.add('huang/AlphaSensor');
hxs{i}.x.PD.KCa.add('huang/ACSensor', 'dhp_m_mag', dhp_m_mags(i), 'dhp_m_slope', dhp_m_slopes(i), 'dhp_m_offset', dhp_m_offsets(i));
E_L = hxs{i}.setKPot(-80);

results{i} = hxs{i}.x.integrate;
results{i}.PD = trim_result(results{i}.PD, length(hxs{i}.x.time), 100); % trim first 100 sec

% model c
i = 2;
gbars_c = [
  262.760569776468,
  5.0277794686865
  149.940420042883
  0.0231041825727117
  59.9104792932878
  4448.58989955374
  0.0821360402746351
  6631.50758385968
];
hxs{i} = HKX(500*1000, -50, 10);
hxs{i}.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', gbars_c);
hxs{i}.x.PD.add('huang/EkSwitcher'); % changes the EK
hxs{i}.x.PD.add('huang/AlphaSensor');
hxs{i}.x.PD.KCa.add('huang/ACSensor', 'dhp_m_mag', dhp_m_mags(i), 'dhp_m_slope', dhp_m_slopes(i), 'dhp_m_offset', dhp_m_offsets(i));
E_L = hxs{i}.setKPot(-80);

results{i} = hxs{i}.x.integrate;
results{i}.PD = trim_result(results{i}.PD, length(hxs{i}.x.time), 100); % trim first 100 sec

% model d
i = 3;
gbars_d = [
  1267.82293406765
  210.681534821618
  92.0004127720222
  0.173173268725742
  355.500672257348
  3186.61170246948
  0.014315825505795
  12253.0318310558
];

hxs{i} = HKX(500*1000, -50, 10);
hxs{i}.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', gbars_d);
hxs{i}.x.PD.add('huang/EkSwitcher'); % changes the EK
hxs{i}.x.PD.add('huang/AlphaSensor');
hxs{i}.x.PD.KCa.add('huang/ACSensor', 'dhp_m_mag', dhp_m_mags(i), 'dhp_m_slope', dhp_m_slopes(i), 'dhp_m_offset', dhp_m_offsets(i));
E_L = hxs{i}.setKPot(-80);

results{i} = hxs{i}.x.integrate;
results{i}.PD = trim_result(results{i}.PD, length(hxs{i}.x.time), 100); % trim first 100 sec

%% Plotting
% figure('outerposition',[0 0 1300 1500],'PaperUnits','points','PaperSize',[1200 1200], 'renderer', 'Painters');
figure('outerposition',[0 0 1300 1500],'PaperUnits','points','PaperSize',[1200 1200]);
% figure('outerposition',[0 0 1920 1920],'PaperUnits','points');
tl = tiledlayout(9, 4, 'TileSpacing', 'tight', 'Padding', 'compact');

threesec_timeranges = {[ ...
  49.84, 52.84; 105, 108; 330.11, 333.11; 350.16, 353.16;
], [
  49.73, 52.73; 105, 108; 330.3, 333.3; 350.07, 353.07;
], [
  50.15, 53.15; 105, 108; 330.03, 333.03; 350.45, 353.45;
]
};
currentscape_timeranges = {[ ...
  49.84, 52.00; 105.002, 105.102; 330.56, 331.54; 350.86, 352.55;
], [
  49.73, 52.00; 105.011, 105.111; 330.31, 331.57; 349.07, 351.64;
], [
  50.15, 52.00; 105.010, 105.110; 330.03, 331.14; 350.45, 352.08;
]
};
currentscape_timebars = {[
  49.84, 50.84; 105.002, 105.052; 330.56, 330.81; 350.86, 351.36;
], [
  49.73, 50.73; 105.011, 105.061; 330.31, 330.56; 349.07, 349.57;
], [
  50.15, 51.15; 105.010, 105.060; 329.9, 330.4; 350.45, 350.95;
]
};

background_color = [42 45 108; 59 130 81; 157 106 53] ./ 255;
tvec = hxs{1}.x.time;
tvec = tvec(1:400*1e4); % Cut off the first 100 sec
minus50line = [-50 -50];

for m = 1:3 % going across models
  % 1: Plot 3 sec plots
  for tp = 1:length(threesec_timeranges{m})
    nexttile;
    trange = uint32(threesec_timeranges{m}(tp,1)*1e4:threesec_timeranges{m}(tp,2)*1e4);
    plot(tvec(trange), results{m}.PD.V(trange), 'k');
    hold on;
    plot(threesec_timeranges{m}(tp, :), minus50line, '--r', 'LineWidth', 2); % minus 50 line
    % box off;
    axis off;
    if (m == 1 && tp == 1) % 1 second indication
      plot([51 52], [-80 -80], 'k');
      plot([51 51], [-60 -80], 'k');
    end
    xlim(threesec_timeranges{m}(tp, :));
    ylim([-80, 60]);
  end

  % 2: Plot currentscapes
  for tr = 1:length(currentscape_timeranges{m})
    % 0: Plot setup
    nexttile([2 1]);
    trange = uint32(currentscape_timeranges{m}(tr,1)*1e4+1:currentscape_timeranges{m}(tr,2)*1e4);

    % 1: Plot currentscape
    [~, sum_currents] = hk_plots.hk_currentscape(hxs{m}.x, 'I', results{m}.PD, 'timeranges', currentscape_timeranges{m}(tr, :), 'plot_sum', true, 'plot_mode', 'multi');

    hold on;

    % 2: Plot voltage traces
    plot(tvec(trange), results{m}.PD.V(trange) / 100 + 3, 'k');
    hold on;

    % 3: Plot lines
    for p = -1:2:1
      for l = p*1.25:p*0.25:p*2
        plot(currentscape_timeranges{m}(tr, :), [l l], 'k:', 'LineWidth', 0.25);
      end
    end
    minus50point = -50 / 100 + 3;
    minus0point = 3;
    plot(currentscape_timeranges{m}(tr, :), [minus50point minus50point], '--r', 'LineWidth', 1);
    plot(currentscape_timebars{m}(tr, :), [3.7 3.7], 'k');
    if (tr == 1)
      plot([currentscape_timeranges{m}(tr, 1) currentscape_timeranges{m}(tr, 1)], [minus50point minus0point], 'k', 'LineWidth', 1);
    end

    % 4: Plot configurations
    xlim(currentscape_timeranges{m}(tr,:));
    ylim([-2, 3.7]);
    set(gca, 'YTick', []);
    axis off;
  end
end

figlib.pretty('PlotLineWidth', 1, 'LineWidth', 0.5);