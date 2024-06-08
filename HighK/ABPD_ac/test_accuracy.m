clear; close all;

load('test_criteria.mat');

s = struct([]);

for model = 76:100
  hx = HKX(10000, -50, 24);
  hx.add_pyloric_neuron('ABPD', 'ABPD', 'prinz-ac', 2);
  hx.x.set([hx.x.find('*ac_shift_m'); hx.x.find('*ac_shift_h')], params(:, model));

  s = FindABPD_ac_rand.criteria_high1(hx.x, model, s);

end
