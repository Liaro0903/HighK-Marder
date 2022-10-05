% These code shouldn't produce errors and should produce what they are meant to do
% These code are testing whether the plot configuration is doing what it is supposed to do

% Before running, it's better to to comment off the 'close all' in side AB_multi_traces_sub, or
% just run line by line

clear;
close all;

AB_multi_traces_sub('', 1, [1, 2, 3, 4, 2, 1], 156:158);
AB_multi_traces_sub('', 1, [1, 2, 3, 4, 2], 156:158);
AB_multi_traces_sub('', 1, [1, 2, 3, 4], 156:158);
AB_multi_traces_sub('', 1, [1, 2, 3], 156:158);
AB_multi_traces_sub('', 1, [1, 2], 156:158);
AB_multi_traces_sub('', 1, 1, 6);
AB_multi_traces_sub('high', 1, [3, 2], 1:5);