clear; close all;

%% Script params to play around
model = 1;
model_str = ['m' num2str(model)];

% resolution = 31;
resolution = 101;

%% Global variables
hx = HKX(10000, -50, 24);
hx.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', model);

target_conds = hx.x.find('*ac_shift_*');
cond_pairs = nchoosek(target_conds, 2);

% Prepare parameters
dm_var1_space = linspace(-30, 30, resolution);
dm_var2_space = linspace(-30, 30, resolution);
[X, Y] = meshgrid(dm_var1_space, dm_var2_space);
all_params = [X(:), Y(:)]';
% load('r4_fig7_data.mat');
load('r4_fig7_data_highres.mat');

% c_map = [42 45 108; 59 130 81; 157 106 53] ./ 255; % blue, green, brown
c_map = [183, 183, 183; 220, 124, 40; 74, 153, 249] / 255; % gray, orange, blue

for Ek = -80:24:-56

if Ek == -56
Ek_str = 'high';
else
Ek_str = 'ctrl';
end

for panel = 1:2

fig = figure('outerposition',[0 0 1800 1200],'PaperUnits','points','PaperSize',[1800 1200]); hold on
tiledlayout(4, 7, 'TileSpacing', 'compact', 'Padding', 'compact');

for i = (1+28*(panel-1)):(28+27*(panel-1))
  nexttile;
  neuron_state = neuron_states.(model_str).(Ek_str)(i, :);
  cond_pair = cond_pairs(i, :);
  ST_matrix = my_plots.heatmap_ac_shifts(neuron_state, cond_pair, hx.x, dm_var1_space, all_params);

end % end of for loop i

sgtitle(['Model ' num2str(model) ' neuron states at ' num2str(Ek) 'mV with different ΔV_{1/2}']);
if i == 55
  nt = nexttile;
  for c = 1:3
    plot(NaN, NaN, '.', 'Color', c_map(c, :), 'LineWidth', 5, 'MarkerSize', 33);
    hold on;
  end

  legend(nt, {"Quiescent", "Tonic Spiking", "Bursting"}, 'Location', 'northwest', 'FontSize', 16);
  box off;
  axis off;
  nt.Legend.Box = 'off';
end

saveas(fig, strcat(model_str, " ", num2str(Ek), " ", num2str(panel), ".png"));

end % end of for loop panel
end % end of for loop Ek