% This plots the distributions for each channel for each neuron for distribution comparison

clear;
close all;

load('FindABcPD_rand_3.mat');

distribution_1_params = params;
% params_to_be_graphed = params_filtered; %% if there's params_filtered

load('FindABcPD_rand_high_7.mat');
distribution_2_params = params;

load('FindABcPD_rand_ac_1.mat');
distribution_3_params = params;

load('params_to_vary.mat');

conds = {'ACurrent', 'CaS', 'CaT', 'HCurrent', 'KCa', 'Kd', 'Leak', 'NaV'};

%% Part 1: Scatter Plot
% num_models = length(params_to_be_graphed);
% AB_X = repmat((1:7), 1, num_models) + 0.8 * rand(1, 7 * num_models) - 0.4;
% AB_Y = reshape(params_to_be_graphed(1:7, :), 1, 7 * num_models);
% scatter(AB_X, AB_Y);

% PY_X = repmat((1:8), 1, num_models) + 0.8 * rand(1, 8 * num_models) - 0.4;
% PY_Y = reshape(params_to_be_graphed(8:15, :), 1, 8 * num_models);
% figure;
% scatter(PY_X, PY_Y);

%% Part 2: Histograms
% Graph AB histograms
figure('outerposition', [0 0 1800 900]);
hold on;
for i = 1:7 
  subplot(2, 4, i);
  % histogram(distribution_1_params(i,:), 30, 'facecolor', 'red', 'facealpha', 0.3, 'edgecolor', 'none', 'linewidth', 1, 'normalization', 'probability');
  histogram(distribution_1_params(i,:), 30, 'facecolor', '#60BAFF', 'facealpha', 0.7, 'edgecolor', 'none', 'linewidth', 1, 'normalization', 'probability');
  % histogram(distribution_1_params(i,:), 30, 'facecolor', '#84ACB6', 'facealpha', 0.9, 'edgecolor', 'none', 'linewidth', 1, 'normalization', 'probability');
  hold on;
  % histogram(distribution_2_params(i,:), 30, 'facecolor', 'blue', 'FaceAlpha', 0.3, 'edgecolor', 'none', 'linewidth', 1, 'normalization', 'probability');
  histogram(distribution_2_params(i,:), 30, 'facecolor', '#9860FF', 'FaceAlpha', 0.5, 'edgecolor', 'none', 'linewidth', 1, 'normalization', 'probability');
  % histogram(distribution_2_params(i,:), 30, 'facecolor', '#DECEE8', 'FaceAlpha', 0.9, 'edgecolor', 'none', 'linewidth', 1, 'normalization', 'probability');
  hold on;
  % histogram(distribution_3_params(i,:), 30, 'facecolor', 'green', 'FaceAlpha', 0.3, 'edgecolor', 'none', 'linewidth', 1, 'normalization', 'probability');
  % histogram(distribution_3_params(i,:), 30, 'displaystyle', 'stairs', 'FaceAlpha', 0.1, 'edgecolor', 'c', 'linewidth', 1, 'normalization', 'probability');
  % title(params_to_vary{i});
  title(conds{i});
  xlabel('max conductances (μS)');
  ylabel('probability of occurence');
  box off;
  axis tight;
  set(gca, 'YTick', []);
  % if i == 1
  %   legend('Distribution 1', 'Distribution 2', 'Distribution 3', 'location', 'southeast');
  % end
end
sgtitle('Histogram of Max gbar AB Distribution 1 vs Distribution 2');

figlib.pretty('PlotLineWidth', 0.5,'LineWidth', 0.5);

