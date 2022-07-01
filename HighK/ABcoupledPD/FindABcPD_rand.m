clear;
close all;

x = xolotl;

% AB and PD
x.add('compartment', 'AB', 'A', 0.0628);
x.add('compartment', 'PD', 'A', 0.12);

% Adding conductances
conds = {
  'prinz/NaV', 'prinz/CaT', 'prinz/CaS', ...
  'prinz/ACurrent', 'prinz/KCa', 'prinz/Kd', ...
  'prinz/HCurrent', 'Leak'
};

gbars_raw = readmatrix('gbars.csv');
gbars = gbars_raw(1:5, :);

for i = 1:length(conds)
  if (string(conds{i}) ~= "prinz/NaV")
    x.AB.add(conds{i});
  end
  x.PD.add(conds{i});
end

% Adding leak E
x.AB.Leak.E = -50; % mV
x.PD.Leak.E = -50; % mV

% Adding Calcium Dynamics
x.AB.add('prinz/CalciumMech');
x.PD.add('prinz/CalciumMech');

% Debug
x.pref.show_Ca = 0;
% x.plot();
% x.output_type = 2;
% results_and_spiketimes = x.integrate;
% a = PD_criteria(x);

p = xfind;
p.x = x;

p.ParameterNames = p.x.find('*gbar');
% p.Upper = [1e3 120 100 0.2 200 2500 0.2];
% p.Upper = [1e3 120 100 0.2 200 2500 0.2 8e3];
p.Upper = [1e3 120 100 0.2 200 2500 0.2 1e3 120 100 0.2 200 2500 0.2 8e3];
% p.Lower = zeros(7, 1);
% p.Lower = zeros(8, 1);
p.Lower = zeros(15, 1);

p.SampleFcn = @p.uniformRandom;

% p.SimFcn = @AB_criteria;
% p.SimFcn = @PD_criteria;
p.SimFcn = @ABcPD_criteria;

p.DiscardFcn = @(data) data == 0.0;

p.parallelSearch;
% p.simulate;

% cancel(p.workers)
% [params, data] = p.gather;