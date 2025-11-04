clear; close all;

%% Global variables
model = 1;
model_str = ['m' num2str(model)];

hx = HKX(10000, -50, 24);
hx.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', model);

target_conds = hx.x.find('*ac_shift_*');
cond_pairs = nchoosek(target_conds, 2);

load('heatmap_data.mat');

resolution = 101;
Vrange = 30;
resVrange_str = strcat("res", num2str(resolution), "_", num2str(Vrange), "mVrange");

dm_var1_space = linspace(-Vrange, Vrange, resolution);
dm_var2_space = linspace(-Vrange, Vrange, resolution);
[X, Y] = meshgrid(dm_var1_space, dm_var2_space);
all_params = [X(:), Y(:)]';

c_map = [183, 183, 183; 220, 124, 40; 74, 153, 249] / 255; % gray, orange, blue

chosen_idx = [24 53 55 30 3 41 39 46];

fig = figure('outerposition',[0 0 930 960],'PaperUnits','points','PaperSize',[1800 1200]); hold on
tiledlayout(4, 4, 'TileSpacing', 'compact', 'Padding', 'compact');

for i = 1:8
  i = chosen_idx(i);
  cond_pair = cond_pairs(i, :);
  nexttile;
  neuron_state = neuron_states.(resVrange_str).(model_str).ctrl(i, :);
  hk_plots.heatmap_ac_shifts(neuron_state, cond_pair, hx.x, dm_var1_space, all_params);
  nexttile;
  neuron_state = neuron_states.(resVrange_str).(model_str).high(i, :);
  hk_plots.heatmap_ac_shifts(neuron_state, cond_pair, hx.x, dm_var1_space, all_params); 
  set(gca, 'YTick', []);
  set(gca, 'YLabel', []);
end

% saveas(fig, 'fig3.png');
