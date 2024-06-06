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
    function ST_matrix = heatmap_ac_shifts(neuron_state, cond_pair, x, dm_var_space, all_params)
      % String truncate
      conds = strings(1, 2);
      gates = strings(1, 2);
      cond_gates = strings(1, 2);
      for i = 1:length(cond_pair)
        cond_str = string(cond_pair(i));
        cond_str = strsplit(cond_str, ".");
        neuron_name = cond_str(1);
        conds(i) = cond_str(2);
        gates(i) = strrep(cond_str(3), 'ac_shift_', '');
        cond_gates(i) = strcat(strrep(conds(i), 'Current', ''), '.', gates(i));
      end
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
    
      % Plot heatmap
      imagesc(ST_matrix, 'AlphaData', ~isnan(ST_matrix));
      % c_map = [42 45 108; 59 130 81; 157 106 53] ./ 255; % blue, green, brown
      % c_map = [61, 133, 198; 147, 196, 125; 234, 153, 153] / 255; % darker blue, lighter green, light red
      c_map = [183, 183, 183; 220, 124, 40; 74, 153, 249] / 255; % gray, orange, blue
      colormap(c_map);
      caxis([0 2]);

      % Label and plot axes
      [L, loc] = axlib.makeTickLabels(dm_var_space, 25); 
      hp_y = findhalfV(x.(neuron_name).(conds(1)), strcat(gates(1), '_inf'), 0);
      for l = 1:length(L)
        L{l} = num2str(str2double(L{l})*-1 + hp_y);
      end
      set(gca,'YTick', loc, 'YTickLabels', L)
 
      [L, loc] = axlib.makeTickLabels(dm_var_space, 25); 
      hp_x = findhalfV(x.(neuron_name).(conds(2)), strcat(gates(2), '_inf'), 0);
      for l = 1:length(L)
        L{l} = num2str(str2double(L{l})*-1 + hp_x);
      end
      set(gca,'XTick', loc, 'XTickLabels', L);

      hold on;
      plot([0,101], [51,51], '--w');
      plot([51,51], [0,101], '--w');
      scatter(51, 51, 120, 'k', 'filled');

      ylabel(strcat("V_{1/2 ", cond_gates(1), '} (mV)'));
      xlabel(strcat("V_{1/2 ", cond_gates(2), '} (mV)'));
      title(strcat(cond_gates(1), "-", cond_gates(2)));
      % axis xy
      set(gca,'xdir','reverse')
      axis square
      % colorbar('northoutside'); 
    end

    % function
    % cond
    % Vrange: 
    % ac_shifts
    % plot_hp: boolean
    % might still need some final touches
    function Y = plot_ac(cond, Vrange, x_inf, ac_shifts, plot_hp, Ca_average)
      num_ac_shifts = length(ac_shifts);
      Y = ones(1000, num_ac_shifts);
      V = linspace(Vrange(1), Vrange(2), 1e3);
      if (nargin < 6)
        Ca_average = 0;
      end
      Ca = Ca_average * ones(1, 1e3);
      hps = ones(1, num_ac_shifts);

      % Calculate halfV and Y
      for ac_shift = 1:length(ac_shifts)
        [hp, x_inf_f] = findhalfV(cond, x_inf, ac_shifts(ac_shift), Ca_average);
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
        % plot(V, Y(:, ac_shift), 'Color', C(ac_shift, :), 'LineWidth', 2);
        plot(V, Y(:, ac_shift), 'Color', C{ac_shift}, 'LineWidth', 2);
        hold on;
        plot(hps(ac_shift), 0.5, 'o', 'MarkerSize', 8, 'MarkerFaceColor', [0.5 0.5 0.5], 'MarkerEdgeColor', [0.5 0.5 0.5], 'LineWidth', 1);
      end

      axis square;
      box off;
      xlim(Vrange);
      ylim([0, 1]);

    end
    % function [V, Y_m, Y_h, hps] = plot_ac(Vrange, target_cond)
    %   Vrange = [-60 -10; -60 30;]; % KCa, Kd, A.h, CaS
    %   Y_m = ones(1000, 2);
    %   hp = ones(1, 2);
    %   V = linspace(Vrange(param_idx, 1), Vrange(param_idx, 2), 1e3);
    %   [m_inf, h_inf] = hx.x.PD.KCa.cpp_child_functions.fun_handle; % h_inf are h_inf when the channel has h, or else it will be assigned to tau_m
    %   m_inf = func2str(m_inf);
    %   Ca = hx.x.PD.Ca_average * ones(1, 1e3);
    %   % calcualte Y
    %   m_inf_f = regexprep(m_inf, '\w+_\w+_\w', num2str(ac_shift_m * ac_shift_mag(param_idx, 1, model)));
    %   m_inf_f = strrep(m_inf_f, '/', './');
    %   m_inf_f = str2func(m_inf_f);
    %   Y(:, ac_shift_m+1) = m_inf_f(V, Ca);
  
    %   hp(ac_shift_m+1) = double(S);
    
    %   % Plot area between half potentials
    %   a = area(hp, [1 1]);
    %   a(1).FaceColor = [0.9 0.9 0.9];
    %   a(1).EdgeColor = [0.9 0.9 0.9];
    %   hold on;
    
    %   C = get(groot, 'DefaultAxesColorOrder');
    
    %   for c = 1:length(hp)
    %     % Plot activation curves
    %     plot(V, Y(:, c), 'Color', C(c, :), 'LineWidth', 2);
    
    %     % Plot half potential value vertical lines
    %     % Y_hp = linspace(0, 1, 100);
    %     % S = hp(c) * ones(1, 100);
    %     % plot(S, Y_hp, '.', 'Color', [0.5 0.5 0.5]);
    %     hold on;
        % plot(hp(c), 0.5, 'o', 'MarkerSize', 8, 'MarkerFaceColor', [0.5 0.5 0.5], 'MarkerEdgeColor', [0.5 0.5 0.5], 'LineWidth', 1);
    %   end
    % end
  end
end