% Graph PD histograms
figure('outerposition', [0 0 1800 900]);
hold on;
for i = 1:8
  subplot(2, 4, i);
  % histogram(distribution_1_params(i+7,:), 30, 'facecolor', 'red', 'facealpha', 0.3, 'edgecolor', 'none', 'linewidth', 1, 'normalization', 'probability')
  histogram(distribution_1_params(i+7,:), 30, 'facecolor', '#60BAFF', 'facealpha', 0.7, 'edgecolor', 'none', 'linewidth', 1, 'normalization', 'probability')
  hold on;
  % histogram(distribution_2_params(i+7,:), 30, 'facecolor', 'blue', 'FaceAlpha', 0.3, 'edgecolor', 'none', 'linewidth', 1, 'normalization', 'probability');
  histogram(distribution_2_params(i+7,:), 30, 'facecolor', '#9860FF', 'FaceAlpha', 0.5, 'edgecolor', 'none', 'linewidth', 1, 'normalization', 'probability');
  hold on;
  % histogram(distribution_3_params(i+7,:), 30, 'facecolor', 'green', 'FaceAlpha', 0.3, 'edgecolor', 'none', 'linewidth', 1, 'normalization', 'probability');
  % title(params_to_vary{i+7});
  title(conds{i});
  xlabel('max conductances (μS)');
  ylabel('probability of occurence');
  box off;
  axis tight;
  set(gca, 'YTick', []);
  % if i == 1
  %   legend('Distribution 1', 'Distribution 2', 'Distribution 3', 'location', 'southeast');
  % end
end
sgtitle('Histogram of Max gbar PD Distribution 1 vs Distribution 2');

figlib.pretty('PlotLineWidth', 0.5,'LineWidth', 0.5);

% Graph AB shifting half potential
% figure('outerposition', [0 0 1800 900]);
% hold on;
% for i = 1:6
%   subplot(2, 4, i);
%   histogram(distribution_3_params(i+15,:), 30, 'facecolor', 'red', 'facealpha', 0.3, 'edgecolor', 'none', 'linewidth', 1, 'normalization', 'probability'); % plot the m
%   hold on;
%   if (i <= 3)
%     histogram(distribution_3_params(i+28,:), 30, 'facecolor', 'blue', 'facealpha', 0.3, 'edgecolor', 'none', 'linewidth', 1, 'normalization', 'probability'); % plot the h
%   end
%   title(['AB.', conds{i}]);
%   xlabel('Shifts in half potential');
%   ylabel('probability of occurence');
%   box off;
%   axis tight;
%   set(gca, 'YTick', []);
%   xlim([-4.9 4.9]);
%   if i == 1
%     legend('m', 'h', 'location', 'southeast');
%   end
% end
% sgtitle('Histogram of half potential shifts in AB Distribution 3');
% figlib.pretty('PlotLineWidth', 0.5,'LineWidth', 0.5);

% Graph PD shifting half potential
% figure('outerposition', [0 0 1800 900]);
% hold on;
% for i = 1:7
%   subplot(2, 4, i);
%   histogram(distribution_3_params(i+21,:), 30, 'facecolor', 'r', 'facealpha', 0.3, 'edgecolor', 'none', 'linewidth', 1, 'normalization', 'probability'); % plot the m
%   hold on;
%   if (i <= 3)
%     histogram(distribution_3_params(i+31,:), 30, 'facecolor', 'b', 'facealpha', 0.3, 'edgecolor', 'none', 'linewidth', 1, 'normalization', 'probability'); % plot the h
%   end
%   if (i == 7) % for the last NaV
%     histogram(distribution_3_params(35,:), 30, 'facecolor', 'b', 'facealpha', 0.3, 'edgecolor', 'none', 'linewidth', 1, 'normalization', 'probability'); % plot the h
%   end
%   title(['PD.', conds{i}]);
%   xlabel('Shifts in half potential');
%   ylabel('probability of occurence');
%   box off;
%   axis tight;
%   set(gca, 'YTick', []);
%   xlim([-4.9 4.9]);
%   if i == 1
%     legend('m', 'h', 'location', 'southeast');
%   end
% end
% sgtitle('Histogram of half potential shifts in PD Distribution 3');
% figlib.pretty('PlotLineWidth', 0.5,'LineWidth', 0.5);

% Ca = 160;

