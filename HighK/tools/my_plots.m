classdef my_plots
  methods(Static)
    function my_plot_3(V_AB, V_PD, plot_index, AB_title, PD_title)
      tvec = 0.00001:0.1/1000:3;
      tvec = tvec.';
      subplot(4, 3, plot_index);
      plot(tvec, V_AB, 'Color', 'k', 'LineWidth', 1.5);
      ylim([-80 55]);
      box off;
      set(gca, 'XTick', []);
      ylabel('Voltage (mV)');
      title(['AB, ', AB_title]);
      subplot(4, 3, plot_index + 3);
      plot(tvec, V_PD, 'Color', 'k', 'LineWidth', 1.5);
      ylim([-80 55]);
      box off;
      xlabel('Time (s)');
      ylabel('Voltage (mV)');
      title(['PD, ', PD_title]);
    end

    %% Under construction, may or may not need this
    function my_histogram_plots(params, subplot_titles, xlabel_title, legend_titles, group_title)
      figure('outerposition', [0 0 1800 900]);
      hold on;
      for i = 1:length(params{1})
        subplot(2, 4, i);
        % do the histogram plots here

        title(subplot_titles{i});
        xlabel(xlabel_title);
        ylabel('probability of occurence');
        box off;
        axis tight;
        set(gca, 'YTick', []);
        if i == 1
          legend(legend_titles, 'location', 'southeast');
        end
      end
      sgtitle(group_title);
      figlib.pretty('PlotLineWidth', 0.5, 'LineWidth', 0.5);
    end 
  end
end