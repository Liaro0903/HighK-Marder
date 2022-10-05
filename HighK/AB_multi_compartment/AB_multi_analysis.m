% This plots the distributions for each channel for each neuron for distribution comparison

clear;
close all;

load('FindAB_multi_rand_1.mat');
distribution_1_params = params;

load('FindAB_multi_rand_high_1.mat');
distribution_2_params = params;

conds_sn = {'ACurrent', 'CaS', 'CaT', 'HCurrent', 'KCa', 'Kd', 'Leak'};
conds_axon = {'ACurrent', 'Kd', 'Leak', 'NaV'};

params = cell(2, 1);
params{1} = distribution_1_params(1:4, :);
params{2} = distribution_2_params(1:4, :);

% Prints out the overlaps of distribution 1 and distribution 2 of AB_axon
my_plots.my_histogram_plots(params, conds_axon, 'max conductances (μS)', {'Distribution 1', 'Distribution 2'}, 'Histogram of gbar ABaxon Distribution 1 vs Distribution 2');

params = cell(2, 1);
params{1} = distribution_1_params(5:11, :);
params{2} = distribution_2_params(5:11, :);

% Prints out the overlaps of distribution 1 and distribution 2 of AB_sn
my_plots.my_histogram_plots(params, conds_sn, 'max conductances (μS)', {'Distribution 1', 'Distribution 2'}, 'Histogram of gbar ABsn Distribution 1 vs Distribution 2');