% ac = {
%   (@(dm) @(V) 1.0./(1.0+exp((V+27.2+dm)./-8.7))), ...
%   (@(dm) @(V) 1.0./(1.0+exp((V+33.0+dm)./-8.1))), ...
%   (@(dm) @(V) 1.0./(1.0+exp((V+27.1+dm)./-7.2))), ...
%   (@(dm) @(V) 1.0./(1.0+exp((V+75.0+dm)./5.5))), ...
%   (@(dm) @(V) (Ca./(Ca+3.0))./(1.0+exp((V+28.3+dm)./-12.6))), ...
%   (@(dm) @(V) 1.0./(1.0+exp((V+12.3+dm)./-11.8))), ...
%   (@(dm) @(V) 1.0./(1.0+exp((V+25.5+dm)./-5.29)))
% };

% inac = {
%   (@(dh) @(V) 1.0./(1.0+exp((V+56.9+dh)./4.9))), ...
%   (@(dh) @(V) 1.0./(1.0+exp((V+60.0+dh)./6.2))), ...
%   (@(dh) @(V) 1.0./(1.0+exp((V+32.1+dh)./5.5))), ...
%   (@(dh) @(V) NaN), ...
%   (@(dh) @(V) NaN), ...
%   (@(dh) @(V) NaN), ...
%   (@(dh) @(V) 1.0./(1.0+exp((V+48.9+dh)./5.18))), ...
% };

% c = @(dm) @(V) (1.0./(1.0+exp((V+27.2+dm)./-8.7)));

% Activation curve shifts of AB (under construction)
% figure('outerposition', [0 0 1800 900]);
% hold on;
% for i = 1:6
  % subplot(2, 4, i);
  % fplot(ac{i}(0), [-100 10], 'Color', 'k', 'LineWidth', 1.5);
  % fplot(@(V) (1.0./(1.0+exp((V+27.2)/-8.7))), [-100 10], 'Color', 'k', 'LineWidth', 1.5);
  % hold on;
  % fplot(ac{i}(mean(distribution_3_params(i+15, :))), [-100 10], 'Color', 'r', 'LineWidth', 1.5);
  % fplot(@(V) (1.0./(1.0+exp((V+27.2+2)/-8.7))), [-100 10], 'Color', 'r', 'LineWidth', 1.5);
  % if (~isnan((inac{i}(0))(0)))
    % fplot(inac{i}(0), [-100 10], 'Color', 'b', 'LineWidth', 1.5);
    % fplot(inac{i}(2), [-100 10], 'Color', 'g', 'LineWidth', 1.5);
  % end
%   xlabel('Voltage (mV)');
%   title(['AB.', conds{i}]);
% end
% figlib.pretty('PlotLineWidth', 0.5,'LineWidth', 0.5);

% Activation curve shifts for PD (under construction)
% figure('outerposition', [0 0 1800 900]);
% hold on;
% for i = 1:7
  % subplot(2, 4, i);
  % fplot(ac{i}(0), [-100 10], 'Color', 'k', 'LineWidth', 1.5);
  % fplot(@(V) (1.0./(1.0+exp((V+27.2)/-8.7))), [-100 10], 'Color', 'k', 'LineWidth', 1.5);
  % hold on;
  % fplot(ac{i}(mean(distribution_3_params(i+21, :))), [-100 10], 'Color', 'r', 'LineWidth', 1.5);
  % fplot(@(V) (1.0./(1.0+exp((V+27.2+2)/-8.7))), [-100 10], 'Color', 'r', 'LineWidth', 1.5);
  % if (~isnan((inac{i}(0))(0)))
    % fplot(inac{i}(0), [-100 10], 'Color', 'b', 'LineWidth', 1.5);
    % fplot(inac{i}(2), [-100 10], 'Color', 'g', 'LineWidth', 1.5);
  % end
  % xlabel('Voltage (mV)');
  % title(['PD.', conds{i}]);
% end
% figlib.pretty('PlotLineWidth', 0.5,'LineWidth', 0.5);