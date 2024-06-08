% Code to check if shifting curves of prinz-ac conductances are working correctly

clear;
close all;

%% Load the necessary data
model = 677;
% load('FindABPD_ac_rand_1.mat');
load('FindABPD_ac_rand_2.mat');

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

% liu models
% liu_gbars_raw = readmatrix('data/liu_gbars.csv');

% liu_reorder = [8 3 2 4 6 5 1 7];
% liu_gbars = ones(1, 8);
% for r = 1:length(liu_reorder)
%   liu_gbars(1, liu_reorder(r)) = liu_gbars_raw(model, r) * 10;
% end

% Model setup and simulation
hx = HKX(10000, -50, 24);

hx.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', 1);
% hx.add_pyloric_neuron('ABPD', 'PD', 'liu-ac', modelABCDEF(5, :));
% hx.add_pyloric_neuron('ABPD', 'PD', 'liu-ac', liu_gbars);
% hx.x.PD.Leak.gbar = 0;
hx.x.set(hx.x.find('*gbar'), params(:, model));
hx.setKPot(-80);

% hx.x.PD.Cm = 10;
% hx.x.PD.NaV.E = 30;
% hx.x.PD.CaT.gbar = 7.2;
% hx.x.PD.CaS.gbar = 5.6;
% hx.x.PD.Kd.ac_shift_m = 7.5;
% hx.x.PD.KCa.ac_shift_m = 9.8;
% hx.x.PD.HCurrent.gbar = 1000;
% hx.x.PD.NaV.gbar = 800;
% hx.x.PD.KCa.ac_shift_m = 7.5;
% hx.x.PD.CaT.ac_shift_m = 2;
% hx.x.PD.HCurrent.ac_shift_m = -50;
% hx.x.PD.HCurrent.gbar = 20;
% hx.x.PD.A = 0.1;
% hx.x.set([hx.x.find('*ac_shift_m'); hx.x.find('*ac_shift_h')], params(:, model));

% hx2 = hx.copyHKX();

% hx.x.currentscape;
hx.x.output_type = 0;
x = hx.x;
% hx.x.manipulate_plot_func = {@x.currentscape};
hx.x.manipulate_plot_func = {@ABPD_ac_debug_highK};
% hx.x.currentscape;
% hx.x.plot;
% hx.x.manipulate;
% hx.x.manipulate('*ac_shift_*');
% hx.x.handles.puppeteer_object.attachFigure(hx.x.handles.currentscape)

% results = hx2.x.integrate;
% figure('outerposition',[0 0 1300 1500]);
% tl = tiledlayout(1, 1, 'padding', 'compact');
% plot(hx2.x.time, results.PD.V);
% [~, sum_currents] = hx2.x.mycurrentscape(results.PD, tl, 1:length(hx2.x.time), true, true);

% figlib.pretty('PlotLineWidth', 1, 'LineWidth', 0.5);