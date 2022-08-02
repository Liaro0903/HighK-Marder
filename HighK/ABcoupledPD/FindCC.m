% Script to do a grid search on coupling coefficients of different gbars of electrical synapses between AB and PD
% Requires tight_subplot to run

clear;
close all;

x = xolotl;
x = PD(x, 'PD', 'prinz', 1, 6000, 0.12);
x = PD(x, 'AB', 'prinz', 1, 6000, 0.0628);

% x.AB.ACurrent.gbar = 0;
% x.AB.CaS.gbar      = 0;
% x.AB.CaT.gbar      = 0;
% x.AB.HCurrent.gbar = 0;
% x.AB.KCa.gbar      = 0;
% x.AB.Kd.gbar       = 0;
x.AB.Leak.gbar     = .1;
x.AB.NaV.gbar      = 0;

% x.PD.ACurrent.gbar = 0;
% x.PD.CaS.gbar      = 0;
% x.PD.CaT.gbar      = 0;
% x.PD.HCurrent.gbar = 0;
% x.PD.KCa.gbar      = 0;
% x.PD.Kd.gbar       = 0;
x.PD.Leak.gbar     = .1;
x.PD.NaV.gbar      = 0;

CCs_ABPD = zeros(10000, 1);
CCs_PDAB = zeros(10000, 1);

