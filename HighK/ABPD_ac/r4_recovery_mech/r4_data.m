% Generates the data for round 4
clear; close all;

%% Script params to play around
model = 1;
save_data = false;
show_data = true;

%% Global variables
target_conds = {'KCa', 'Kd', 'NaV'};

% Note: Some ac_shift_mag, slope, and offset are not complete yet
ac_shift_mag = [ ...
  3   -7   -2; % 1
  3   -6   -2; % 2
  % 1.4 -3   -2; % 3
  3 -3   -2; % temporarily % 3
  % 4   -7.4 -2.99; % 4
  3   -7.4 -2.99; % temporarily % 4
  5    8.7 -3; % 5
  8  8 0; % 6
  8 0 0; % 7
  3 0 0; % 8
];
ac_shift_slope = [
  -10 -2 -2; % 1
  -2 -2 -2; % 2
  -2 -2 -2; % 3
  -1.5 -2 -2; % 4
  -10 -2 -2; % 5
  -10 -10 0; % 6
  -2 0 0; % 7
  -10 0 0; % 8
];

ac_shift_offset = [
  -48.5 -45 -45; % 1
  -43.5 -45 -45; % 2
  -44.3 -45 -45; % 3
  -41.5 -45 -45; % 4
  -48.5 -45 -45; % 5
  -44 -44 0; % 6
  -45 0 0 ; % 7
  -50 0 0; % 8
];

%% Build model and simulate
switch (model)

case 0

hx0 = HKX(500*1e3, -50, 24);
hx0.add_pyloric_neuron('ABPD', 'PD', 'prinz', model+1);
hx0.setKPot(-80);
hx0.x.PD.add('ian/EkSwitcher');
result0 = hx0.x.integrate;

if save_data
  save('r4_results0.mat', 'result0', 'hx0'); % 0 stands for model 0
end

case {1, 2, 3, 4, 5}

for i = 1:length(target_conds)
  target_cond_var = [target_conds{i} '.m'];
  hxs{i} = HKX(500*1000, -50, 10);
  hxs{i}.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', model);
  hxs{i}.x.PD.add('ian/EkSwitcher'); % changes the EK
  hxs{i}.x.PD.add('ian/AlphaSensor');
  hxs{i}.x.PD.(target_conds{i}).add('ian/ACSensor', 'ac_shift_mag', ac_shift_mag(model, i), 'ac_shift_slope', ac_shift_slope(model, i), 'ac_shift_offset', ac_shift_offset(model, i));
  hxs{i}.x.PD.(target_conds{i}).ACSensor.add('ian/IanProbe'); 
  E_L = hxs{i}.setKPot(-80);

  results{i} = hxs{i}.x.integrate;
end

if save_data
  save(['r4_results' num2str(model) '.mat'], 'results', 'hxs', 'ac_shift_mag', 'model', 'target_conds');
end

case 6
    % modelABCDEF
  modelABCDEF_origin = [
    % model A
    1.076392000000000053e+03, 6.405599999999999739e+00, 1.004800000000000004e+01, 8.038400000000001100e+00, 1.758399999999999963e+01, 1.240927999999999969e+02, 1.130400000000000016e-01, 1.758400000000000241e-01;
    % model B
    1.165567999999999984e+03, 6.656799999999999606e+00, 9.545600000000000307e+00, 5.451039999999999708e+01, 1.632799999999999940e+01, 1.107792000000000030e+02, 6.280000000000000859e-02, 1.067600000000000077e-01;
    % model C
    1.228367999999999938e+03, 7.033600000000000740e+00, 1.105279999999999951e+01, 1.175616000000000128e+02, 1.632799999999999940e+01, 1.112815999999999974e+02, 1.381599999999999773e-01, 1.067600000000000077e-01;
    % model D
    1.203248000000000047e+03, 6.656799999999999606e+00, 1.055039999999999978e+01, 5.953439999999999799e+01, 1.632799999999999940e+01, 1.114072000000000031e+02, 0.000000000000000000e+00, 1.067600000000000077e-01;
    % model E
    1.210784000000000106e+03, 8.163999999999999702e+00, 6.280000000000000249e+00, 1.130400000000000063e+02, 1.256000000000000050e+01, 1.184407999999999959e+02, 1.256000000000000172e-01, 3.140000000000000430e-02;
    % model F
    1.245951999999999998e+03, 7.787200000000000344e+00, 6.782400000000000873e+00, 8.465440000000000964e+01, 1.256000000000000050e+01, 1.139192000000000036e+02, 2.511999999999999997e-02, 0.000000000000000000e+00;
  ];

  modelABCDEF = ones(6, 8);

  reorder = [8, 3, 2, 1, 5, 6, 4, 7];
  for m = 1:6
    for r = 1:length(reorder)
      modelABCDEF(m, reorder(r)) = modelABCDEF_origin(m, r);
    end
  end

  hx = HKX(500*1000, -50, 10);
  hx.add_pyloric_neuron('ABPD', 'PD', 'liu-ac', modelABCDEF(5, :));
  hx.x.PD.add('ian/EkSwitcher'); % changes the EK
  hx.x.PD.add('ian/AlphaSensor');
  for i = 1:2
    target_cond_var = [target_conds{i} '.m'];
    hx.x.PD.(target_conds{i}).add('ian/ACSensor', 'ac_shift_mag', ac_shift_mag(model, i), 'ac_shift_slope', ac_shift_slope(model, i), 'ac_shift_offset', ac_shift_offset(model, i));
    hx.x.PD.(target_conds{i}).ACSensor.add('ian/IanProbe'); 
  end
  hx.x.PD.CaT.gbar = 7.2;
  hx.x.PD.CaS.gbar = 5.6;
  E_L = hx.setKPot(-80);
  result = hx.x.integrate;

  if save_data
    save(['r4_result' num2str(model) '.mat'], 'result', 'hx', 'ac_shift_mag', 'model', 'target_conds');
  end

