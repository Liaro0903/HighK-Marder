clear;
close all;

load('FindABPD_ac_rand_high_1.mat');
paramsT = params.';

load('tsne3.mat');
% load('tsne3_cluster.mat');

% params_high_T = params.';
% Y_high = tsne(params_high_T);

% gscatter(Y_high(:, 1), Y_high(:, 2));

% Y_high2 = tsne(params_high_T);
% figure;
% gscatter(Y_high2(:, 1), Y_high2(:, 2));

% Y_high3 = tsne(params_high_T, 'NumDimensions', 3);
figure;
scatter3(Y_high3(:,1), Y_high3(:,2), Y_high3(:,3));

groups = 4;
params_cluster = cell(groups, 1);

idx = kmeans(Y_high3, groups);
figure;
Y_high3_cluster = cell(groups, 1);
for i = 1:groups
  Y_high3_cluster{i} = Y_high3(idx == i, :);
  scatter3(Y_high3_cluster{i}(:,1), Y_high3_cluster{i}(:,2), Y_high3_cluster{i}(:,3));
  hold on;
  params_cluster{i} = paramsT(idx == i, :);
end

figure;
for i = 1:groups-1
  scatter3(Y_high3_cluster{i}(:,1), Y_high3_cluster{i}(:,2), Y_high3_cluster{i}(:,3));
  hold on;
end


for j = 1:4
  figure;
  for i = 1:11
    subplot(3, 4, i);
    histogram(params_cluster{j}(:, i));
  end
  sgtitle(['Group', num2str(j)]);
end