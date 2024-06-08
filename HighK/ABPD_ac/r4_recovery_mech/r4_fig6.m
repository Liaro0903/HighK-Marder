clear; close all;

% load data
load('r4_result6.mat');
threesec_timeranges = {[ ...
  50.34, 53.34; 115.19, 118.19; 330.093, 333.093; 351.89, 354.89;
]};

currentscape_timeranges = {[ ...
  50.34, 51.81; 115.19, 115.95; 330.093, 330.820; 351.89, 353.83;
]};

currentscape_timebars = {[
  50.34, 50.84; 115.19, 115.44; 330.093, 330.343; 351.89, 352.89;
]};

background_color = [42 45 108; 59 130 81; 157 106 53] ./ 255;

% Cut off the first 100 sec
tvec = hx.x.time;
tvec = tvec(1:400*1e4);
minus50line = [-50 -50];
result.PD.V = result.PD.V(100*1e4+1:end);

%% Figure 3: mechanism
% fig = figure('outerposition',[0 0 1180 1270],'PaperUnits','points','PaperSize', [1200 1200], 'renderer', 'Painters');
fig = figure('outerposition',[0 0 1180 1270],'PaperUnits','points','PaperSize', [1200 1200]);
tl = tiledlayout(40, 4, 'TileSpacing', 'tight', 'Padding', 'compact');

% 1: 3 sec plots
m = 1;
for tp = 1:length(threesec_timeranges{m})
  nexttile([6 1]);
  trange = uint32(threesec_timeranges{m}(tp,1)*1e4:threesec_timeranges{m}(tp,2)*1e4);
  plot(tvec(trange), result.PD.V(trange), 'k');
  hold on;
  plot(threesec_timeranges{m}(tp, :), minus50line, 'r', 'LineWidth', 2);
  % box off;
  axis off;
  % if (m == 1)
  %   title(timerange_title{tp});
  % end
  if (m == 1 && tp == 1) % 1 second indication
    plot([51 52], [-60 -60], 'k');
    plot([51 51], [-40 -60], 'k');
  end
  ylim([-60, 30]);
end
figlib.pretty('PlotLineWidth', 1, 'LineWidth', 0.5);
% return

% 2: Voltage trace
nexttile([7 4]);
a = area([98 350], [130 130], -80);
a(1).FaceColor = [0.82 0.87 0.64];
hold on;
plot(tvec, result.PD.V, 'k');
hold on;
plot([0 400], minus50line, 'r', 'LineWidth', 2);
for i = 1:length(threesec_timeranges{1})
  a2 = area([threesec_timeranges{1}(i, 1), threesec_timeranges{1}(i, 2) - 1], [60 60], -80);
  a2(1).FaceColor = background_color(1, :);
end
ylabel('V_M (mV)');
% title(['Voltage trace of model ' num2str(model) ' shifting KCa.m']);
box off;
set(gca, 'XTick', []);
ylim([-80, 40]);
set(gca, 'YTick', [-80, -40, 0, 40]);

% 3: Alpha
nexttile([5 4]);
a = area([98 350], [130 130], -80);
a(1).FaceColor = [0.82 0.87 0.64];
hold on;
plot(tvec, result.PD.AlphaSensor(100*1e4+1:end, 1), 'Color', [0 0.4470 0.7410], 'LineWidth', 2);
ylabel('Alpha (mV)');
% legend({'E_k', 'Alpha'});
% legend({'', 'V_{avg}'});
set(gca, 'XTick', []);
box off;
% ylim([-80, -30]);
ylim([-52 -35]);
set(gca, 'YTick', [-50 -40]);

% 4: Half Potential Shifts
nexttile([4 4]);
a = area([98 350], [130 130], -80);
a(1).FaceColor = [0.82 0.87 0.64];
hold on;
hp_KCa = -28.3;
hp_Kd = -12.3;
plot(tvec, result.PD.(target_conds{1}).ACSensor.IanProbe(100*1e4+1:end, 1).*-1 + hp_KCa, 'k', 'LineWidth', 2);
plot(tvec, result.PD.(target_conds{1}).ACSensor.IanProbe(100*1e4+1:end, 2).*-1 + hp_KCa, 'Color', [233 153 62] ./ 255, 'LineWidth', 2);
plot(tvec, result.PD.(target_conds{2}).ACSensor.IanProbe(100*1e4+1:end, 1).*-1 + hp_Kd, 'k', 'LineWidth', 2);
plot(tvec, result.PD.(target_conds{2}).ACSensor.IanProbe(100*1e4+1:end, 2).*-1 + hp_Kd, 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 2);
xlabel('Time (s)');
ylabel('V_{1/2} (mV)');
ylim([-40 -10]);
% title(['Half potential shifts of ' target_cond_var ' resulting from alpha']);
% legend({'', [target_conds{1} '.m shift'], [target_conds{1} '.m shift_{inf}']});
box off;

% 5: Currentscapes
for tr = 1:length(currentscape_timeranges{m})
  % 0: Plot setup
  nexttile([18 1]);
  show_legend = false;
  % if (tr == 5)
  %   show_legend = true;
  % end
  trange = uint32(currentscape_timeranges{m}(tr,1)*1e4:currentscape_timeranges{m}(tr,2)*1e4);

  % 1: Plot currentscape
  [~, sum_currents] = hx.x.mycurrentscape(result.PD, tl, trange, show_legend, true);
  hold on;

  % 2: Plot voltage traces
  plot(tvec(trange), result.PD.V(trange) / 100 + 3, 'k');
  hold on;

  % 3: Plot lines
  for p = -1:2:1
    for l = p*1.25:p*0.25:p*2
      plot(currentscape_timeranges{m}(tr, :), [l l], 'k:', 'LineWidth', 0.25);
    end
  end
  minus0point = 3;
  minus50point = -50 / 100 + minus0point;
  plot(currentscape_timeranges{m}(tr, :), [minus50point minus50point], 'r', 'LineWidth', 1);
  plot(currentscape_timebars{m}(tr, :), [3.7 3.7], 'k');
  if (tr == 1)
    plot([currentscape_timeranges{m}(tr, 1) currentscape_timeranges{m}(tr, 1)], [minus50point minus0point], 'k', 'LineWidth', 1);
  end

  % 4: Plot configurations
  xlim(currentscape_timeranges{m}(tr,:));
  ylim([-2, 4.2]);
  % if (tr ~= 1)
    set(gca, 'YTick', []);
  % end
  axis off;

end

% % sgtitle(['Recovery Mechanism Voltage Trace and Mechansim Variables of Single Compartment ABPD Prinz Model ', num2str(model), ', shifting ', target_cond_var]);

figlib.pretty('PlotLineWidth', 1, 'LineWidth', 0.5);
