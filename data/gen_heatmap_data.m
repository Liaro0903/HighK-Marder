clear; close all;
% cluster = parcluster;
% parpool('local', cluster.NumWorkers);
% disp(['Will start parfor with ' num2str(cluster.NumWorkers) ' workers']);

%% Script params to play around
load_data = false; % you can load some data and generate others
model = 1;
model_str = ['m' num2str(model)];

resolution = 101; % or 31

%% Global variables
hx = HKX(10000, -50, 24);
hx.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', model);
hx.setKPot(-80);
hx.x.integrate;

target_conds = hx.x.find('*ac_shift_*');
cond_pairs = nchoosek(target_conds, 2);

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

for Ek = -80:24:-56

if Ek == -80
  Ek_str = 'ctrl';
else
  Ek_str = 'high';
end
hx.setKPot(Ek);

disp(['Simulating Ek = ', num2str(Ek), 'mV']);

% for i = 1:length(cond_pairs)
for i = 1:2
% for i = 26:55

  [~, ~, ~, cond_gates] = xsplit(cond_pairs(i, :));
  disp(strcat("Running pair ", num2str(i), "/", num2str(length(cond_pairs)), ": ", cond_gates(1), "-", cond_gates(2)));

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

  end
  t = toc;

  disp(['Finished in ' mat2str(t,3) ' seconds.']);
end

neuron_states.(model_str).(Ek_str) = ns;

save('heatmap_data.mat', 'neuron_states');

end % end EK loop

delete(gcp('nocreate'));