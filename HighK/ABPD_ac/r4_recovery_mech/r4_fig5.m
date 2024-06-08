clear; close all;

% load data
load('r4_results2.mat'); % loads results
resultsm{1} = results{1}; % because model 2 has 3 conds, and we just KCa
load('r4_result7.mat'); % loads result
resultsm{2} = result;
load('r4_result8.mat'); % loads result
resultsm{3} = result;

% load('r4_results3.mat');
% resultsm{3} = results;
% load('r4_results4.mat');
% resultsm{4} = results;
% load('r4_result8.mat');
% results{1} = result; % temporary solution
% resultsm{4} = results;

% return

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

% Cut off the first 100 sec
tvec = hxs{1}.x.time;
tvec = tvec(1:400*1e4);
minus50line = [-50 -50];
for m = 1:3
  resultsm{m}.PD.V = resultsm{m}.PD.V(100*1e4+1:end);
end

%% Figure 4: Other channel zoomed in and currentscapes
% figure('outerposition',[0 0 1300 1500],'PaperUnits','points','PaperSize',[1200 1200], 'renderer', 'Painters');
figure('outerposition',[0 0 1300 1500],'PaperUnits','points','PaperSize',[1200 1200]);
% figure('outerposition',[0 0 1920 1920],'PaperUnits','points');

tl = tiledlayout(9, 4, 'TileSpacing', 'tight', 'Padding', 'compact');

for m = 1:3 % going across models
  % 1: Plot 3 sec plots
  for tp = 1:length(threesec_timeranges{m})
    nexttile;
    trange = uint32(threesec_timeranges{m}(tp,1)*1e4:threesec_timeranges{m}(tp,2)*1e4);
    plot(tvec(trange), resultsm{m}.PD.V(trange), 'k');
    hold on;
    plot(threesec_timeranges{m}(tp, :), minus50line, '--r', 'LineWidth', 2); % minus 50 line
    % box off;
    axis off;
    % if (m == 1)
    %   title(timerange_title{tp});
    % end
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
    show_legend = false;
    % if (tr == 5)
    %   show_legend = true;
    % end
    trange = uint32(currentscape_timeranges{m}(tr,1)*1e4+1:currentscape_timeranges{m}(tr,2)*1e4);

    % 1: Plot currentscape
    plot_sum = true;
    [~, sum_currents] = hxs{m}.x.mycurrentscape(resultsm{m}.PD, tl, trange, show_legend, plot_sum);
    hold on;

    % 2: Plot voltage traces
    plot(tvec(trange), resultsm{m}.PD.V(trange) / 100 + 3, 'k');
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
    % if (tr ~= 1)
      set(gca, 'YTick', []);
    % end
    axis off;
  end
end

% sgtitle(['Recovery Mechanism Currentscape at Different Time Points of Prinz Model ' num2str(model), ', shifting ' target_cond_var]);

figlib.pretty('PlotLineWidth', 1, 'LineWidth', 0.5);