case 7
  load('FindABPD_ac_rand_2.mat');
  hx = HKX(500*1000, -50, 10);
  hx.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', 2);
  hx.x.set(hx.x.find('*gbar'), params(:, 677));
  hx.x.PD.add('ian/EkSwitcher'); % changes the EK
  hx.x.PD.add('ian/AlphaSensor');
  i = 1;
  target_cond_var = [target_conds{i} '.m'];
  hx.x.PD.(target_conds{i}).add('ian/ACSensor', 'ac_shift_mag', ac_shift_mag(model, i), 'ac_shift_slope', ac_shift_slope(model, i), 'ac_shift_offset', ac_shift_offset(model, i));
  hx.x.PD.(target_conds{i}).ACSensor.add('ian/IanProbe'); 
  E_L = hx.setKPot(-80);
  result = hx.x.integrate;

  if save_data
    save(['r4_result' num2str(model) '.mat'], 'result', 'hx', 'ac_shift_mag', 'model', 'target_conds');
  end

case 8
  load('FindABPD_ac_rand_2.mat');
  hx = HKX(500*1000, -50, 10);
  hx.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', 2);
  hx.x.set(hx.x.find('*gbar'), params(:, 11));
  hx.x.PD.add('ian/EkSwitcher'); % changes the EK
  hx.x.PD.add('ian/AlphaSensor');
  i = 1;
  target_cond_var = [target_conds{i} '.m'];
  hx.x.PD.(target_conds{i}).add('ian/ACSensor', 'ac_shift_mag', ac_shift_mag(model, i), 'ac_shift_slope', ac_shift_slope(model, i), 'ac_shift_offset', ac_shift_offset(model, i));
  hx.x.PD.(target_conds{i}).ACSensor.add('ian/IanProbe'); 
  E_L = hx.setKPot(-80);
  result = hx.x.integrate;

  if save_data
    save(['r4_result' num2str(model) '.mat'], 'result', 'hx', 'ac_shift_mag', 'model', 'target_conds');
  end

end


%% Displaying Data

if show_data

switch(model)
  case 0
    tvec = hx0.x.time;
  case {1, 2, 3, 4, 5} 
    tvec = hxs{1}.x.time;
  case {6, 7, 8, 9}
    tvec = hx.x.time;
end


% Display data
figure('outerposition', [0 0 1800 900], 'PaperUnits','points','PaperSize',[1200 1200]);
if model == 0
  plot(tvec, result0.PD.V);
elseif (model < 6)
  tl = tiledlayout(5, 1);
  for m = 1:length(target_conds)
    nexttile;
    plot(tvec, results{m}.PD.V);
    if (m == 1)
      nexttile;
      plot(tvec, results{m}.PD.AlphaSensor(:, 1), 'LineWidth', 2);
      nexttile;
      plot(tvec, results{m}.PD.(target_conds{1}).ACSensor.IanProbe(:, 1), 'k', 'LineWidth', 2);
      hold on;
      plot(tvec, results{m}.PD.(target_conds{1}).ACSensor.IanProbe(:, 2), 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 2);
    end
  end
else
  tl = tiledlayout(4, 1);
  nexttile;
  plot(tvec, result.PD.V);
  nexttile;
  plot(tvec, result.PD.AlphaSensor(:, 1), 'LineWidth', 2);
  for m = 1:1
    nexttile;
    plot(tvec, result.PD.(target_conds{m}).ACSensor.IanProbe(:, 1), 'k', 'LineWidth', 2);
    hold on;
    plot(tvec, result.PD.(target_conds{m}).ACSensor.IanProbe(:, 2), 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 2);
  end
end

figlib.pretty('PlotLineWidth', 1, 'LineWidth', 0.5);

end