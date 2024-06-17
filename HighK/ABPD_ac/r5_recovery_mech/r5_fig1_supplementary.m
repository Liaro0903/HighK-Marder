clear; close all;

%% Script params to play around
model = 1;
model_str = ['m' num2str(model)];
resolution = 101;

%% Global variables
hx0 = HKX(10000, -50, 24);
hx0.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', model);

target_conds = hx0.x.find('*ac_shift_*');
cond_pairs = nchoosek(target_conds, 2);

% Prepare parameters
load('r4_fig7_data_highres.mat');
% load('r5_fig1_data.mat');
dm_var1_space = linspace(-30, 30, resolution);
dm_var2_space = linspace(-30, 30, resolution);
[X, Y] = meshgrid(dm_var1_space, dm_var2_space);
all_params = [X(:), Y(:)]';
run get_ac_shift_mag;
% load('ac_shift_mag.mat');
% ac_shifts_mag_raw = readmatrix('ac_shifts_mag.csv');
% ac_shift_mag = ac_shifts_mag_raw(1:55, :);
% ac_shift_mag(:, :, 2) = ac_shifts_mag_raw(1:55, :);

%% Loop through cond_pair (or not)
for cond_pair_idx = 18
% parfor cond_pair_idx = 1:length(cond_pairs)
disp(['cond_pair_idx: ', num2str(cond_pair_idx)]);

%% Generate data first
% 1: m1.ctrl
hx = hx0.copyHKX();
hx.setKPot(-80);
res_1 = hx.x.integrate;

% 2: m1.ctrl (shifted 1)
hx = hx0.copyHKX();
hx.setKPot(-80);
hx.x.set({cond_pairs{cond_pair_idx, :}}, ac_shift_mag(cond_pair_idx, :, 1)*-1);
res_2 = hx.x.integrate;

% 3: m1.ctrl (shifted 2)
hx = hx0.copyHKX();
hx.setKPot(-80);
hx.x.set({cond_pairs{cond_pair_idx, :}}, ac_shift_mag(cond_pair_idx, :, 2)*-1);
res_3 = hx.x.integrate;

% 4: m1.high
hx = hx0.copyHKX();
hx.setKPot(-56);
res_4 = hx.x.integrate;

% 5: m1.high (shifted 1)
hx = hx0.copyHKX();
hx.setKPot(-56);
% hx.x.set({cond_pairs{cond_pair_idx, :}}, ac_shift_mag(cond_pair_idx, :, 1)*-1);
hx.x.set(cond_pairs(cond_pair_idx, :), ac_shift_mag(cond_pair_idx, :, 1)*-1);
res_5 = hx.x.integrate;

% 6: m1.high (shifted 2)
hx = hx0.copyHKX();
hx.setKPot(-56);
hx.x.set({cond_pairs{cond_pair_idx, :}}, ac_shift_mag(cond_pair_idx, :, 2)*-1);
res_6 = hx.x.integrate;

%% Plot the results

fig = figure('outerposition',[0 0 1060 1300],'PaperUnits','points','PaperSize',[1000 300]); hold on
tiledlayout(5, 4, 'TileSpacing', 'compact', 'Padding', 'compact');

% color choice
c_map = [42 45 108; 59 130 81; 157 106 53] ./ 255; % blue, green, brown
% C = get(groot, 'DefaultAxesColorOrder');
% shiftedColor = C(2, :);
shiftedColor = 'r';
shiftedColor2 = 'b';
% shiftedColor = [0.635 0.078 0.184];
% shiftedColor = [194, 33, 111] / 255; % purple-redish

tcoi = length(hx0.x.time) * 4 / 5; % time cut off index
tvec = hx.x.time;
tvec = tvec(tcoi:end);
minus50line = [-50 -50];

model = 1;
model_str = ['m' num2str(model)];
shifted_dots = cell(2, 2);
shifted_plots = cell(2, 2);

Ek = -80;
if Ek == -56
  Ek_str = 'high';
else
  Ek_str = 'ctrl';
