clear; close all;

figure('outerposition',[0 0 1180 1270]);
tiledlayout(6, 4);

X = linspace(-10, 10, 1000);
Y = sin(X);

nexttile([1 4]);
plot(X, Y.^2);

for i = 1:4
  nexttile;
  plot(X,Y);
end

for i = 1:4
  nexttile([2 1]);
  plot(X,Y);
end

for i = 2:3
  nexttile([1 4]);
  plot(X,Y.^i);
end


figlib.pretty('PlotLineWidth', 1, 'LineWidth', 0.5);