% These code shouldn't produce errors and should produce what they are meant to do
% These code are testing whether the plot configuration is doing what it is supposed to do

% Before running, it's better to to comment off the 'close all' in side ABcPD_traces, or
% just run line by line

clear;
close all;

ABcPD_traces_sub('', 3, [1, 2, 3, 4, 2, 1], 156:158);
ABcPD_traces_sub('', 3, [1, 2, 3, 4, 2], 156:158);
ABcPD_traces_sub('', 3, [1, 2, 3, 4], 156:158);
ABcPD_traces_sub('', 3, [1, 2, 3], 156:158);
ABcPD_traces_sub('', 3, [1, 2], 156:158);
ABcPD_traces_sub('', 3, 1, 156:158);
ABcPD_traces_sub('high', 7, [3, 2], 1:10);

ABcPD_traces_tight('', 3, [1, 2, 3, 4, 2, 1], 156:158);
ABcPD_traces_tight('', 3, [1, 2, 3, 4, 2], 156:158);
ABcPD_traces_tight('', 3, [1, 2, 3, 4], 156:158);
ABcPD_traces_tight('', 3, [1, 2, 3], 156:158);
ABcPD_traces_tight('', 3, [1, 2], 156:158);
ABcPD_traces_tight('', 3, 1, 156:158);
ABcPD_traces_tight('high', 7, [3, 2], 1:10);