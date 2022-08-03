% This class is to graph voltage traces at different settings on ABcPD models

classdef ABcPD_traces

methods
  function a = ABcPD_traces(exp_category, exp_num, plot_numbers, model_num)
    close all;
    plot_config = [
      2 1 ;
      2 2 ;
      2 3 ;
      4 2 ;
      4 3 ;
      4 3 ;
    ];
    x = xolotl;
    setup_name = ['setup_', exp_category, num2str(exp_num)];
    params = ABcPD_traces.(setup_name)(x);
    x.integrate; % for parallization

    for model = model_num
    % parfor model = model_num
      x1 = copy(x);
      x1.set(x1.find('*gbar'), params(:, model)); 
      synapse_type = 'Electrical';
      x1.connect('AB','PD', synapse_type, 'gmax', 0);
      x1.connect('PD','AB', synapse_type, 'gmax', 0);
      f = figure('outerposition',[0 0 1800 1200],'PaperUnits','points','PaperSize',[1200 1200]);
      plot_width = plot_config(length(plot_numbers), 1);
      plot_length = plot_config(length(plot_numbers), 2);
      ha = tight_subplot(plot_width, plot_length, [.1 .04], [.07 .05], [.05 .01]);

      switch plot_length      
        case 1
          x1.t_end = 10000;
        case 2
          x1.t_end = 5000;
        case 3
          x1.t_end = 3000;
      end

      for i = 1:length(plot_numbers)
        fig_func = ['f' num2str(plot_numbers(i))];
        plot_index = i + plot_length * floor((i-1) / plot_length);
        ABcPD_traces.(fig_func)(x1, [ha(plot_index), ha(plot_index+plot_length)]);
      end
      sgtitle(f, ['Model ' num2str(model)], 'FontSize', 16);
      figlib.pretty('PlotLineWidth',1,'LineWidth',1);
      % saveas(f, ['./', num2str(model), '.png']);
      % close;
    end
  end
end
methods(Static)
  function params = setup_3(x)
    ABcPD_traces.setup_4(x);
    load('FindABcPD_rand_3.mat');
    x.AB.NaV.destroy();
  end
  function params = setup_4(x)
    load('FindABcPD_rand_4.mat');
    x = PD(x, 'PD', 'prinz', 1, 5000, 0.12);
    x = PD(x, 'AB', 'prinz', 1, 5000, 0.0628);
  end
  function params = setup_high7(x)
    ABcPD_traces.setup_high9(x);
    load('FindABcPD_rand_high_7.mat');
    x.AB.NaV.destroy();
  end
  function params = setup_high9(x)
    load('FindABcPD_rand_high_9.mat');
    x = PD(x, 'PD', 'prinz', 1, 5000, 0.12);
    x = PD(x, 'AB', 'prinz', 1, 5000, 0.0628);
  end
  function f1(x, ha) % Integrate pre-connection
    x.set('AB.ElectricalPD.gmax', 0);
    x.set('PD.ElectricalAB.gmax', 0);
    x = setPotential(x, -80, 24, ["AB" "PD"]);

    results_and_spiketimes = x.integrate;
    my_plots.my_plot_4(results_and_spiketimes.AB.V, results_and_spiketimes.PD.V, ha, '-80mV, uncoupled', '-80mV, uncoupled');
  end

  function f2(x, ha) % Integrate with connection
    base = 110;
    x.set('AB.ElectricalPD.gmax', base);
    x.set('PD.ElectricalAB.gmax', base * 4);
    x = setPotential(x, -80, 24, ["AB" "PD"]);

    results_and_spiketimes = x.integrate;
    my_plots.my_plot_4(results_and_spiketimes.AB.V, results_and_spiketimes.PD.V, ha, '-80mV, coupled', '-80mV, coupled');
  end

  function f3(x, ha) % Integrate at high K
    base = 110;
    x.set('AB.ElectricalPD.gmax', base);
    x.set('PD.ElectricalAB.gmax', base * 4);
    x = setPotential(x, -56, 24, ["AB" "PD"]);

    results_and_spiketimes = x.integrate;
    my_plots.my_plot_4(results_and_spiketimes.AB.V, results_and_spiketimes.PD.V, ha, '-56mV, coupled', '-56mV, coupled');
  end
  
  function f4(x, ha) % Integrate at high K with changes in gbar
    base = 110;
    x.set('AB.ElectricalPD.gmax', base);
    x.set('PD.ElectricalAB.gmax', base * 4);
    x = setPotential(x, -56, 24, ["AB" "PD"]);

    % x1.AB.ACurrent.gbar = ;
    % x1.AB.CaS.gbar      = ;
    x.AB.CaT.gbar      = 30;
    % x1.AB.HCurrent.gbar = ;
    % x1.AB.KCa.gbar      = ;
    % x1.AB.Kd.gbar       = 2000;
    % x1.AB.NaV.gbar      = ;
    % x1.AB.Leak.gbar     = ;

    % x1.PD.ACurrent.gbar = 500;
    % x1.PD.CaS.gbar      = 80;
    % x1.PD.CaT.gbar      = ;
    % x1.PD.HCurrent.gbar =;
    x.PD.KCa.gbar      = 400;
    x.PD.Kd.gbar       = 2100;
    % x1.PD.NaV.gbar      =;

    x.t_end = 3000;
    results_and_spiketimes = x.integrate;
    my_plots.my_plot_4(results_and_spiketimes.AB.V, results_and_spiketimes.PD.V, ha, 'CaT: 87.45→30', 'KCa: 68.54→400, Kd: 2146');
  end

end

end