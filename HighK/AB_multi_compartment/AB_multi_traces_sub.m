

classdef AB_multi_traces_sub

methods
  function a = AB_multi_traces_sub(exp_category, exp_num, plot_numbers, model_num)
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
    params = AB_multi_traces_sub.(setup_name)(hx);
    hx.x.integrate; % for parallization

    for model = model_num
    % parfor model = model_num
      hx1 = hx.copyHKX();
      hx1.x.set(hx1.x.find('*gbar'), params(:, model));
      hx1.connect_ABPD('ABsn', 'ABaxon', 0, 0);
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
        AB_multi_traces_sub.(fig_func)(hx1, plot_config(length(plot_numbers), :), [plot_index, plot_index+plot_length]);
      end
      sgtitle(f, ['Model ' num2str(model)], 'FontSize', 16);
      figlib.pretty('PlotLineWidth', 1, 'LineWidth', 1);
    end
  end
end

methods(Static)
  function params = setup_1(hx)
    load('FindAB_multi_rand_1.mat');
    hx.add_pyloric_neuron('ABPD', 'ABsn', 'prinz', 1, 0.12);
    hx.add_pyloric_neuron('ABPD', 'ABaxon', 'prinz', 1, 0.0628);
    % Delete the channels that we don't want
    hx.x.ABsn.NaV.destroy();
    hx.x.ABaxon.CaS.destroy();
    hx.x.ABaxon.CaT.destroy();
    hx.x.ABaxon.HCurrent.destroy();
    hx.x.ABaxon.KCa.destroy();
  end
  function params = setup_high1(hx) 
    load('FindAB_multi_rand_high_1.mat');
    AB_multi_traces_sub.setup_1(hx);
  end
  function f1(hx, size, plot_index)
    hx.x.set('ABaxon.ElectricalABsn.gmax', 0);
    hx.x.set('ABsn.ElectricalABaxon.gmax', 0);
    hx.setKPot(-80);

    results_and_spiketimes = hx.x.integrate;
    my_plots.my_plot_3(results_and_spiketimes.AB.V, results_and_spiketimes.PD.V, size, plot_index, 'ABsn, -80mV, uncoupled', 'ABaxon, -80mV, uncoupled');
  end
  function f2(hx, size, plot_index)
    base = 110;
    hx.x.set('ABaxon.ElectricalABsn.gmax', base);
    hx.x.set('ABsn.ElectricalABaxon.gmax', base);
    hx.setKPot(-80);

    results_and_spiketimes = hx.x.integrate;
    my_plots.my_plot_3(results_and_spiketimes.ABsn.V, results_and_spiketimes.ABaxon.V, size, plot_index, 'ABsn, -80mV, coupled', 'ABaxon, -80mV, coupled');
  end
  function f3(hx, size, plot_index)
    base = 110;
    hx.x.set('ABaxon.ElectricalABsn.gmax', base);
    hx.x.set('ABsn.ElectricalABaxon.gmax', base);
    hx.setKPot(-56);

    results_and_spiketimes = hx.x.integrate;
    my_plots.my_plot_3(results_and_spiketimes.AB.V, results_and_spiketimes.PD.V, size, plot_index, 'ABsn, -56mV, coupled', 'ABaxon, -56mV, coupled');
  end
  function f4(hx, size, plot_index)
    base = 110;
    hx.x.set('ABaxon.ElectricalABsn.gmax', base);
    hx.x.set('ABsn.ElectricalABaxon.gmax', base);
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
    my_plots.my_plot_3(results_and_spiketimes.AB.V, results_and_spiketimes.PD.V, size, plot_index, 'CaT: 87.45→30', 'KCa: 68.54→400, Kd: 2146');
  end
end

end