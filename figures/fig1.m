clear; close all;

%% Model setup and load data
model = 1;
model_str = ['m' num2str(model)];

hx0 = HKX(10000, -50, 24);
hx0.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', model);

target_conds = hx0.x.find('*ac_shift_*');
cond_pairs = nchoosek(target_conds, 2);
cond_pair_idx = 50;

load('heatmap_data.mat');
run get_ac_shift_mag; % to get data of ac_shift_magnitude

%% Generate data first
% 1: m1.ctrl.A.h-CaS.m
hx = hx0.copyHKX();
hx.setKPot(-80);
res_1 = hx.x.integrate;

% 2: m1.ctrl.A.h-CaS.m (shifted)
hx = hx0.copyHKX();
hx.setKPot(-80);
hx.x.set(cond_pairs(cond_pair_idx, :), ac_shift_mag(cond_pair_idx, :, 1)*-1);
res_2 = hx.x.integrate;

% 3: m1.high.A.h-CaS.m
hx = hx0.copyHKX();
hx.setKPot(-56);
res_3 = hx.x.integrate;

% 4: m1.high.A.h-CaS.m (shifted)
hx = hx0.copyHKX();
hx.setKPot(-56);
hx.x.set(cond_pairs(cond_pair_idx, :), ac_shift_mag(cond_pair_idx, :, 1)*-1);
res_4 = hx.x.integrate;

%% Plot the results

figure('outerposition',[0 0 1000 1500],'PaperUnits','points','PaperSize',[1000 1030]); hold on
tiledlayout(6, 6, 'TileSpacing', 'compact', 'Padding', 'compact');

% c_map = [42 45 108; 59 130 81; 157 106 53] ./ 255; % blue, green, brown
c_map = [183, 183, 183; 220, 124, 40; 74, 153, 249] / 255; % gray, orange, blue
% C = get(groot, 'DefaultAxesColorOrder');
shiftedColor = 'r';
% shiftedColor = C(2, :);
% shiftedColor = [0.635 0.078 0.184];
% shiftedColor = [194, 33, 111] / 255; % purple-redish

tcoi = length(hx0.x.time) * 4 / 5; % time cut off index
tvec = hx.x.time;
tvec = tvec(tcoi:end);
minus50line = [-50 -50];

% Plotting Ek = -80 data
Ek = -80;
if Ek == -56
  Ek_str = 'high';
else
  Ek_str = 'ctrl';
end

% Plot panel A.i
nexttile(1, [1 2]);
plot(tvec, res_1.PD.V(tcoi:end), 'k');
axis off;
title('Control');
ylim([-80, 50]);
hold on;
plot([8 10], minus50line, '--r', 'LineWidth', 2); % plot minus50line
plot([8 8.5], [-80 -80], 'k'); % plot the voltage and time indication
plot([8 8], [-60 -80], 'k'); % plot the voltage and time indication

% Plot panel A.ii
nexttile(7, [1 2]);
plot(tvec, res_2.PD.V(tcoi:end), 'k');
% plot(tvec, res_2.PD.V(tcoi:end), 'Color', [0.494 0.184 0.556]);
% plot(tvec, res_2.PD.V(tcoi:end), 'Color', [89, 29, 27]/255);
axis off;
t = title('Control (shifted)');
set(t, 'Color', shiftedColor);
ylim([-80, 50]);
hold on;
plot([8 10], minus50line, '--r', 'LineWidth', 2); % plot minus50line

% Plot panel B with Vrange 30mV
resolution = 101;
Vrange = 30;
resVrange_str = strcat("res", num2str(resolution), "_", num2str(Vrange), "mVrange");

dm_var1_space = linspace(-Vrange, Vrange, resolution);
dm_var2_space = linspace(-Vrange, Vrange, resolution);
[X, Y] = meshgrid(dm_var1_space, dm_var2_space);
all_params = [X(:), Y(:)]';

nexttile(3, [2 2]);
neuron_state = neuron_states.(resVrange_str).(model_str).(Ek_str)(cond_pair_idx, :);
cond_pair = cond_pairs(cond_pair_idx, :);
[~, hp_x, hp_y, ~] = hk_plots.heatmap_ac_shifts(neuron_state, cond_pair, hx.x, dm_var1_space, all_params);
ax = gca;
ax.Title.String = strcat("Control ", ax.Title.String);
set(gca,'XTick', []);
xlabel('');
point_o = [hp_y hp_x];
shifted_point = point_o + ac_shift_mag(cond_pair_idx, :, 1); % 0.6 is the 
scatter(shifted_point(2), shifted_point(1), 120, shiftedColor, 'filled');

% Plot panel B with Vrange 10mV
Vrange = 10;
resVrange_str = strcat("res", num2str(resolution), "_", num2str(Vrange), "mVrange");

dm_var1_space = linspace(-Vrange, Vrange, resolution);
dm_var2_space = linspace(-Vrange, Vrange, resolution);
[X, Y] = meshgrid(dm_var1_space, dm_var2_space);
all_params = [X(:), Y(:)]';