models = setsprod((1:100).', (1:100).');
% the reason that we are doing it this way instead of double for loops is because of parallization, or else this thing could take 12 hours to run
tic
for model = 1106:1106 % debug
% parfor model = 1:length(models) % full version
  disp(['ABPD: ', num2str(models(model, 1)), ' | PDAB: ', num2str(models(model, 2))]);
  x1 = copy(x);

  synapse_type = 'Electrical';
  x1.connect('AB','PD', synapse_type, 'gmax', models(model, 1));
  x1.connect('PD','AB', synapse_type, 'gmax', models(model, 2));

  i_V = zeros(11, 5);
  f1 = figure('outerposition',[0 0 1800 900],'PaperUnits','points','PaperSize',[1800 900]);
  ha1 = tight_subplot(1, 2, [.01 .04], [.1 .1], [.04 .01]);
  f2 = figure('outerposition',[0 0 1800 900],'PaperUnits','points','PaperSize',[1800 900]);
  ha2 = tight_subplot(1, 2, [.01 .04], [.1 .1], [.04 .01]);

  for step = 1:11
    i0 = -4;
    di = 0.25;
    i = i0 + di * (step-1); 

    % AB onto PD
    x1.snapshot('ABontoPD');
    x1.I_ext = [i 0];
    results_and_spiketimes = x1.integrate();
    Pre_V_inf = results_and_spiketimes.AB.V(length(results_and_spiketimes.AB.V));
    Post_V_inf = results_and_spiketimes.PD.V(length(results_and_spiketimes.PD.V));
    
    i_V(step, 1) = i;
    % Not perfect cause I think PD might spike around -40mV
    % if xtools.findNSpikes(results_and_spiketimes.PD.V(50001:10000), 0) == 0
      i_V(step, 2) = Pre_V_inf;
      i_V(step, 3) = Post_V_inf;
    % else
    %   disp('in here');
    % end
    % disp([num2str(i), ' ', num2str(CC)]);

    x1.reset('ABontoPD');

    % Uncomment to plot voltage traces for each current for AB-PD
    figure(1);
    tvec = 0.00001:0.1/1000:6;
    axes(ha1(1));
    plot(tvec, results_and_spiketimes.AB.V, 'LineWidth', 2);
    if step == 1
      ylim([min(results_and_spiketimes.AB.V) -60]);
    end
    title('Pre (AB)');
    hold on;
    axes(ha1(2));
    plot(tvec, results_and_spiketimes.PD.V, 'LineWidth', 2);
    if step == 1
      ylim([min(results_and_spiketimes.AB.V) -60]);
    end
    title('Post (PD)');
    hold on;
    % legend({'1', '2', '3'}, 'location', 'southeast');

    % PD onto AB
    x1.snapshot('PDontoAB');
    x1.I_ext = [0 i];
    results_and_spiketimes = x1.integrate();
    Pre_V_inf = results_and_spiketimes.PD.V(length(results_and_spiketimes.PD.V));
    Post_V_inf = results_and_spiketimes.AB.V(length(results_and_spiketimes.AB.V));
    % if xtools.findNSpikes(results_and_spiketimes.AB.V(50001:10000), -40) == 0
      i_V(step, 4) = Pre_V_inf;
      i_V(step, 5) = Post_V_inf;
    % else
      % disp('in here');
    % end

    x1.reset('PDontoAB');

    % Uncomment to plot voltage traces for each current for PD-AB
    figure(2);
    tvec = 0.00001:0.1/1000:6;
    axes(ha2(1));
    plot(tvec, results_and_spiketimes.PD.V, 'LineWidth', 2);
    if step == 1
      ylim([min(results_and_spiketimes.PD.V) -60]);
    end
    title('Pre (PD)');
    hold on;
    axes(ha2(2));
    plot(tvec, results_and_spiketimes.AB.V, 'LineWidth', 2);
    if step == 1
      ylim([min(results_and_spiketimes.PD.V) -60]);
    end
    title('Post (AB)');
    hold on;

  end
  figure(1);
  figlib.pretty('PlotLineWidth',1,'LineWidth',1);
  figure(2);
  figlib.pretty('PlotLineWidth',1,'LineWidth',1);

  f3 = figure('outerposition',[0 0 700 700],'PaperUnits','points','PaperSize',[700 700]);
  scatter(i_V(:,2), i_V(:,3));
  Fit_ABPD = polyfit(i_V(:, 2), i_V(:, 3), 1); % x = x data, y = y data, 1 = order of the polynomial i.e a straight line 
  hold on;
  scatter(i_V(:,4), i_V(:,5));
  Fit_PDAB = polyfit(i_V(:, 4), i_V(:, 5), 1); % x = x data, y = y data, 1 = order of the polynomial i.e a straight line 

  z = linspace(min(i_V(1, 2), i_V(1, 4)), max(i_V(11, 2), i_V(11, 4)));
  y1 = Fit_ABPD(1) * z + Fit_ABPD(2);
  y2 = Fit_PDAB(1) * z + Fit_PDAB(2);
  plot(z, y1, 'b');
  plot(z, y2, 'r');

  text([i_V(5, 2), i_V(5, 4)], [i_V(5, 3), i_V(5, 5)], {num2str(Fit_ABPD(1)), num2str(Fit_PDAB(1))});

  xlabel('Vpre (mV)');
  ylabel('Vpost (mV)');
  legend('ABPD', 'PDAB', 'location', 'southeast');
  title(['ABPD: ', num2str(models(model, 1)), ' | PDAB: ', num2str(models(model, 2)), ' | CC_{ABPD}: ', num2str(Fit_ABPD(1)), ' | CC_{PDAB}: ', num2str(Fit_PDAB(1))]);

  % Save to array
  CCs_ABPD(model) = Fit_ABPD(1);
  CCs_PDAB(model) = Fit_PDAB(1);

  % if (0.3 <= Fit_ABPD(1) && Fit_ABPD(1) <= 0.35 && 0.18 <= Fit_PDAB(1) && Fit_PDAB(1) <= 0.22)
  %   CCs_filtered{1}(models(model, 1), models(model, 2)) = Fit_ABPD(1);
  %   CCs_filtered{2}(models(model, 1), models(model, 2)) = Fit_PDAB(1);
  % end

  figlib.pretty('PlotLineWidth',0.5,'LineWidth',0.5);

  % close all;
  % close 1; % uncomment if running in loop, maybe will figure out a better way
  % close 2; % uncomment if running in loop, maybe will figure out a better way
end
t = toc;

CCs = cell(2, 1);
CCs{1} = reshape(CCs_ABPD, 100, 100);
CCs{2} = reshape(CCs_PDAB, 100, 100);