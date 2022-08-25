classdef my_plots
  methods(Static)
    % myplot1 and myplot2 are already added to the path of xolotl
    function my_plot_3(V_1, V_2, size, plot_index, C1_title, C2_title)
      tvec = 0.00001:0.1/1000:length(V_1)/10000;
      tvec = tvec.';
      subplot(size(1), size(2), plot_index(1));
      plot(tvec, V_1, 'Color', 'k', 'LineWidth', 1.5);
      ylim([-80 55]);
      box off;
      set(gca, 'XTick', []);
      ylabel('Voltage (mV)');
      title(C1_title);
      subplot(size(1), size(2), plot_index(2));
      plot(tvec, V_2, 'Color', 'k', 'LineWidth', 1.5);
      ylim([-80 55]);
      box off;
      xlabel('Time (s)');
      ylabel('Voltage (mV)');
      title(C2_title);
    end

    function my_plot_4(V_AB, V_PD, ha, AB_title, PD_title)
      tvec = 0.00001:0.1/1000:length(V_AB)/10000;
      tvec = tvec.';
      axes(ha(1));
      plot(tvec, V_AB, 'Color', 'k', 'LineWidth', 1.5);
      ylim([-80 55]);
      box off;
      set(gca, 'XTick', []);
      ylabel('Voltage (mV)');
      title(['AB, ', AB_title]);
      axes(ha(2));
      plot(tvec, V_PD, 'Color', 'k', 'LineWidth', 1.5);
      ylim([-80 55]);
      box off;
      xlabel('Time (s)');
      ylabel('Voltage (mV)');
      title(['PD, ', PD_title]);
    end

    % These are used for plotting the distribution overlaps in *analysis.m
    % So far I set it to plotting of maximum 3 different distributions/overlaps
    function my_histogram_plots(params, subplot_titles, xlabel_title, legend_titles, group_title)
      figure('outerposition',[0 0 1800 900],'PaperUnits','points','PaperSize',[1200 1200]);
      hold on;
      [w, ~] = size(params{1}); % the width is the number of ion channels
      color = {'red', 'blue', 'green'}; % feel free to change the colors here
      % color2 = {'#60BAFF', '#9860FF'} % other colors I used (this one was used on the scifest poster)
      alpha = [0.6 0.6 0.6];
      % alpha2 = [0.7 0.5]; % this one was used on the scifest poster
      for i = 1:w  % go through the number of ion channels
        subplot(2, 4, i);
        % do the histogram plots here
        for j = 1:length(params)
          histogram(params{j}(i,:), 30, 'facecolor', color{j}, 'facealpha', alpha(j), 'edgecolor', 'none', 'linewidth', 1, 'normalization', 'probability');
          hold on;
        end
        title(subplot_titles{i});
        xlabel(xlabel_title);
        ylabel('probability of occurence');
        box off;
        axis tight;
        set(gca, 'YTick', []);
        if i == 1
          legend(legend_titles, 'location', 'northeast');
        end
      end
      sgtitle(group_title);
      figlib.pretty('PlotLineWidth', 0.5, 'LineWidth', 0.5);
    end 
  end
end