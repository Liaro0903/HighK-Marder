clear; close all;

% load data
load('r4_results1.mat');

% Figure 2: activation curves
fig = figure('outerposition',[0 0 1800 900],'PaperUnits','points','PaperSize',[1200 1200]);
tl = tiledlayout(1, 3);
C = get(groot, 'DefaultAxesColorOrder');

Vrange = [-60 -10; -60 30; -40 -10];
Y = ones(1000, 2);
hp = ones(1, 2);

for m = 1:length(target_conds)
  nexttile;
  V = linspace(Vrange(m, 1), Vrange(m, 2), 1e3);
  [m_inf, h_inf] = hxs{m}.x.PD.(target_conds{m}).cpp_child_functions.fun_handle;  % h_inf are h_inf when the channel has h, or else it will be assigned to tau_m
  m_inf = func2str(m_inf);
  Ca = hxs{m}.x.PD.Ca_average * ones(1, 1e3);
  for ac_shift_m = 0:1
  % for ac_shift_m = 0:ac_shift_mag(model, m):ac_shift_mag(model, m)
    % calcualte Y
    m_inf_f = regexprep(m_inf, '\w+_\w+_\w', num2str(ac_shift_m * ac_shift_mag(model, m)));
    m_inf_f = strrep(m_inf_f, '/', './');
    m_inf_f = str2func(m_inf_f);
    Y(:, ac_shift_m+1) = m_inf_f(V, Ca);

    % use math to find out half potential value
    syms x y;
    m_inf_symbolic = symfun(m_inf_f(x, Ca(1)), [x, y]);
    eqn = m_inf_symbolic == 0.5;
    S = solve(eqn, x);
    hp(ac_shift_m+1) = double(S);
  end

  % Plot area between half potentials
  a = area(hp, [1 1]);
  a(1).FaceColor = [0.9 0.9 0.9];
  a(1).EdgeColor = [0.9 0.9 0.9];
  hold on;

  for c = 1:length(hp)
    % Plot activation curves
    plot(V, Y(:, c), 'Color', C(c, :));

    % Plot half potential value vertical lines
    % Y_hp = linspace(0, 1, 100);
    % S = hp(c) * ones(1, 100);
    % plot(S, Y_hp, '.', 'Color', [0.5 0.5 0.5]);
    hold on;
    plot(hp(c), 0.5, 'o', 'MarkerSize', 8, 'MarkerFaceColor', [0.5 0.5 0.5], 'MarkerEdgeColor', [0.5 0.5 0.5], 'LineWidth', 1);
  end

  axis square;
  box off;
  xlabel('Voltage (mV)');
  ylabel('m_{inf}');
  xlim(Vrange(m, :));
  ylim([0, 1]);
  title([target_conds{m} '.m']);
  if m == 1
    legend({'', 'Control', '', 'Late High [K^+]'}, 'Location', 'northwest');
  end
  % if m ~= 1
  %   set(gca, 'YTick', []);
  % end
end

% sgtitle(['Recovery Mechanism Activation Curve of Prinz Model ' num2str(model) ', shifting ' target_cond_var]);

figlib.pretty('PlotLineWidth', 3, 'LineWidth', 1);