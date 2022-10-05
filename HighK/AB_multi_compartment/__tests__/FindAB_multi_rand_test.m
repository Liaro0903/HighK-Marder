% Sample run on FindAB_multi_rand

clear;
close all;

  a = FindAB_multi_rand('', 1, 'sim') % means running rand_1 experiment using simulate
  % a = FindAB_multi_rand('high', 1, 'par') % means running rand_high_1 experiment using parallel.