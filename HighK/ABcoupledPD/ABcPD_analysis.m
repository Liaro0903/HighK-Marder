clear;
close all;

load('FindABcPD_rand_high_3.mat');

num_models = length(params);
AB_X = repmat((1:7), 1, num_models);
AB_Y = reshape(params(1:7, :), 1, 7 * num_models);
scatter(AB_X, AB_Y);

PY_X = repmat((1:8), 1, num_models);
PY_Y = reshape(params(8:15, :), 1, 8 * num_models);
figure;
scatter(PY_X, PY_Y);