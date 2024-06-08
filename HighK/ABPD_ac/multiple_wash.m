clear; close all;

model = 1;
hxs = cell(3, 1);
results = cell(3, 1);
target_conds = {'KCa', 'Kd', 'NaV'};
pot = -80;

% for i = 1:length(target_conds)
for i = 1:1
  target_cond_var = [target_conds{i} '.m'];
  hxs{i} = HKX(500*1000, -50, 10);
  hxs{i}.add_pyloric_neuron('ABPD', 'AB', 'prinz-ac', model);
  hxs{i}.x.AB.add('ian/EkSwitcher'); % changes the EK
  hxs{i}.x.AB.add('ian/AlphaSensor');
  hxs{i}.x.AB.(target_conds{i}).add('ian/ACSensor', 'mode', i-1);
  hxs{i}.x.AB.(target_conds{i}).ACSensor.add('ian/IanProbe'); 
  E_L = hxs{i}.setKPot(pot);

  results{i} = hxs{i}.x.integrate;
end
% return
