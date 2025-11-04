clear; close all;

%% Global variables
model = 1;
model_str = ['m' num2str(model)];
cond_pair_idx = 50;
resolution = 101;

hx0 = HKX(20000, -50, 24);
hx0.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', model);

V_half_range = [0, 5, 10];

Iscape_timeranges = [17.3256, 19.3857; 17.6647, 19.6728; 16.9934, 19.3007];

use_painters = false;
if use_painters
  fig = figure('outerposition',[0 0 1200 1200],'PaperUnits','points','PaperSize', [1200 1200], 'renderer', 'Painters');
else
  figure('outerposition',[0 0 1200 1200],'PaperUnits','points','PaperSize',[1200 1200]); hold on
end
tiledlayout(2, 3, 'TileSpacing', 'compact', 'Padding', 'compact');

%% Plot control response
for v = 1:length(V_half_range)
  % Generate data
  hx = hx0.copyHKX();
  hx.setKPot(-80);
  hx.x.set('PD.KCa.ac_shift_m', V_half_range(v));
  res = hx.x.integrate;

  % 1: Plot voltage trace
  nexttile([1 1]);

  timerange = Iscape_timeranges(v, :);
  tcoi = timerange(1)*1e4:timerange(2)*1e4; % time cut off indices
  tvec = hx.x.time;
  tvec = tvec(tcoi);

  plot(tvec, res.PD.V(tcoi) / 100 + 3, 'k'); % voltage trace
  hold on;
  minus50point = -50 / 100 + 3;
  minus0point = 3;
  minus50line = [minus50point minus50point];
  plot(timerange, minus50line, '--r', 'LineWidth', 2); % plot minus50line
  plot([timerange(1) timerange(1)+0.5], [3.5 3.5], 'k'); % plot time indication
  if (v == 1)
    plot([timerange(1) timerange(1)], [minus50point minus0point], 'k'); % plot votage indication
  end

  % 2: Plot currentscape
  if use_painters == false
    hk_plots.hk_currentscape(hx.x, 'I', res.PD, 'timeranges', timerange, 'plot_sum', true);
  end
  for p = -1:2:1 % plot currentscape dotted lines
    for l = p*1.25:p*0.25:p*2
      plot(timerange, [l l], 'k:', 'LineWidth', 0.25);
    end
  end

  axis off;
  hold on;
  title(['ΔV = ' num2str(V_half_range(v)*-1) 'mV'])
  ylim([-2 3.7]);

end

%% Plot high K response
% for v = 1:length(V_half_range)
%   % Generate data
%   hx = hx0.copyHKX();
%   hx.setKPot(-56);
%   hx.x.set('PD.KCa.ac_shift_m', V_half_range(v));
%   res = hx.x.integrate;

%   % 1: Plot voltage trace
%   nexttile([1 1]);

%   timerange = Iscape_timeranges(v, :);
%   tcoi = timerange(1)*1e4:timerange(2)*1e4; % time cut off indices
%   tvec = hx.x.time;
%   tvec = tvec(tcoi);

%   plot(tvec, res.PD.V(tcoi) / 100 + 3, 'k'); % voltage trace
%   hold on;
%   minus50point = -50 / 100 + 3;
%   minus0point = 3;
%   minus50line = [minus50point minus50point];
%   plot(timerange, minus50line, '--r', 'LineWidth', 2); % plot minus50line
%   plot([timerange(1) timerange(1)+0.5], [3.5 3.5], 'k'); % plot time indication
%   if (v == 1)
%     plot([timerange(1) timerange(1)], [minus50point minus0point], 'k'); % plot votage indication
%   end

%   % plot(currentscape_timebars{m}(tr, :), [4.2 4.2], 'k');
%   % if (tr == 1)
%   %   plot([currentscape_timeranges{m}(tr, 1) currentscape_timeranges{m}(tr, 1)], [minus50point minus0point], 'k', 'LineWidth', 1);
%   % end

%   % plot([18 18.5], [-0.8+3 -0.8+3], 'k'); % plot the voltage and time indication
%   % plot([18 18], [-0.6+3 -0.8+3], 'k'); % plot the voltage and time indication

%   % 2: Plot currentscape
%   if use_painters == false
%     hk_plots.hk_currentscape(hx.x, 'I', res.PD, 'timeranges', timerange, 'plot_sum', true);
%   end
%   for p = -1:2:1 % plot currentscape dotted lines
%     for l = p*1.25:p*0.25:p*2
%       plot(timerange, [l l], 'k:', 'LineWidth', 0.25);
%     end
%   end

%   axis off;
%   hold on;
%   title(['ΔV = ' num2str(V_half_range(v)*-1) 'mV'])
%   ylim([-2 3.7]);

% end

%% Plot activation curves
a = nexttile(4, [1 2]);
Vrange = [-55, -5];
ac_shifts = [0, 5, 10];
plot_hp = true;
legend_titles = ["ΔV_{1/2} = 0mV", "ΔV_{1/2} = -5mV", "ΔV_{1/2} = -10mV"];
hk_plots.plot_ac(hx.x.PD.KCa, Vrange, "m_inf", ac_shifts, plot_hp, legend_titles);
axis square
figlib.pretty();
