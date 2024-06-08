% Plots one without and one with

clear; close all;

load('r4_results0.mat');
load('r4_results1.mat');
model = 1;
target_conds = {'KCa', 'Kd', 'NaV'};

% Get rid of the first 100 seconds
tvec = hx0.x.time;
tvec = tvec(1:400*1e4);
minus50line = [-50 -50];
result{1} = result0;
result{2} = results{1};
result{1}.PD.V = result0.PD.V(100*1e4+1:end); 
result{2}.PD.V = results{1}.PD.V(100*1e4+1:end);

threesec_timeranges = [50, 52; 116, 118; 330, 332; 353, 355;];
timerange_title = {"Control (i)", "Early High [K^+] (ii)", "Late High [K^+] (iii)", "Early Wash (iv)"};

%% Displaying Data
% figure('outerposition', [0 0 800 1200]);
figure('outerposition', [0 0 800 1200], 'Renderer', 'painters');
tl = tiledlayout(30, 4, 'TileSpacing', 'tight', 'Padding', 'compact');

% Three sec time points
% 1: Without recovery 3 sec plots

for m = 1:2
  % 1: 3 sec plots
  for tp = 1:length(threesec_timeranges)
    nexttile([5 1]);
    trange = threesec_timeranges(tp,1)*1e4:threesec_timeranges(tp,2)*1e4;
    plot(tvec(trange), result{m}.PD.V(trange), 'k');
    hold on;
    plot(threesec_timeranges(tp, :), minus50line, 'r', 'LineWidth', 2);
    % box off;
    axis off;
    if (m == 1)
      title(timerange_title{tp});
    end
    if (m == 1 && tp == 1) % 1 second indication
      plot([51 52], [-80 -80], 'k');
      plot([51 51], [-60 -80], 'k');
    end
    ylim([-80, 60]);
  end

  % 2: Traces
  nexttile([4 4]);
  a = area([98 350], [130 130], -80); % plot area of highK
  a(1).FaceColor = [0.82 0.87 0.64];
  hold on;
  plot(tvec, result{m}.PD.V, 'k');
  plot([0 400], minus50line, 'r', 'LineWidth', 2); % plot minus50line
  set(gca, 'XTick', []);

  for i = 1:length(threesec_timeranges)
    a2 = area(threesec_timeranges(i, :), [60 60], -80);
    a2(1).FaceColor = [157 106 53] ./ 255;
    a2(1).EdgeColor = [157 106 53] ./ 255;
  end
  ylabel('Voltage (mV)');
  ylim([-80 60]);
  set(gca, 'YTick', [-50 0 50]);
  box off;
  % axis off;

  % 3: ISI
  nexttile([6 4]);
  spiketimes = filter_spike_times(result{m}.PD.spiketimes, 100*1e4) - 100*1e4;
  ISI = diff(spiketimes) ./ 10;
  % plot(tvec(spiketimes(2:end)), ISI, '.');
  plot([0 400], [100 100], 'k:', 'LineWidth', 0.25);
  hold on;
  plot(0, 900, 'Color', [0 0 0]);
  plot(0, 10, 'Color', [0 0 0]);
  set(gca, 'YScale', 'log');
  box off;
  if m == 1
    set(gca, 'XTick', []);
  else
    xlabel('Time (s)');
  end
  ylabel('log_{10}(ISI) (ms)');
  xlim([0 400]);
  % ylim([1 1000]);
end

figlib.pretty('PlotLineWidth', 1, 'LineWidth', 0.5);