clear; close all;

%% Script params to play around
model = 1;

%% Global variables
hx = HKX(10000, -50, 24);
hx.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', model);
% hx.setKPot(-56);
% hx.x.integrate;

target_conds = hx.x.find('*ac_shift_*');
cond_pairs = nchoosek(target_conds, 2);

% Prepare parameters
dm_var1_space = linspace(-30, 30, 20);
dm_var2_space = linspace(-30, 30, 20);
[X, Y] = meshgrid(dm_var1_space, dm_var2_space);
all_params = [X(:), Y(:)]';
load('r4_fig7_data.mat');

figure('outerposition',[0 0 1800 1200],'PaperUnits','points','PaperSize',[1800 1200]); hold on
tiledlayout(4, 7, 'TileSpacing', 'compact', 'Padding', 'compact');

c_map = [42 45 108; 59 130 81; 157 106 53] ./ 255; % blue, green, brown

for i = 1:28
% for i = 29:55
  cut_str_idx_1 = strfind(cond_pairs{i, 1}, "ac_shift_");
  cut_str_idx_2 = strfind(cond_pairs{i, 2}, "ac_shift_");
  cond1 = [cond_pairs{i, 1}(4:cut_str_idx_1-1) cond_pairs{i, 1}(cut_str_idx_1+strlength("ac_shift_"):end)];
  cond2 = [cond_pairs{i, 2}(4:cut_str_idx_2-1) cond_pairs{i, 2}(cut_str_idx_2+strlength("ac_shift_"):end)];
  if (contains(cond1, 'Current'))
    cut_str_idx_1 = strfind(cond1, "Current");
    cond1 = [cond1(1:cut_str_idx_1-1) cond1(cut_str_idx_1+strlength("Current"):end)];
  end
  if (contains(cond2, 'Current'))
    cut_str_idx_2 = strfind(cond2, "Current");
    cond2 = [cond2(1:cut_str_idx_2-1) cond2(cut_str_idx_2+strlength("Current"):end)];
  end

  ST_matrix_80 = NaN(length(dm_var1_space),length(dm_var2_space));
  ST_matrix_56 = NaN(length(dm_var1_space),length(dm_var2_space));
  for j = 1:length(all_params)
      xx = find(all_params(1,j) == dm_var1_space);
      y = find(all_params(2,j) == dm_var2_space);
      ST_matrix_80(xx,y) = neuron_states.ctrl(i, j);
      ST_matrix_56(xx,y) = neuron_states.high(i, j);
  end
  ST_matrix_80(ST_matrix_80 < 0) = 0;
  ST_matrix_56(ST_matrix_56 < 0) = 0;
  
  % compare and find intersection
  ST_matrix_80 = ST_matrix_80 + 1;
  ST_matrix_56 = ST_matrix_56 + 1;

  ST_matrix = ST_matrix_80 .* (ST_matrix_80 == ST_matrix_56);
  ST_matrix(ST_matrix == 0) = NaN;
  ST_matrix = ST_matrix - 1;

  nexttile;
  imagesc(ST_matrix, 'AlphaData', ~isnan(ST_matrix));
  colormap(c_map);
  caxis([0 2]);
  % [L, loc] = axlib.makeTickLabels(dm_var1_space, 4);
  loc = [1, 5, 10, 15, 20];
  L = [-30, -15, 0, 15, 30];
  set(gca,'YTick', loc,'YTickLabels', L)
  % [L,loc] = axlib.makeTickLabels(dm_var2_space,6);
  set(gca,'XTick', loc,'XTickLabels', L);
  ylabel(['ΔV_{1/2 ' cond1 '}']);
  xlabel(['ΔV_{1/2 ' cond2 '}']);
  title([cond1 '-' cond2])
  axis xy
  axis square
  % colorbar('northoutside');

  % figlib.pretty();

end

sgtitle(['Neuron states that are equivalent in -56mV and -80mV for different ΔV_{1/2}']);
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
