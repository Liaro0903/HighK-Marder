% Reset
clear;
close all;

for model = 2:2

hx = HKX(10000, -50, 10);
hx.add_pyloric_neuron('ABPD', 'AB', 'prinz', model);

for pot = -80:10:-40
  E_L = hx.setKPot(pot);
  title = ['AB' num2str(model), '- E_K=', num2str(pot), ' | E_L=', num2str(E_L)];
  my_plots.my_plot_1(hx.x, title);
end

end