end
b = nexttile([2 2]);
neuron_state = neuron_states.(model_str).(Ek_str)(cond_pair_idx, :);
cond_pair = cond_pairs(cond_pair_idx, :);
[hmap_ctrl, hp_x, hp_y, cond_gates] = my_plots.heatmap_ac_shifts(neuron_state, cond_pair, hx.x, dm_var1_space, all_params);
ax = gca;
ax.Title.String = strcat("Control ", ax.Title.String);
% set(gca,'XTick', []);
% xlabel('');
% xlim([15 86]);
% ylim([15 86]);
point_o = [hp_y hp_x];
shifted_point = point_o + ac_shift_mag(cond_pair_idx, :, 1);  % 0.6 is the 
shifted_point2 = point_o + ac_shift_mag(cond_pair_idx, :, 2); % / 0.6  % 0.6 is the 
shifted_dots{1, 1} = scatter(shifted_point(2), shifted_point(1), 120, shiftedColor, 'filled');
hold on;
shifted_dots{1, 2} = scatter(shifted_point2(2), shifted_point2(1), 120, shiftedColor2, 'filled');

% uicontrol('Style', 'pushbutton', 'String', 'Default', ...
          % 'Position', [-49, -12.3, -49, 12.3])

Ek = -56;
if Ek == -56
  Ek_str = 'high';
else
  Ek_str = 'ctrl';
end
nexttile([2 2]);
neuron_state = neuron_states.(model_str).(Ek_str)(cond_pair_idx, :);
cond_pair = cond_pairs(cond_pair_idx, :);
[hmap_high, hp_x, hp_y] = my_plots.heatmap_ac_shifts(neuron_state, cond_pair, hx.x, dm_var1_space, all_params);
ax = gca;
ax.Title.String = strcat("High [K^+] ", ax.Title.String);
% set(gca,'YTick', []);
% ylabel('');
% xlim([15 86]);
% ylim([15 86]);
% point_o = [hp_x hp_y];
shifted_dots{2, 1} = scatter(shifted_point(2), shifted_point(1), 120, shiftedColor, 'filled');
hold on;
shifted_dots{2, 2} = scatter(shifted_point2(2), shifted_point2(1), 120, shiftedColor2, 'filled');
% shifted_dots{2, 2} = scatter(-38.9, -5.3, 120, shiftedColor2, 'filled');
colorbar('northoutside', 'Ticks', [0.33, 1, 1.67], 'TickLabels', {'Quiescent', 'Tonic Spiking', 'Bursting'});

% Another way of doing legend
% scatter(NaN, NaN, 200, 'gs', 'filled', 'DisplayName', 'Quiescent');
% scatter(NaN, NaN, 200, 'ms', 'filled', 'DisplayName', 'Tonic Spiking');
% scatter(NaN, NaN, 200, 'ys', 'filled', 'DisplayName', 'Bursting');
% lgd = legend({'', '', '', '', 'Quiescent', 'Tonic Spiking', 'Bursting'}, 'Orientation', 'horizontal', 'Location', 'southoutside');
% lgd.Layout.Tile = 'southwest';

nexttile(9, [1 2]);
plot(tvec, res_1.PD.V(tcoi:end), 'k');
axis off;
title('Control');
ylim([-80, 50]);
hold on;
plot([8 10], minus50line, '--r', 'LineWidth', 2); % plot minus50line
plot([8 8.5], [-80 -80], 'k'); % plot the voltage and time indication
plot([8 8], [-60 -80], 'k'); % plot the voltage and time indication

nexttile(13, [1 2]);
shifted_plots{1, 1} = plot(tvec, res_2.PD.V(tcoi:end), 'k');
% plot(tvec, res_2.PD.V(tcoi:end), 'Color', [0.494 0.184 0.556]);
% plot(tvec, res_2.PD.V(tcoi:end), 'Color', [89, 29, 27]/255);
axis off;
t = title('Control (shifted 1)');
set(t, 'Color', shiftedColor);
ylim([-80, 50]);
hold on;
plot([8 10], minus50line, '--r', 'LineWidth', 2); % plot minus50line

nexttile(17, [1 2]);
shifted_plots{1, 2} = plot(tvec, res_3.PD.V(tcoi:end), 'k');
% plot(tvec, res_2.PD.V(tcoi:end), 'Color', [0.494 0.184 0.556]);
% plot(tvec, res_2.PD.V(tcoi:end), 'Color', [89, 29, 27]/255);
axis off;
t = title('Control (shifted 2)');
set(t, 'Color', shiftedColor2);
ylim([-80, 50]);
hold on;
plot([8 10], minus50line, '--r', 'LineWidth', 2); % plot minus50line

