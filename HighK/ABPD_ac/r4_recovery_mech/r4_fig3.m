clear; close all;

% view_regular = true;
% pix_only
% vec_only

% load data
load('r4_results1.mat');
threesec_timeranges = {[ ...
  49.82, 52.82; 116.008, 119.008; 330.075, 333.075; 350.3, 353.3;
]};

currentscape_timeranges = {[ ...
  49.82, 51.82; 116.008, 116.158; 330.075, 331.070; 350.3, 351.91;
]};

currentscape_timebars = {[
  49.82, 50.82; 116.008, 116.058; 330.075, 330.575; 350.3, 350.8;
]};

background_color = [42 45 108; 59 130 81; 157 106 53] ./ 255;

% Cut off the first 100 sec
tvec = hxs{1}.x.time;
tvec = tvec(1:400*1e4);
minus50line = [-50 -50];
for m = 1:length(target_conds)
  results{m}.PD.V = results{m}.PD.V(100*1e4+1:end);
end

%% Figure 3: mechanism
% fig = figure('outerposition',[0 0 1180 1270],'PaperUnits','points','PaperSize', [1200 1200], 'renderer', 'Painters');
fig = figure('outerposition',[0 0 1180 1270],'PaperUnits','points','PaperSize', [1200 1200]);
tl = tiledlayout(40, 4, 'TileSpacing', 'tight', 'Padding', 'compact');

% 1: 3 sec plots
m = 1;
for tp = 1:length(threesec_timeranges{m})
  nexttile([7 1]);
  trange = uint32(threesec_timeranges{m}(tp,1)*1e4:threesec_timeranges{m}(tp,2)*1e4);
  plot(tvec(trange), results{m}.PD.V(trange), 'k');
  hold on;
  plot(threesec_timeranges{m}(tp, :), minus50line, 'r', 'LineWidth', 2);
  % box off;
  axis off;
  % if (m == 1)
  %   title(timerange_title{tp});
  % end
  if (m == 1 && tp == 1) % 1 second indication
    plot([51 52], [-80 -80], 'k');
    plot([51 51], [-60 -80], 'k');
  end
  ylim([-80, 60]);
end

% 2: Voltage trace
nexttile([7 4]);
a = area([98 350], [130 130], -80);
a(1).FaceColor = [0.82 0.87 0.64];
hold on;
plot(tvec, results{1}.PD.V, 'k');
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
ylim([-80, 55]);

% 3: Alpha
nexttile([5 4]);
a = area([98 350], [130 130], -80);
a(1).FaceColor = [0.82 0.87 0.64];
hold on;
plot(tvec, results{1}.PD.AlphaSensor(100*1e4+1:end, 1), 'Color', [0 0.4470 0.7410], 'LineWidth', 2);
ylabel('Alpha (mV)');
% legend({'E_k', 'Alpha'});
% legend({'', 'V_{avg}'});
set(gca, 'XTick', []);
box off;
% ylim([-80, -30]);
ylim([-55 -35]);

% 4: Half Potential Shifts
nexttile([6 4]);
a = area([98 350], [130 130], -80);
a(1).FaceColor = [0.82 0.87 0.64];
hold on;
hp = -28.3;
plot(tvec, results{1}.PD.(target_conds{1}).ACSensor.IanProbe(100*1e4+1:end, 1).*-1 + hp, 'k', 'LineWidth', 2);
plot(tvec, results{1}.PD.(target_conds{1}).ACSensor.IanProbe(100*1e4+1:end, 2).*-1 + hp, 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 2);
xlabel('Time (s)');
ylabel('V_{1/2} (mV)');
ylim([-31.5 -28])
% title(['Half potential shifts of ' target_cond_var ' resulting from alpha']);
% legend({'', [target_conds{1} '.m shift'], [target_conds{1} '.m shift_{inf}']});
box off;

% 5: Currentscapes
for tr = 1:length(currentscape_timeranges{m})
  % 0: Plot setup
  nexttile([15 1]);
  show_legend = false;
  % if (tr == 5)
  %   show_legend = true;
  % end
  trange = uint32(currentscape_timeranges{m}(tr,1)*1e4:currentscape_timeranges{m}(tr,2)*1e4);

  % 1: Plot currentscape
  [~, sum_currents] = hxs{m}.x.mycurrentscape(results{m}.PD, tl, trange, show_legend, true);
  hold on;

  % 2: Plot voltage traces
  plot(tvec(trange), results{m}.PD.V(trange) / 100 + 3.5, 'k');
  hold on;

  % 3: Plot lines
  for p = -1:2:1
    for l = p*1.25:p*0.25:p*2
      plot(currentscape_timeranges{m}(tr, :), [l l], 'k:', 'LineWidth', 0.25);
    end
  end
  minus50point = -50 / 100 + 3.5;
  minus0point = 3.5;
  plot(currentscape_timeranges{m}(tr, :), [minus50point minus50point], 'r', 'LineWidth', 1);
  plot(currentscape_timebars{m}(tr, :), [4.2 4.2], 'k');
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

% run tiledlayout_demo.m