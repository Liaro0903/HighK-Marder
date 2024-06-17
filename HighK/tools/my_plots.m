classdef my_plots
  methods(Static)
    % myplot1 and myplot2 are already added to the path of xolotl

    % temporary and should be re-invented with my_plot_3
    function my_plot(V, size, plot_index, C1_title)
      tvec = 0.00001:0.1/1000:length(V)/10000;
      tvec = tvec.';
      subplot(size(1), size(2), plot_index);
      plot(tvec, V, 'Color', 'k', 'LineWidth', 1.5);
      ylim([-80 55]);
      box off;
      xlabel('Time (s)');
      ylabel('Voltage (mV)');
      title(C1_title);
    end

    function my_plot2(V_1, V_2, V_3, size, plot_index, C1_title, C2_title, C3_title)
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

      subplot(size(1), size(2), plot_index(3));
      plot(tvec, V_3, 'Color', 'k', 'LineWidth', 1.5);
      ylim([-80 55]);
      box off;
      xlabel('Time (s)');
      ylabel('Voltage (mV)');
      title(C3_title);
    end

    % my_plot_3 is used for printing traces using subplots
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

    % my_plot_4 is used for printing traces using tight_subplots
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
        subplot(3, 4, i);
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
        if i == 11
          % subplot(3, 4, 12);
          % plot(0,0, 'k');
          legend(legend_titles, 'location', 'northwest');
        end
      end
      sgtitle(group_title);
      figlib.pretty('PlotLineWidth', 0.5, 'LineWidth', 0.5);
    end 

    % not complete, construction
    % neuron_state: 
    % cond_pair:
    % dm_var_space:
    % all_params: 
    function [hmap, hp_x, hp_y, cond_gates] = heatmap_ac_shifts(neuron_state, cond_pair, x, dm_var_space, all_params)
      % String truncate
      [neuron_name, conds, gates, cond_gates] = xsplit(cond_pair);
      % debug to see what these values are
      % conds
      % gates
      % cond_gates 
      
      % Get the ST_matrix
      ST_matrix = NaN(length(dm_var_space), length(dm_var_space));
      for j = 1:length(all_params)
        xx = find(all_params(1,j) == dm_var_space);
        y = find(all_params(2,j) == dm_var_space);
        ST_matrix(xx, y) = neuron_state(j);
      end
      ST_matrix(ST_matrix < 0) = 0;

      hp_y = findhalfV(x.(neuron_name).(conds(1)), strcat(gates(1), '_inf'), 0);
      hp_x = findhalfV(x.(neuron_name).(conds(2)), strcat(gates(2), '_inf'), 0);
      xdata = dm_var_space*-1 + hp_x;
      ydata = dm_var_space*-1 + hp_y;
    
      % Plot heatmap
      hmap = imagesc(xdata, ydata, ST_matrix, 'AlphaData', ~isnan(ST_matrix));
      % c_map = [42 45 108; 59 130 81; 157 106 53] ./ 255; % blue, green, brown
      % c_map = [61, 133, 198; 147, 196, 125; 234, 153, 153] / 255; % darker blue, lighter green, light red
      c_map = [183, 183, 183; 220, 124, 40; 74, 153, 249] / 255; % gray, orange, blue
      colormap(c_map);
      caxis([0 2]);

      % Label and plot axes
      [L, loc] = axlib.makeTickLabels(ydata, 25); 
      for l = 1:length(L)
        loc(l) = str2double(L{l});
      end
      L = fliplr(L);
      loc = fliplr(loc);
      set(gca,'YTick', loc, 'YTickLabels', L)
 
      [L, loc] = axlib.makeTickLabels(xdata, 25); 
      for l = 1:length(L)
        loc(l) = str2double(L{l});
      end
      L = fliplr(L);
      loc = fliplr(loc);
      set(gca,'XTick', loc, 'XTickLabels', L);

      hold on;
      plot([hp_x-50, hp_x+50], [hp_y, hp_y], '--w');
      plot([hp_x, hp_x], [hp_y-50, hp_y+50], '--w');
      dot_o = scatter(hp_x, hp_y, 120, 'k', 'filled');
      rowx = dataTipTextRow(cond_gates(2), 'XData');
      rowy = dataTipTextRow(cond_gates(1), 'YData');
      dot_o.DataTipTemplate.DataTipRows(2) = rowx;
      dot_o.DataTipTemplate.DataTipRows(1) = rowy;
      dot_o.DataTipTemplate.DataTipRows(3) = [];
      set(dot_o, 'ButtonDownFcn', @(src, event) datatipcallback(event, dot_o));

      ylabel(strcat("V_{1/2 ", cond_gates(1), '} (mV)'));
      xlabel(strcat("V_{1/2 ", cond_gates(2), '} (mV)'));
      title(strcat(cond_gates(1), "-", cond_gates(2)));
      axis xy
      % set(gca,'xdir','reverse')
      axis square
      % colorbar('northoutside'); 
    end

    % function
    % cond
    % Vrange: 
    % ac_shifts
    % plot_hp: boolean
    % might still need some final touches
    function Y = plot_ac(cond, Vrange, x_inf, ac_shifts, plot_hp)
      num_ac_shifts = length(ac_shifts);
      Y = ones(1000, num_ac_shifts);
      V = linspace(Vrange(1), Vrange(2), 1e3);
      % if (nargin < 6)
      %   Ca_average = 0;
      % end
      % Ca = Ca_average * ones(1, 1e3);
      Ca = realmax * ones(1, 1e3);
      hps = ones(1, num_ac_shifts);

      % Calculate halfV and Y
      for ac_shift = 1:length(ac_shifts)
        [hp, x_inf_f] = findhalfV(cond, x_inf, ac_shifts(ac_shift));
        hps(ac_shift) = hp;
        Y(:, ac_shift) = x_inf_f(V, Ca);
      end

      % Plot hp difference area
      if plot_hp
        a = area(hps, [1 1]);
        a(1).FaceColor = [0.9 0.9 0.9];
        a(1).EdgeColor = [0.9 0.9 0.9];
        hold on; 
      end

      % C = get(groot, 'DefaultAxesColorOrder');
      C = {'k', 'r'};
      
      for ac_shift = 1:length(ac_shifts)
        plot(V, Y(:, ac_shift), 'Color', C{ac_shift}, 'LineWidth', 2);
        set(gca,'YTick', [0, 0.2, 0.4, 0.6, 0.8, 1]);
        hold on;
        plot(hps(ac_shift), 0.5, 'o', 'MarkerSize', 8, 'MarkerFaceColor', [0.5 0.5 0.5], 'MarkerEdgeColor', [0.5 0.5 0.5], 'LineWidth', 1);
      end

      gate = char(x_inf);
      gate = gate(1);
      cond_name = cond.cpp_class_name;
      cond_name = strcat(strrep(cond_name, 'Current', ''), '.', gate);
      axis square;
      box off;
      xlabel('Voltage (mV)');
      ylabel([gate '_{∞}']);
      xlim(Vrange);
      ylim([0, 1]);
      title(cond_name);
      legend({'', 'Control', '', 'Late High [K^+]'}, 'Location', 'northeast');
    end
  end
end