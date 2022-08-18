% Network2

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
  [leak_E, glut_E] = hx.setKPot(pot);
  title = [dir_title, '- E_K: ', int2str(pot), '; E_L: ', int2str(leak_E), '; E_{glut}: ', num2str(glut_E), '; E_{chol}: ', int2str(pot)];
  myplot(hx.x, title);
  x2_filename = ['./', dir_title, filesep, dir_title, int2str(pot), int2str(leak_E*-1), num2str(glut_E*-1), '.png'];
  % saveas(hx.x.handles.fig, x2_filename, 'png'); % uncomment to save figure

  % Uncomment this section to generate the currents for each ion channel
end

end
end
end