nexttile(11, [1 2]);
plot(tvec, res_4.PD.V(tcoi:end), 'k');
axis off;
title('High [K^+]');
ylim([-80, 50]);
hold on;
plot([8 10], minus50line, '--r', 'LineWidth', 2); % plot minus50line

nexttile(15, [1 2]);
shifted_plots{2, 1} = plot(tvec, res_5.PD.V(tcoi:end), 'k');
axis off;
t = title('High [K^+] (shifted 1)');
set(t, 'Color', shiftedColor);
ylim([-80, 50]);
hold on;
plot([8 10], minus50line, '--r', 'LineWidth', 2); % plot minus50line

nexttile(19, [1 2]);
shifted_plots{2, 2} = plot(tvec, res_6.PD.V(tcoi:end), 'k');
axis off;
t = title('High [K^+] (shifted 2)');
set(t, 'Color', shiftedColor2);
ylim([-80, 50]);
hold on;
plot([8 10], minus50line, '--r', 'LineWidth', 2); % plot minus50line

figlib.pretty();

gcf_pos = get(gcf, 'Position');
gcf_pos(4) = 1300;
set(gcf, 'Position', gcf_pos);

% saveas(fig, ['./fig1_supplementary/' num2str(cond_pair_idx) '.png']);

% Set functionalities
set(hmap_ctrl, 'ButtonDownFcn', @(src, event) figureclickcallback( ...
  src, event, shifted_dots, shifted_plots, hx0, cond_pairs(cond_pair_idx, :), point_o, tcoi ...
));

set(hmap_high, 'ButtonDownFcn', @(src, event) figureclickcallback( ...
  src, event, shifted_dots, shifted_plots, hx0, cond_pairs(cond_pair_idx, :), point_o, tcoi ...
));

rowx = dataTipTextRow(cond_gates(2), 'XData');
rowy = dataTipTextRow(cond_gates(1), 'YData');
for i = 1:2
  for j = 1:2
    set(shifted_dots{i, j}, 'ButtonDownFcn', @(src, event) datatipcallback(event, shifted_dots{i, j}));
    shifted_dots{i, j}.DataTipTemplate.DataTipRows(1:2) = [rowx rowy];
    shifted_dots{i, j}.DataTipTemplate.DataTipRows(3) = [];
  end
end

end

function figureclickcallback(src, event, shifted_dots, shifted_plots, hx_o, cond_pair, point_o, tcoi)
  fig = ancestor(src, 'figure');
  clickType = get(fig, 'SelectionType');

  new_point = round(event.IntersectionPoint); % new point selected by the user
  new_point(end) = []; % delete the last data point (because event.IntersectionPoint gives a 3D data)
  ac_shifts_mag = fliplr(new_point) - point_o; % flip because the cond_pair order is yx. point_o is already yx

  switch clickType
    case 'normal' % clicked left mouse and move 1st point
      for i = 1:2
        shifted_dots{i, 1}.XData = new_point(1);
        shifted_dots{i, 1}.YData = new_point(2);
        hx = hx_o.copyHKX();
        hx.setKPot(-80 + (i-1) * 24); % therefore when it's turn to update high k, it will become -56
        hx.x.set(cond_pair, ac_shifts_mag*-1); % *-1 because current xolotl code is positive shift hp is more negative, but the user input is negative shifts mean negative hp
        res = hx.x.integrate;
        shifted_plots{i, 1}.YData = res.PD.V(tcoi:end);
      end
    case 'alt' % clicked right mouse and move 2nd point
      for i = 1:2
        shifted_dots{i, 2}.XData = new_point(1);
        shifted_dots{i, 2}.YData = new_point(2);
        hx = hx_o.copyHKX();
        hx.setKPot(-80 + (i-1) * 24); % therefore when it's turn to update high k, it will become -56
        hx.x.set(cond_pair, ac_shifts_mag*-1); % *-1 because current xolotl code is positive shift hp is more negative, but the user input is negative shifts mean negative hp
        res = hx.x.integrate;
        shifted_plots{i, 2}.YData = res.PD.V(tcoi:end);
      end
    otherwise
      disp('Unknown mouse button clicked');
  end
end

function datatipcallback(event, shifted_dot)
  datatip(shifted_dot, event.IntersectionPoint(1), event.IntersectionPoint(2));
end