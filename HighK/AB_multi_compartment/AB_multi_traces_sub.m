

classdef AB_multi_traces_sub

methods

  % Constructor
  % This prints out the traces of AB_multi experiments using the subplot function.
  % exp_category: the experiment category. For example, "rand" experiments are '', and "rand_high" experiments are 'high'
  % exp_num: the experiment number, enter integers
  % plot_numbers: the plot type you want to plot (ranging from 1-4). See f1-f4 functions below. Could be be a matrix.
  % model_num: the number model you want to print out. Could be a matrix.

  % Sample Run
  % a = AB_multi_traces_sub('', 1, [2, 3], 7) means printing out the traces of model 7 from AB_multi_rand_1, with 2 subplots on coupled at -80mV and coupled at -56mV. 
  % a = AB_multi_traces_sub('high', 1, [2], 34:36) means printing out the traces of model 34 to 35 from AB_multi_rand_high_1, with 1 subplot on coupled at -80mV.
  % see AB_multi_traces_test.m for more examples

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
    my_plots.my_plot_3(results_and_spiketimes.ABsn.V, results_and_spiketimes.ABaxon.V, size, plot_index, 'ABsn, -80mV, uncoupled', 'ABaxon, -80mV, uncoupled');
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
    my_plots.my_plot_3(results_and_spiketimes.ABsn.V, results_and_spiketimes.ABaxon.V, size, plot_index, 'ABsn, -56mV, coupled', 'ABaxon, -56mV, coupled');
  end
  function f4(hx, size, plot_index)
    base = 110;
    hx.x.set('ABaxon.ElectricalABsn.gmax', base);
    hx.x.set('ABsn.ElectricalABaxon.gmax', base);
    hx.setKPot(-56);

    % hx.x.ABsn.ACurrent.gbar = ;
    % hx.x.ABsn.CaS.gbar      = ;
    % hx.x.ABsn.CaT.gbar      = 30;
    % hx.x.ABsn.HCurrent.gbar = ;
    hx.x.ABsn.KCa.gbar      = 300;
    % hx.x.ABsn.Kd.gbar       = 2000;
    % hx.x.ABsn.NaV.gbar      = ;
    % hx.x.ABsn.Leak.gbar     = ;

    % hx.x.ABaxon.ACurrent.gbar = 500;
    % hx.x.ABaxon.CaS.gbar      = 80;
    % hx.x.ABaxon.CaT.gbar      = ;
    % hx.x.ABaxon.HCurrent.gbar =;
    % hx.x.ABaxon.KCa.gbar      = 400;
    % hx.x.ABaxon.Kd.gbar       = 2100;
    % hx.x.ABaxon.NaV.gbar      =;

    results_and_spiketimes = hx.x.integrate;
    my_plots.my_plot_3(results_and_spiketimes.ABsn.V, results_and_spiketimes.ABaxon.V, size, plot_index, 'KCa: 300', 'No Changes');
  end
end

end