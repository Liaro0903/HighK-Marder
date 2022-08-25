% This plots the distributions for each channel for each neuron for distribution comparison

% Warning: there is still a lot of bugs needed to be fixed, but this is at least workable for some distributions

classdef ABcPD_analysis

properties
  conds_AB = {'ACurrent', 'CaS', 'CaT', 'HCurrent', 'KCa', 'Kd', 'Leak'};
  conds_PD = {'ACurrent', 'CaS', 'CaT', 'HCurrent', 'KCa', 'Kd', 'Leak', 'NaV'};
  params_AB = cell(1, 1);
  params_PD = cell(1, 1);
end

methods
  % exps: Enter an array of experiments that want to be plotted on top of each other
  % example use: a = ABcPD_analysis(["rand_3", "rand_high_7"]);
  function a = ABcPD_analysis(exps)
    % close all;
    a.params_AB = cell(length(exps), 1);
    a.params_PD = cell(length(exps), 1);
    for i = 1:length(exps)
      filename = strcat('FindABcPD_', exps(i), '.mat');
      load(filename);
      setup_name = strcat('setup_', erase(exps(i), 'rand_'));
      [a.params_AB{i}, a.params_PD{i}] = ABcPD_analysis.(setup_name)(params);
    end
    my_plots.my_histogram_plots(a.params_AB, a.conds_AB, 'max conductances (μS)', {'Distribution 1', 'Distribution 2'}, 'Histogram of gbar AB Distribution 1 vs Distribution 2');
    my_plots.my_histogram_plots(a.params_PD, a.conds_PD, 'max conductances (μS)', {'Distribution 1', 'Distribution 2'}, 'Histogram of gbar PD Distribution 1 vs Distribution 2');
    if (sum(exps.contains('ac')) > 0) % if one of them is plotting ac
      ABcPD_analysis.plot_ac_1();
    end
  end
end

methods(Static)
  function [params_AB, params_PD] = setup_3(params)
    params_AB = params(1:7, :);
    params_PD = params(8:15, :);
  end
  function [params_AB, params_PD] = setup_4(params)
    params_AB = params(1:8, :);
    params_PD = params(9:16, :);
  end
  function [params_AB, params_PD] = setup_high_7(params)
    params_AB = params(1:7, :);
    params_PD = params(8:15, :);
  end
  function [params_AB, params_PD] = setup_ac_1(params)
    params_AB = params(1:7, :);
    params_PD = params(8:15, :);
  end
  % Because ac also have shifting half-potentials as well, so this function helps plot those shifts. Also it is not optimized yet, because I need to rewrite some of the my_histogram_plots code but I didn't have time to :( 
  function plot_ac_1()
    load('FindABcPD_rand_ac_1.mat');
    conds = {'ACurrent', 'CaS', 'CaT', 'HCurrent', 'KCa', 'Kd', 'Leak', 'NaV'};
    % Graph AB shifting half potential
    figure('outerposition', [0 0 1800 900]);
    hold on;
    for i = 1:6
      subplot(2, 4, i);
      histogram(params(i+15,:), 30, 'facecolor', 'red', 'facealpha', 0.3, 'edgecolor', 'none', 'linewidth', 1, 'normalization', 'probability'); % plot the m
      hold on;
      if (i <= 3)
        histogram(params(i+28,:), 30, 'facecolor', 'blue', 'facealpha', 0.3, 'edgecolor', 'none', 'linewidth', 1, 'normalization', 'probability'); % plot the h
      end
      title(['AB.', conds{i}]);
      xlabel('Shifts in half potential');
      ylabel('probability of occurence');
      box off;
      axis tight;
      set(gca, 'YTick', []);
      xlim([-4.9 4.9]);
      if i == 1
        legend('m', 'h', 'location', 'southeast');
      end
    end
    sgtitle('Histogram of half potential shifts in AB Distribution 3');
    figlib.pretty('PlotLineWidth', 0.5,'LineWidth', 0.5);

    % Graph PD shifting half potential
    figure('outerposition', [0 0 1800 900]);
    hold on;
    for i = 1:7
      subplot(2, 4, i);
      histogram(params(i+21,:), 30, 'facecolor', 'r', 'facealpha', 0.3, 'edgecolor', 'none', 'linewidth', 1, 'normalization', 'probability'); % plot the m
      hold on;
      if (i <= 3)
        histogram(params(i+31,:), 30, 'facecolor', 'b', 'facealpha', 0.3, 'edgecolor', 'none', 'linewidth', 1, 'normalization', 'probability'); % plot the h
      end
      if (i == 7) % for the last NaV
        histogram(params(35,:), 30, 'facecolor', 'b', 'facealpha', 0.3, 'edgecolor', 'none', 'linewidth', 1, 'normalization', 'probability'); % plot the h
      end
      title(['PD.', conds{i}]);
      xlabel('Shifts in half potential');
      ylabel('probability of occurence');
      box off;
      axis tight;
      set(gca, 'YTick', []);
      xlim([-4.9 4.9]);
      if i == 1
        legend('m', 'h', 'location', 'southeast');
      end
    end
    sgtitle('Histogram of half potential shifts in PD Distribution 3');
    figlib.pretty('PlotLineWidth', 0.5,'LineWidth', 0.5);
  end
end

end