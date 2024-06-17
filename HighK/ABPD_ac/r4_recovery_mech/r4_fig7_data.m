clear; close all;
cluster = parcluster;
parpool('local', cluster.NumWorkers);
disp(['Will start parfor with ' num2str(cluster.NumWorkers) ' workers']);

%% Script params to play around
load_data = false; % you can load some data and generate others
model = 1;
model_str = ['m' num2str(model)];
Ek = -80;
if Ek == -80
  Ek_str = 'ctrl';
else
  Ek_str = 'high';
end
resolution = 101; % or 31

%% Global variables
hx = HKX(10000, -50, 24);
hx.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', model);
hx.setKPot(Ek);
hx.x.integrate;

% target_conds = {'HCurrent', 'KCa', 'Kd', 'NaV'};
target_conds = hx.x.find('*ac_shift_*');
cond_pairs = nchoosek(target_conds, 2);
% X = linspace(-10, 10, 50);
% X = X';
% Y = linspace(-10, 10, 50);
% Y = Y';
% XY = setsprod(X, Y);

% Prepare parameters
dm_var1_space = linspace(-30, 30, resolution);
dm_var2_space = linspace(-30, 30, resolution);
[X, Y] = meshgrid(dm_var1_space, dm_var2_space);
all_params = [X(:), Y(:)]';
if load_data
  load('r4_fig7_data.mat');
  if (~isfield(neuron_states, model_str))
    neuron_states.(model_str) = struct;
  end
  if (~isfield(neuron_states.(model_str), Ek_str))
    neuron_states.(model_str).(Ek_str) = NaN(length(cond_pairs), length(all_params));
  end
  ns = neuron_states.(model_str).(Ek_str);
else
  ns = NaN(length(cond_pairs), length(all_params));
end

% for i = 1:length(cond_pairs)
% for i = 1:25
for i = 26:55
  % burst_period = NaN(length(all_params), 1);
  % n_spikes_per_burst = NaN(length(all_params), 1);
  % ibi_mean = NaN(length(all_params), 1);

  [~, ~, ~, cond_gates] = xsplit(cond_pairs(i, :));
  disp(strcat(cond_gates(1), "-", cond_gates(2)));

  % uncomment to save individual plots
  % dir_title = ['./fig7/' num2str(model) filesep Ek_str filesep cond1 '-' cond2 filesep];
  % if ~exist(dir_title, 'dir')
  %   mkdir(dir_title);
  % end

  tic
  parfor j = 1:length(all_params)
  % for j = 190:210
    hx1 = hx.copyHKX();
    hx1.x.set(cond_pairs(i, :), all_params(:, j));
 
    results_and_spiketimes = hx1.x.integrate;
    PD_V = results_and_spiketimes.PD.V;

    [metrics, states] = classifier_2312(PD_V);
    ns(i, j) = states{1};
 
    % uncomment to save individual plots
    % plot_title = [ ...
    %   model_str ' | ' ...
    %   num2str(Ek) 'mV | ' ...
    %   cond1 ' ' num2str(hx1.x.get(cond_pairs{i, 1}), '%.0f') ' | ' ...
    %   cond2 ' ' num2str(hx1.x.get(cond_pairs{i, 2}), '%.0f') ' | ' ...
    %   states{2}
    % ];
 
    % hx1.x.myplot2({plot_title}, PD_V, {'PD'});
    % % text(9, 40, {states}, 'FontSize', 12);
    % saveas(hx1.x.handles.fig, [dir_title, num2str(plot_title), '.png']); % uncomment to save figures as png
    % close;

    % Old way of getting burst_periods etc
    % transient_cutoff = floor(length(PD_V) / 2);
    % PD_V = PD_V(transient_cutoff:end);

    % metrics_PD = xtools.V2metrics(PD_V, 'sampling_rate', 1);
    % burst_period(j) = metrics_PD.burst_period;
    % n_spikes_per_burst(j) = metrics_PD.n_spikes_per_burst_mean;
    % ibi_mean(j) = metrics_PD.ibi_mean;

    % hx1.x.plot()
    % break;
  end
  t = toc;

  disp([num2str(i) ' Finished in ' mat2str(t,3) ' seconds.']);
end

neuron_states.(model_str).(Ek_str) = ns;

% save('r4_fig7_data_highres.mat', 'neuron_states');
delete(gcp('nocreate'));