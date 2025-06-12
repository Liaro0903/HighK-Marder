% Test / demo file for plotting heatmap of classification of neuronal response of different activation shifts

clear; close all;

%% Model and data setup
model = 1;
model_str = ['m' num2str(model)];
hx = HKX(10000, -50, 24);
hx.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', model);
target_conds = hx.x.find('*ac_shift_*');
cond_pairs = nchoosek(target_conds, 2);
pair_idx = 50; % pair number 50 is the KCa-Kd pair
cond_pair = cond_pairs(pair_idx, :); 

load('heatmap_data.mat');

fig = figure('outerposition',[0 0 1200 720],'PaperUnits','points','PaperSize',[1800 1200]); hold on
tiledlayout(2, 4, 'TileSpacing', 'compact', 'Padding', 'compact');
c_map = [183, 183, 183; 220, 124, 40; 74, 153, 249] / 255; % gray, orange, blue

%% Plot case for resolution 31 x 31 data points and Vrange of -30mV to 30mV surrounding V1/2

resolution = 31;
Vrange = 30;
resVrange_str = strcat("res", num2str(resolution), "_", num2str(Vrange), "mVrange");

dm_var1_space = linspace(-Vrange, Vrange, resolution);
dm_var2_space = linspace(-Vrange, Vrange, resolution);
[X, Y] = meshgrid(dm_var1_space, dm_var2_space);
all_params = [X(:), Y(:)]';

% plot ctrl
nexttile(1);
neuron_state = neuron_states.(resVrange_str).(model_str).ctrl(pair_idx, :);
hk_plots.heatmap_ac_shifts(neuron_state, cond_pair, hx.x, dm_var1_space, all_params);
ax = gca;
t = get(get(ax, 'Title'), 'String');
title(strcat(t, ", ctrl, res ", num2str(resolution), ", ", num2str(Vrange), "Vrange"));
% plot highK
nexttile(5);
neuron_state = neuron_states.(resVrange_str).(model_str).high(pair_idx, :);
hk_plots.heatmap_ac_shifts(neuron_state, cond_pair, hx.x, dm_var1_space, all_params); 
ax = gca;
t = get(get(ax, 'Title'), 'String');
title(strcat(t, ", highK, res ", num2str(resolution), ", ", num2str(Vrange), "Vrange"));

%% Plot case for resolution 101 x 101 data points and Vrange of -30mV to 30mV surrounding V1/2

resolution = 101;
Vrange = 30;
resVrange_str = strcat("res", num2str(resolution), "_", num2str(Vrange), "mVrange");

dm_var1_space = linspace(-Vrange, Vrange, resolution);
dm_var2_space = linspace(-Vrange, Vrange, resolution);
[X, Y] = meshgrid(dm_var1_space, dm_var2_space);
all_params = [X(:), Y(:)]';

nexttile(2);
neuron_state = neuron_states.(resVrange_str).(model_str).ctrl(pair_idx, :);
hk_plots.heatmap_ac_shifts(neuron_state, cond_pair, hx.x, dm_var1_space, all_params);
ax = gca;
t = get(get(ax, 'Title'), 'String');
title(strcat(t, ", ctrl, res ", num2str(resolution), ", ", num2str(Vrange), "Vrange"));
nexttile(6);
neuron_state = neuron_states.(resVrange_str).(model_str).high(pair_idx, :);
hk_plots.heatmap_ac_shifts(neuron_state, cond_pair, hx.x, dm_var1_space, all_params);
ax = gca;
t = get(get(ax, 'Title'), 'String');
title(strcat(t, ", highK, res ", num2str(resolution), ", ", num2str(Vrange), "Vrange"));

%% Plot case for resolution 101 x 101 data points and Vrange of -15mV to 15mV surrounding V1/2

resolution = 101;
Vrange = 15;
resVrange_str = strcat("res", num2str(resolution), "_", num2str(Vrange), "mVrange");

dm_var1_space = linspace(-Vrange, Vrange, resolution);
dm_var2_space = linspace(-Vrange, Vrange, resolution);
[X, Y] = meshgrid(dm_var1_space, dm_var2_space);
all_params = [X(:), Y(:)]';

nexttile(3);
neuron_state = neuron_states.(resVrange_str).(model_str).ctrl(pair_idx, :);
hk_plots.heatmap_ac_shifts(neuron_state, cond_pair, hx.x, dm_var1_space, all_params);
ax = gca;
t = get(get(ax, 'Title'), 'String');
title(strcat(t, ", ctrl, res ", num2str(resolution), ", ", num2str(Vrange), "Vrange"));
nexttile(7);
neuron_state = neuron_states.(resVrange_str).(model_str).ctrl(pair_idx, :);
hk_plots.heatmap_ac_shifts(neuron_state, cond_pair, hx.x, dm_var1_space, all_params);
ax = gca;
t = get(get(ax, 'Title'), 'String');
title(strcat(t, ", highK, res ", num2str(resolution), ", ", num2str(Vrange), "Vrange"));

%% Plot case for resolution 101 x 101 data points and Vrange fo -10mV to 10mV surrounding V1/2

resolution = 101;
Vrange = 10;
resVrange_str = strcat("res", num2str(resolution), "_", num2str(Vrange), "mVrange");

dm_var1_space = linspace(-Vrange, Vrange, resolution);
dm_var2_space = linspace(-Vrange, Vrange, resolution);
[X, Y] = meshgrid(dm_var1_space, dm_var2_space);
all_params = [X(:), Y(:)]';

nexttile(4);
neuron_state = neuron_states.(resVrange_str).(model_str).ctrl(pair_idx, :);
hk_plots.heatmap_ac_shifts(neuron_state, cond_pair, hx.x, dm_var1_space, all_params);
ax = gca;
t = get(get(ax, 'Title'), 'String');
title(strcat(t, ", ctrl, res ", num2str(resolution), ", ", num2str(Vrange), "Vrange"));
nexttile(8);
neuron_state = neuron_states.(resVrange_str).(model_str).ctrl(pair_idx, :);
hk_plots.heatmap_ac_shifts(neuron_state, cond_pair, hx.x, dm_var1_space, all_params);
ax = gca;
t = get(get(ax, 'Title'), 'String');
title(strcat(t, ", highK, res ", num2str(resolution), ", ", num2str(Vrange), "Vrange"));
