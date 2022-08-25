% As described in the ABcPD_analysis file, there are still bugs/features that needed to be fixed or added, but at least this works for the following situations

clear;
close all;

% I encourage to comment off the "close all" inside ABcPD_analysis for now to help better understand this test

a = ABcPD_analysis(["rand_3", "rand_high_7"]);
b = ABcPD_analysis(["rand_3", "rand_high_7", "rand_ac_1"]);