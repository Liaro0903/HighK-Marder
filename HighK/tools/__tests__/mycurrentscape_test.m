%% Mycurrentscape test file

clear;
close all;

model = 1;
hx = HKX(2000, -50, 24);
hx.add_pyloric_neuron('ABPD', 'PD', 'prinz', 1);
hx.setKPot(-80);
hx.x.snapshot('initial');

%% Plot using original currentscape
% hx.x.output_type = 0;
% hx.x.currentscape;
% hx.x.reset('initial');

%% Plot using my modified currentscape
hx.x.output_type = 2;
results_hx = hx.x.integrate;

figure('outerposition',[0 0 1500 1200],'PaperUnits','points','PaperSize',[1200 1200]);

subplot(4, 1, 1);
tvec = 0.0001:hx.x.sim_dt/1000:2;
plot(tvec, results_hx.PD.V);

sp = subplot(4, 1, 2);
hx.x.mycurrentscape(results_hx.PD, sp);

I = results_hx.PD;

if isstruct(I)
	conds = hx.x.(hx.x.Children{1}).find('conductance');
	tempI = ones(length(I.V), length(conds));
	for i = 1:length(conds)
		% tempI(:, i) = I.(conds{i}).I(100*1e4+1:end); % temporary
		tempI(:, i) = I.(conds{i}).I; % temporary
	end
	I = tempI;
end

time = hx.x.time;

I_out = I;
I_in = I;

I_out(I<0) = 0;
I_in(I>0) = 0;

sum_currents = [sum(I_in, 2), sum(I_out, 2)];

timeranges = 1:length(time);
log_sum_currents_old = [-log10(-sum_currents(timeranges, 1)), log10(sum_currents(timeranges, 2))];
log_sum_currents = [-log10(-sum_currents(timeranges, 1)+1), log10(sum_currents(timeranges, 2)+1)];

subplot(4, 1, 3);
a = area(time(timeranges), log_sum_currents_old(:, 1));

subplot(4, 1, 4);
a = area(time(timeranges), log_sum_currents(:, 1));

% debug
% size(sum_currents)
% size(timeranges)
% timeranges(1)
% timeranges(end)
% sum_currents(timeranges(1))
% sum_currents(timeranges(end))
% size(sum_currents(timeranges, 1))

% I_out = I_out./sum(I_out,2);
% I_in = I_in./sum(I_in,2);

% norm_currents = [I_in, I_out];

%% Both currentscape should have the same results