clear;
close all;

x = xolotl;
x = PD(x, 'PD', 2, 10000, 0.12);

custom_gbars = [
  461.4818186
  52.82030057
  60.50018482
  0.025404106
  119.8088278
  330.31419
  0.023067317
  0
];

x = PD(x, 'AB', custom_gbars, 10000, 0.0628);
x.plot();
