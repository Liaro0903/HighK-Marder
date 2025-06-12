classdef hk_plots
  methods(Static)

    % Description: function plotting heatmaps of the classification of neuronal response of different activation shifts
    % Params
    % neuron_state: classified neuron state space, data for the heatmap
    % cond_pair: string cell of (1, 2) with 1st cond on the y axis and 2nd cond on the x axis, used for to findHalfV param and plot names
    % x: xolotl object, same model as the model generating the heatmap, used for to find V1/2
    % dm_var_space: used for shaping the heatmap data and label ticks
    % all_params: used for shaping the heatmap data
    function [hmap, hp_x, hp_y, cond_gates] = heatmap_ac_shifts(neuron_state, cond_pair, x, dm_var_space, all_params)
      % String truncate
      [neuron_name, conds, gates, cond_gates, gate_conds] = xsplit(cond_pair);
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

      % Find half V and set x and y data
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
      [L, loc] = axlib.makeTickLabels(ydata, (length(dm_var_space) - 1) / 4); % set how many ticks, here we set 4 ticks based on resolution
      for l = 1:length(L)
        loc(l) = str2double(L{l});
      end
      L = fliplr(L);
      loc = fliplr(loc);
      set(gca,'YTick', loc, 'YTickLabels', L)
 
      [L, loc] = axlib.makeTickLabels(xdata, (length(dm_var_space) - 1) / 4); % set how many ticks, here we set 4 ticks based on resolution
      for l = 1:length(L)
        loc(l) = str2double(L{l});
      end
      L = fliplr(L);
      loc = fliplr(loc);
      set(gca,'XTick', loc, 'XTickLabels', L);

      hold on;
      plot([hp_x-50, hp_x+50], [hp_y, hp_y], '--w'); % plot horizontal dotted line on V1/2
      plot([hp_x, hp_x], [hp_y-50, hp_y+50], '--w'); % plot vertical dotted line on V1/2
      scatter(hp_x, hp_y, 120, 'k', 'filled'); % plot the center of the heatmap
      % interaction part will be added back in the future
      % dot_o = scatter(hp_x, hp_y, 120, 'k', 'filled'); % plot the center of the heatmap
      % rowx = dataTipTextRow(cond_gates(2), 'XData');
      % rowy = dataTipTextRow(cond_gates(1), 'YData');
      % dot_o.DataTipTemplate.DataTipRows(2) = rowx;
      % dot_o.DataTipTemplate.DataTipRows(1) = rowy;
      % dot_o.DataTipTemplate.DataTipRows(3) = [];
      % set(dot_o, 'ButtonDownFcn', @(src, event) datatipcallback(event, dot_o));

      ylabel(strcat("V_{1/2} ", gate_conds(1), ' (mV)'));
      xlabel(strcat("V_{1/2} ", gate_conds(2), ' (mV)'));
      title(strcat(gate_conds(1), "-", gate_conds(2)), 'FontWeight','Normal');
      axis xy
      % set(gca,'xdir','reverse')
      axis square
      % colorbar('northoutside'); 
    end

    % Description: function to plot the activation curve of a conductance
    % Params
    % cond: xolotl cond variable, used for findhalfV and plot titles 
    % Vrange: a (1,2) number array, use it like xlim
    % ac_shifts: array of "shifts", first one should be the original, put in ascending order.
    %            current maximum of shifts is 4 (see below color variable C)
    % plot_hp: boolean
    % legend_titles: string array of ac titles, should be same size as ac_shifts
    function Y = plot_ac(cond, Vrange, x_inf, ac_shifts, plot_hp, legend_titles)
      num_ac_shifts = length(ac_shifts);
      Y = ones(1000, num_ac_shifts);
      V = linspace(Vrange(1), Vrange(2), 1e3);
      Ca = realmax * ones(1, 1e3); % some ac require Ca param, here we bring the Ca function within the ac to 1
      hps = ones(1, num_ac_shifts);

      % Calculate halfV and Y
      for ac_shift = 1:length(ac_shifts)
        [hp, x_inf_f] = findhalfV(cond, x_inf, ac_shifts(ac_shift));
        hps(ac_shift) = hp;
        Y(:, ac_shift) = x_inf_f(V, Ca);
      end

      % Plot hp difference area
      if plot_hp
        c0 = 0.9;
        for h = length(hps):-1:2
          a = area([hps(1) hps(h)], [1 1]);
          c = c0 - (h - 2) * 0.1;
          % a(1).FaceColor = [0.9 0.9 0.9];
          % a(1).EdgeColor = [0.9 0.9 0.9];
          a(1).FaceColor = [c c c];
          a(1).EdgeColor = [c c c];
          hold on;
        end
        hold on; 
      end

      % C = get(groot, 'DefaultAxesColorOrder'); % other color choices
      C = {'k', 'r', 'b', 'g'}; % current maximum set to 4 colors
      lines = NaN(1, length(ac_shifts));
      
      for ac_shift = 1:length(ac_shifts)
        lines(ac_shift) = plot(V, Y(:, ac_shift), 'Color', C{ac_shift}, 'LineWidth', 2);
        set(gca,'YTick', [0, 0.2, 0.4, 0.6, 0.8, 1]);
        hold on;
        plot(hps(ac_shift), 0.5, 'o', 'MarkerSize', 8, 'MarkerFaceColor', [0.5 0.5 0.5], 'MarkerEdgeColor', [0.5 0.5 0.5], 'LineWidth', 1);
      end

      gate = char(x_inf);
      gate = gate(1);
      cond_name = cond.cpp_class_name;
      cond_name = strcat(gate, "_{", strrep(cond_name, 'Current', ''), "}");
      axis square;
      box off;
      xlabel('Voltage (mV)');
      ylabel([gate '_{∞}']);
      xlim(Vrange);
      ylim([0, 1]);
      title(cond_name);
      legend(lines, legend_titles, 'Location', 'northeast');
    end
  end
end