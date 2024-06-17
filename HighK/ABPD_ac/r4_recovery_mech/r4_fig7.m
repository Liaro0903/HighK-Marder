clear; close all;

%% Script params to play around
model = 1;
model_str = ['m' num2str(model)];
Ek = -80;
if Ek == -56
  Ek_str = 'high';
else
  Ek_str = 'ctrl';
end

% resolution = 31;
resolution = 101;

%% Global variables
hx = HKX(10000, -50, 24);
hx.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', model);
% hx.setKPot(-56);
% hx.x.integrate;

target_conds = hx.x.find('*ac_shift_*');
cond_pairs = nchoosek(target_conds, 2);

% Prepare parameters
dm_var1_space = linspace(-30, 30, resolution);
dm_var2_space = linspace(-30, 30, resolution);
[X, Y] = meshgrid(dm_var1_space, dm_var2_space);
all_params = [X(:), Y(:)]';
% load('r4_fig7_data.mat');
load('r4_fig7_data_highres.mat');

figure('outerposition',[0 0 1800 1200],'PaperUnits','points','PaperSize',[1800 1200]); hold on
tiledlayout(4, 7, 'TileSpacing', 'compact', 'Padding', 'compact');

% c_map = [42 45 108; 59 130 81; 157 106 53] ./ 255; % blue, green, brown
c_map = [183, 183, 183; 220, 124, 40; 74, 153, 249] / 255; % gray, orange, blue

for i = 1:28
% for i = 29:55

  nexttile;
  neuron_state = neuron_states.(model_str).(Ek_str)(i, :);
  cond_pair = cond_pairs(i, :);
  ST_matrix = my_plots.heatmap_ac_shifts(neuron_state, cond_pair, hx.x, dm_var1_space, all_params);

  % old code for reference
  % cut_str_idx_1 = strfind(cond_pairs{i, 1}, "ac_shift_");
  % cut_str_idx_2 = strfind(cond_pairs{i, 2}, "ac_shift_");
  % cond1 = [cond_pairs{i, 1}(4:cut_str_idx_1-1) cond_pairs{i, 1}(cut_str_idx_1+strlength("ac_shift_"):end)];
  % cond2 = [cond_pairs{i, 2}(4:cut_str_idx_2-1) cond_pairs{i, 2}(cut_str_idx_2+strlength("ac_shift_"):end)];
  % if (contains(cond1, 'Current'))
  %   cut_str_idx_1 = strfind(cond1, "Current");
  %   cond1 = [cond1(1:cut_str_idx_1-1) cond1(cut_str_idx_1+strlength("Current"):end)];
  % end
  % if (contains(cond2, 'Current'))
  %   cut_str_idx_2 = strfind(cond2, "Current");
  %   cond2 = [cond2(1:cut_str_idx_2-1) cond2(cut_str_idx_2+strlength("Current"):end)];
  % end

  % % BP_matrix = NaN(length(dm_var1_space),length(dm_var2_space));
  % % NS_matrix = NaN(length(dm_var1_space),length(dm_var2_space));
  % % IB_matrix = NaN(length(dm_var1_space),length(dm_var2_space));
  % ST_matrix = NaN(length(dm_var1_space),length(dm_var2_space));
  % for j = 1:length(all_params)
  %     xx = find(all_params(1,j) == dm_var1_space);
  %     y = find(all_params(2,j) == dm_var2_space);
  %     % BP_matrix(xx,y) = burst_period(j);
  %     % NS_matrix(xx,y) = n_spikes_per_burst(j);
  %     % IB_matrix(xx,y) = ibi_mean(j);
  %     ST_matrix(xx,y) = neuron_states.(model_str).(Ek_str)(i, j);
  %     % break
  % end
  % % BP_matrix(BP_matrix<0) = NaN;
  % % NS_matrix(NS_matrix<0) = 0;
  % % IB_matrix(IB_matrix<0) = 0;
  % ST_matrix(ST_matrix<0) = 0;

  % % subplot(2,2,4)
  % nexttile;
  % imagesc(ST_matrix, 'AlphaData', ~isnan(ST_matrix));
  % colormap(c_map);
  % caxis([0 2]);
  % [L, loc] = axlib.makeTickLabels(dm_var1_space, 4);
  % % loc = [1, 5, 10, 15, 20];
  % % loc = [1, 5, 10, 15, 20];
  % % L = [-30, -15, 0, 15, 30];
  % set(gca,'YTick', loc,'YTickLabels', L)
  % [L,loc] = axlib.makeTickLabels(dm_var2_space, 6);
  % set(gca,'XTick', loc,'XTickLabels', L);
  % ylabel(['ΔV_{1/2 ' cond1 '}']);
  % xlabel(['ΔV_{1/2 ' cond2 '}']);
  % title([cond1 '-' cond2])
  % axis xy
  % axis square
  % % colorbar('northoutside');

  % % figlib.pretty();

end

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
