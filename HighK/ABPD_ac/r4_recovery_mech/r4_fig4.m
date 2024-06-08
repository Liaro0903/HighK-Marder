clear; close all;

% load data
load('r4_results1.mat');
threesec_timeranges = {[ ...
  50.00, 53.00; 098, 101; 330.00, 333.00; 350.00, 353.00; % obsolete
], [
  48.99, 51.99; 106, 109; 330.21, 333.21; 352.67, 355.67;
], [
  48.68, 51.68; 106, 109; 330.10, 333.10; 352.69, 355.69;
]
};

currentscape_timeranges = {[ ...
  50.00, 52.20; 098, 098.15; 330.20, 331.90; 350.40, 353.90; % obsolete
], [
  48.99, 51.05; 106, 106.15; 330.21, 331.22; 352.67, 354.63;
], [
  48.68, 50.78; 106.004, 106.154; 330.10, 331.09; 352.69, 354.43;
]
};

currentscape_timebars = {[
  50.1, 51.1; 98.01, 98.05; 330.3, 330.8; 350.5, 351.5; % obsolete
], [
  48.99, 49.99; 106, 106.05; 330.21, 330.46; 352.67, 353.17;
], [
  48.67, 49.67; 106.004, 106.054; 330.10, 330.35; 352.69, 353.19;
]
};

background_color = [42 45 108; 59 130 81; 157 106 53] ./ 255;

% Cut off the first 100 sec
tvec = hxs{1}.x.time;
tvec = tvec(1:400*1e4);
minus50line = [-50 -50];
for m = 1:length(target_conds)
  results{m}.PD.V = results{m}.PD.V(100*1e4+1:end);
end

%% Figure 4: Other channel zoomed in and currentscapes
% figure('outerposition',[0 0 1300 1500],'PaperUnits','points','PaperSize',[1200 1200], 'renderer', 'Painters');
figure('outerposition',[0 0 1300 1500],'PaperUnits','points');

tl = tiledlayout(6, 4, 'TileSpacing', 'tight', 'Padding', 'compact');

for m = 2:3 % plot only Kd and Na
  % 1: Plot 3 sec plots
  for tp = 1:length(threesec_timeranges{m})
    nexttile;
    trange = uint32(threesec_timeranges{m}(tp,1)*1e4:threesec_timeranges{m}(tp,2)*1e4);
    plot(tvec(trange), results{m}.PD.V(trange), 'k');
    hold on;
    plot(threesec_timeranges{m}(tp, :), minus50line, '--r', 'LineWidth', 2); % minus 50 line
    % box off;
    axis off;
    % if (m == 1)
    %   title(timerange_title{tp});
    % end
    if (m == 2 && tp == 1) % 1 second indication
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
    % if (tr == 5)
    %   show_legend = true;
    % end
    trange = uint32(currentscape_timeranges{m}(tr,1)*1e4:currentscape_timeranges{m}(tr,2)*1e4);

    % 1: Plot currentscape
    % [~, sum_currents] = hxs{m}.x.mycurrentscape(results{m}.AB, sp, timeranges{m}(tr, :), show_legend);
    [~, sum_currents] = hxs{m}.x.mycurrentscape(results{m}.PD, tl, trange, show_legend, true);
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
    plot(currentscape_timeranges{m}(tr, :), [minus50point minus50point], '--r', 'LineWidth', 1);
    plot(currentscape_timebars{m}(tr, :), [3.7 3.7], 'k');

    % 4: Plot configurations
    xlim(currentscape_timeranges{m}(tr,:));
    ylim([-2, 3.7]);
    % if (tr ~= 1)
      set(gca, 'YTick', []);
    % end
    axis off;
  end
end

% sgtitle(['Recovery Mechanism Currentscape at Different Time Points of Prinz Model ' num2str(model), ', shifting ' target_cond_var]);

figlib.pretty('PlotLineWidth', 1, 'LineWidth', 0.5);