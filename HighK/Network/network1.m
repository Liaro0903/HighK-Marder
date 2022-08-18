%% Reset
clear;
close all;

for AB = 2:2
for LP = 4:4
for PY = 1:1

% Set model array and directory name
select_model = [AB, LP, PY];
dir_title = '';
for i = 1:length(select_model)
  dir_title = strcat(dir_title, int2str(select_model(i)));
end
if ~exist(dir_title, 'dir')
  mkdir(dir_title);
end

hx = HKX(10000, -50, 10);
hx.add_pyloric_neuron('ABPD', 'AB', 'prinz', AB);
hx.add_pyloric_neuron('LP', 'LP', 'prinz', LP);
hx.add_pyloric_neuron('PY', 'PY', 'prinz', PY);
hx.connect_default_pyloric();

for pot = -100:10:-40
  hx.setKPot_without_synapses(pot);
  hx.x.myplot(num2str(pot));
end

end
end
end