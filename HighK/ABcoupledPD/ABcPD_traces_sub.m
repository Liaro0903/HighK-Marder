

classdef ABcPD_traces_sub

methods
  function a = ABcPD_traces_sub(exp_category, exp_num, plot_numbers, model_num)
    close all;
    plot_config = [
      2 1 ;
      2 2 ;
      2 3 ;
      4 2 ;
      4 3 ;
      4 3 ;
    ];
    hx = HKX(10000, -50, 24); 
    setup_name = ['setup_', exp_category, num2str(exp_num)];
    params = ABcPD_traces_sub.(setup_name)(hx);
    hx.x.integrate; % for parallization

    for model = model_num
    % parfor model = model_num
      hx1 = hx.copyHKX();
      hx1.x.set(hx1.x.find('*gbar'), params(:, model));
      hx1.connect_ABPD('AB', 'PD', 0, 0);
      f = figure('outerposition',[0 0 1800 1200],'PaperUnits','points','PaperSize',[1200 1200]);
      plot_length = plot_config(length(plot_numbers), 2);
      
      switch plot_length
        case 1
          hx1.x.t_end = 10000;
        case 2
          hx1.x.t_end = 5000;
        case 3
          hx1.x.t_end = 3000;
      end

      for i = 1:length(plot_numbers)
        fig_func = ['f' num2str(plot_numbers(i))];
        plot_index = i + plot_length * floor((i-1) / plot_length);
        % the reason for plot_index to be like that so it can produce patterns like 1 2 3 7 8 9 (because 4 5 6 is for plotting PD)
        ABcPD_traces_sub.(fig_func)(hx1, plot_config(length(plot_numbers), :), [plot_index, plot_index+plot_length]);
      end
      sgtitle(f, ['Model ' num2str(model)], 'FontSize', 16);
      figlib.pretty('PlotLineWidth', 1, 'LineWidth', 1);
      % saveas(f, ['./', num2str(model), '.png']); uncomment to save figures as png
      % close;
    end
  end
end

methods(Static)
  function params = setup_3(hx)
    load('FindABcPD_rand_3.mat');
    hx.add_pyloric_neuron('ABPD', 'AB', 'prinz', 1, 0.0628);
    hx.add_pyloric_neuron('ABPD', 'PD', 'prinz', 1, 0.12);
    hx.x.AB.NaV.destroy();
  end
  function params = setup_4(hx)
  end
  function params = setup_high7(hx)
    load('FindABcPD_rand_high_7.mat');
    hx.add_pyloric_neuron('ABPD', 'AB', 'prinz', 1, 0.0628);
    hx.add_pyloric_neuron('ABPD', 'PD', 'prinz', 1, 0.12);
    hx.x.AB.NaV.destroy();
  end
  function params = setup_high9(hx) 
  end
  function f1(hx, size, plot_index)
    hx.x.set('AB.ElectricalPD.gmax', 0);
    hx.x.set('PD.ElectricalAB.gmax', 0);
    hx.setKPot(-80);

    results_and_spiketimes = hx.x.integrate;
    my_plots.my_plot_3(results_and_spiketimes.AB.V, results_and_spiketimes.PD.V, size, plot_index, 'AB, -80mV, uncoupled', 'PD, -80mV, uncoupled');
  end
  function f2(hx, size, plot_index)
    base = 110;
    hx.x.set('AB.ElectricalPD.gmax', base);
    hx.x.set('PD.ElectricalAB.gmax', base * 4);
    hx.setKPot(-80);

    results_and_spiketimes = hx.x.integrate;
    my_plots.my_plot_3(results_and_spiketimes.AB.V, results_and_spiketimes.PD.V, size, plot_index, 'AB, -80mV, coupled', 'PD, -80mV, coupled');
  end
  function f3(hx, size, plot_index)
    base = 110;
    hx.x.set('AB.ElectricalPD.gmax', base);
    hx.x.set('PD.ElectricalAB.gmax', base * 4);
    hx.setKPot(-56);

    results_and_spiketimes = hx.x.integrate;
    my_plots.my_plot_3(results_and_spiketimes.AB.V, results_and_spiketimes.PD.V, size, plot_index, 'AB, -56mV, coupled', 'PD, -56mV, coupled');
  end
  function f4(hx, size, plot_index)
    base = 110;
    hx.x.set('AB.ElectricalPD.gmax', base);
    hx.x.set('PD.ElectricalAB.gmax', base * 4);
    hx.setKPot(-56);

    % x1.AB.ACurrent.gbar = ;
    % x1.AB.CaS.gbar      = ;
    hx.x.AB.CaT.gbar      = 30;
    % x1.AB.HCurrent.gbar = ;
    % x1.AB.KCa.gbar      = ;
    % x1.AB.Kd.gbar       = 2000;
    % x1.AB.NaV.gbar      = ;
    % x1.AB.Leak.gbar     = ;

    % x1.PD.ACurrent.gbar = 500;
    % x1.PD.CaS.gbar      = 80;
    % x1.PD.CaT.gbar      = ;
    % x1.PD.HCurrent.gbar =;
    hx.x.PD.KCa.gbar      = 400;
    hx.x.PD.Kd.gbar       = 2100;
    % x1.PD.NaV.gbar      =;

    results_and_spiketimes = hx.x.integrate;
    my_plots.my_plot_3(results_and_spiketimes.AB.V, results_and_spiketimes.PD.V, size, plot_index, 'AB, CaT: 87.45→30', 'PD, KCa: 68.54→400, Kd: 2146');
  end
end

end