nexttile(5, [2 2]);
neuron_state = neuron_states.(resVrange_str).(model_str).(Ek_str)(cond_pair_idx, :);
cond_pair = cond_pairs(cond_pair_idx, :);
[~, hp_x, hp_y, ~] = hk_plots.heatmap_ac_shifts(neuron_state, cond_pair, hx.x, dm_var1_space, all_params);
ax = gca;
ax.Title.String = strcat("Control ", ax.Title.String);
set(gca,'XTick', []);
xlabel('');
point_o = [hp_y hp_x];
shifted_point = point_o + ac_shift_mag(cond_pair_idx, :, 1); % 0.6 is the 
scatter(shifted_point(2), shifted_point(1), 120, shiftedColor, 'filled');

% Plotting Ek = -56 data
Ek = -56;
if Ek == -56
  Ek_str = 'high';
else
  Ek_str = 'ctrl';
end

% Plot panel A.iii
nexttile(13, [1 2]);
plot(tvec, res_3.PD.V(tcoi:end), 'k');
axis off;
title('High [K^+]');
ylim([-80, 50]);
hold on;
plot([8 10], minus50line, '--r', 'LineWidth', 2); % plot minus50line

nexttile(19, [1 2]);
plot(tvec, res_4.PD.V(tcoi:end), 'k');
axis off;
t = title('High [K^+] (shifted)');
set(t, 'Color', shiftedColor);
ylim([-80, 50]);
hold on;
plot([8 10], minus50line, '--r', 'LineWidth', 2); % plot minus50line

% Plot panel C with Vrange = 30mV
Vrange = 30;
resVrange_str = strcat("res", num2str(resolution), "_", num2str(Vrange), "mVrange");

dm_var1_space = linspace(-Vrange, Vrange, resolution);
dm_var2_space = linspace(-Vrange, Vrange, resolution);
[X, Y] = meshgrid(dm_var1_space, dm_var2_space);
all_params = [X(:), Y(:)]';

nexttile(15, [2 2]);
neuron_state = neuron_states.(resVrange_str).(model_str).(Ek_str)(cond_pair_idx, :);
[~, hp_x, hp_y, ~] = hk_plots.heatmap_ac_shifts(neuron_state, cond_pair, hx.x, dm_var1_space, all_params);
ax = gca;
ax.Title.String = strcat("High [K^+] ", ax.Title.String);
% set(gca,'YTick', []);
% ylabel('');
point_o = [hp_y hp_x];
shifted_point = point_o + ac_shift_mag(cond_pair_idx, :, 1);
scatter(shifted_point(2), shifted_point(1), 120, shiftedColor, 'filled');

% Plot panel C with Vrange = 10mV
Vrange = 10;
resVrange_str = strcat("res", num2str(resolution), "_", num2str(Vrange), "mVrange");

dm_var1_space = linspace(-Vrange, Vrange, resolution);
dm_var2_space = linspace(-Vrange, Vrange, resolution);
[X, Y] = meshgrid(dm_var1_space, dm_var2_space);
all_params = [X(:), Y(:)]';

nexttile(17, [2 2]);
neuron_state = neuron_states.(resVrange_str).(model_str).(Ek_str)(cond_pair_idx, :);
[~, hp_x, hp_y, ~] = hk_plots.heatmap_ac_shifts(neuron_state, cond_pair, hx.x, dm_var1_space, all_params);
ax = gca;
ax.Title.String = strcat("High [K^+] ", ax.Title.String);
% set(gca,'YTick', []);
% ylabel('');
point_o = [hp_y hp_x];
shifted_point = point_o + ac_shift_mag(cond_pair_idx, :, 1); 
scatter(shifted_point(2), shifted_point(1), 120, shiftedColor, 'filled');

% Plot panel D activation curve
nexttile(26, [2 2]);
[n, cond_name, gate, ~] = xsplit(cond_pair(1));
Vrange = [-60, -10];
ac_shifts = [0, ac_shift_mag(cond_pair_idx, 1, 1)*-1];
plot_hp = true;
legend_titles = ["Control", "Late High [K^+]"];

hk_plots.plot_ac(hx.x.(n).(cond_name), Vrange, strcat(gate, "_inf"), ac_shifts, plot_hp, legend_titles);

% Plot legend
nt = nexttile(28, [2 2]);
for c = 1:3
  plot(NaN, NaN, '.', 'Color', c_map(c, :), 'LineWidth', 5, 'MarkerSize', 88);
  hold on;
end

legend(nt, ["Quiescent", "Tonic Spiking", "Bursting"], 'Location', 'northwest', 'FontSize', 16);
box off;
axis off;
nt.Legend.Box = 'off';

%% final figure modification
gcf_pos = get(gcf, 'Position');
gcf_pos(4) = 1500;
set(gcf, 'Position', gcf_pos);

figlib.pretty();
box off; % I somehow has to put it here or else last figure is not going to have box off