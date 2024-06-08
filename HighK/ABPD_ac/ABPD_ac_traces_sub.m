

classdef ABPD_ac_traces_sub
  properties
    hx (1, 1)
  end

  methods
  
    % Constructor
    % This prints out the traces of ABPD_ac experiments using the subplot function.
    % exp_category: the experiment category. For example, "rand" experiments are '', and "rand_high" experiments are 'high'
    % exp_num: the experiment number, enter integers
    % plot_numbers: the plot type you want to plot (ranging from 1-4). See f1-f4 functions below. Could be be a matrix.
    % model_num: the number model you want to print out. Could be a matrix.
  
    % Sample Run
    % a = ABPD_ac_traces_sub('', 1, [2, 3], 7) means printing out the traces of model 7 from AB_multi_rand_1, with 2 subplots on coupled at -80mV and coupled at -56mV. 
    % a = ABPD_ac_traces_sub('high', 1, [2], 34:36) means printing out the traces of model 34 to 35 from AB_multi_rand_high_1, with 1 subplot on coupled at -80mV.
    % see AB_multi_traces_test.m for more examples
  
    function a = ABPD_ac_traces_sub(exp_category, exp_num, plot_numbers, model_num)
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
      params = ABPD_ac_traces_sub.(setup_name)(hx);
      hx.x.integrate; % for parallization
      % f = figure('outerposition',[0 0 1800 1200],'PaperUnits','points','PaperSize',[1200 1200]); % temp

      tic0 = tic;
      for model = model_num
      % parfor model = model_num
        disp(model);
        hx1 = hx.copyHKX();
        % hx1.x.set([hx1.x.find('*ac_shift_m'); hx1.x.find('*ac_shift_h')], params(:, model));
        % hx1.x.set(hx1.x.find('*gbar'), hx.gbars{1}(model, :)); % temp
        hx1.x.set(hx1.x.find('*gbar'), params(:, model)); % temp
        f = figure('outerposition',[0 0 1800 1200],'PaperUnits','points','PaperSize',[1200 1200]);
        % if (model == 139)
        %   plot_range = 1:2;
        % else
        %   plot_range = 3:4;
        % end
        for i = 1:length(plot_numbers)
        % for i = plot_range
          fig_func = ['f' num2str(plot_numbers(i))];
          ABPD_ac_traces_sub.(fig_func)(hx1, [4, 1], i);
        end
        sgtitle(f, ['Model ' num2str(model)], 'FontSize', 16);
        figlib.pretty('PlotLineWidth', 1, 'LineWidth', 1);
        saveas(f, [num2str(model), '.png']); % uncomment to save figures as png        
        close;
        % a.hx = hx1;
      end
      t0 = toc(tic0);
      disp(['Finished in ' mat2str(t0,3) ' seconds.']);
  
      % for model = model_num
      % % parfor model = model_num
      %   hx1 = hx.copyHKX();
      %   hx1.x.set([hx1.x.find('*ac_shift_m'); hx1.x.find('*ac_shift_h')], params(:, model));
      %   f = figure('outerposition',[0 0 1800 1200],'PaperUnits','points','PaperSize',[1200 1200]);
      %   plot_length = plot_config(length(plot_numbers), 2);
        
      %   switch plot_length
      %     case 1
      %       hx1.x.t_end = 10000;
      %     case 2
      %       hx1.x.t_end = 5000;
      %     case 3
      %       hx1.x.t_end = 3000;
      %   end
  
      %   for i = 1:length(plot_numbers)
      %     fig_func = ['f' num2str(plot_numbers(i))];
      %     plot_index = i + plot_length * floor((i-1) / plot_length);
      %     % the reason for plot_index to be like that so it can produce patterns like 1 2 3 7 8 9 (because 4 5 6 is for plotting PD)
      %     ABPD_ac_traces_sub.(fig_func)(hx1, plot_config(length(plot_numbers), :), [plot_index, plot_index+plot_length]);
      %   end
      %   sgtitle(f, ['Model ' num2str(model)], 'FontSize', 16);
      %   figlib.pretty('PlotLineWidth', 1, 'LineWidth', 1);
      %   hx1.x
      % end
    end
  end
  
  methods(Static)
    function params = setup_1(hx)
      load('FindABPD_ac_rand_1.mat');
      hx.add_pyloric_neuron('ABPD', 'ABPD', 'prinz-ac', 1);
      disp(size(params));
    end
    function params = setup_2(hx)
      load('FindABPD_ac_rand_2.mat'); 
      hx.add_pyloric_neuron('ABPD', 'ABPD', 'prinz-ac', 1); % the model number shouldn't matter
    end
    function params = setup_high1(hx) 
      load('FindABPD_ac_rand_high_1.mat');
      ABPD_ac_traces_sub.setup_1(hx);
    end
    % function f1(hx, size, plot_index)
    %   hx.setKPot(-80); 
    %   results_and_spiketimes = hx.x.integrate;
    %   my_plots.my_plot(results_and_spiketimes.ABPD.V, 2plot_index, 'ABsn, -80mV, uncoupled');
    % end
    function f2(hx, size, plot_index)
      hx.setKPot(-80); 
      results_and_spiketimes = hx.x.integrate;
      % if (plot_index == 2)
      %   model_num = 139;
      % else
      %   model_num = 13845;
      % end
      model_num = 2;
      if (plot_index == 1)
        my_plots.my_plot(results_and_spiketimes.ABPD.V, size, plot_index, ['ABPD model ' num2str(model_num) ', E_K = -80mV']);
      else
        my_plots.my_plot(results_and_spiketimes.ABPD.V, size, plot_index, ['ABPD model ' num2str(model_num) ', E_K = -80mV, wash']);
      end
    end
    function f3(hx, size, plot_index)
      % if (plot_index == 1)
      %   model_num = 139;
      % else
      %   model_num = 13845;
      % end
      model_num = 2;
      hx.setKPot(-56); 
      results_and_spiketimes = hx.x.integrate;
      my_plots.my_plot(results_and_spiketimes.ABPD.V, size, plot_index, ['ABPD model ' num2str(model_num) ', E_K = -56mV']);
      hx.x.ABPD.KCa
    end
    function f4(hx, size, plot_index)
      hx.setKPot(-56);

      og_ac_shift_m = hx.x.ABPD.ACurrent.ac_shift_m;

      % hx.x.ABPD.ACurrent.ac_shift_m = ;
      % hx.x.ABPD.CaS.ac_shift_m      = ;
      % hx.x.ABPD.CaT.ac_shift_m      = ;
      % hx.x.ABPD.HCurrent.ac_shift_m = ;
      % hx.x.ABPD.KCa.ac_shift_m      = 8;
      % hx.x.ABPD.Kd.ac_shift_m       = -8;
      % hx.x.ABPD.NaV.ac_shift_m      = -8;
      % hx.x.ABPD.ACurrent.ac_shift_h = ;
      % hx.x.ABPD.CaS.ac_shift_h      = ;
      % hx.x.ABPD.CaT.ac_shift_h      = -10; **
      hx.x.ABPD.NaV.ac_shift_h      = 8;
  
      results_and_spiketimes = hx.x.integrate;
      my_plots.my_plot(results_and_spiketimes.ABPD.V, size, plot_index, ['ABPD, KCa.m half potential shift: ', num2str(og_ac_shift_m), ' mV ', '→ ', num2str(hx.x.ABPD.NaV.ac_shift_m), 'mV']);
    end
    function f5(hx, size, plot_index)
      hx = HKX(5000, -50, 24);
      params = ABPD_ac_traces_sub.setup_high1(hx);
      hx.x.integrate; % for parallization
      hx.x.set([hx.x.find('*ac_shift_m'); hx.x.find('*ac_shift_h')], params(:, 9));
      ABPD_ac_traces_sub.f2(hx, size, plot_index);
    end
    function f6(hx, size, plot_index)
      hx = HKX(5000, -50, 24);
      params = ABPD_ac_traces_sub.setup_high1(hx);
      hx.x.integrate; % for parallization
      hx.x.set([hx.x.find('*ac_shift_m'); hx.x.find('*ac_shift_h')], params(:, 9));
      ABPD_ac_traces_sub.f3(hx, size, plot_index);
    end
    % f7: Used for plotting currentscapes for r4_fig5 finding good models that look "different"
    function f7(hx, size_of_tiledlayout, plot_index)
      hx.x.snapshot('checkpoint');
      % 1: Generate data

      % 1.1: Ctrl voltage trace
      hx.setKPot(-80); 
      results_and_spiketimes_80 = hx.x.integrate;
      V80 = results_and_spiketimes_80.ABPD.V;
      metrics_80 = xtools.V2metrics(V80((length(V80) / 2) : end), 'sampling_rate', 10); % maybe have to divide the sampling_rate by 2?
      if ~isnan(metrics_80.burst_period)
        bp_80 = metrics_80.burst_period;
        endtime_80 = min(6*1e4+bp_80*2.5*10, 10*1e4); % because 2.5 cycle might be over 10 seconds. other notes: *10 because of units.
        trange_80 = 6*1e4:endtime_80;
      else
        trange_80 = 6*1e4:8*1e4;
      end

      % 1.2: Ctrl ac_shift states
      dm_var1_space = linspace(-15, 15, 7);
      dm_var2_space = linspace(-15, 15, 7);
      [X, Y] = meshgrid(dm_var1_space, dm_var2_space);
      all_params = [X(:), Y(:)]';
      ns = NaN(2, length(all_params)); % 2 rows because one is for control another for high K

      tic1 = tic;
      parfor j = 1:length(all_params)
      % for j = 200:210
        hx1 = hx.copyHKX();
        hx1.x.set({'*KCa.ac_shift_m', '*Kd.ac_shift_m'}, all_params(:, j));
    
        results_and_spiketimes = hx1.x.integrate;
        PD_V = results_and_spiketimes.ABPD.V;

        [~, states] = classifier_2312(PD_V);
        ns(1, j) = states{1};
      end
      t1 = toc(tic1);
      disp(['Finished in ' mat2str(t1,3) ' seconds.']);

      % 1.3: high K voltage trace
      hx.x.reset('checkpoint');
      hx.setKPot(-56); 
      results_and_spiketimes_56 = hx.x.integrate;
      V56 = results_and_spiketimes_56.ABPD.V;
      metrics_56 = xtools.V2metrics(V56((length(V56) / 2) : end), 'sampling_rate', 10); % maybe have to divide the sampling_rate by 2?
      if ~isnan(metrics_56.isi_mean)
        bp_56 = metrics_56.isi_mean;
        endtime_56 = min(6*1e4+bp_56*5*10, 10*1e4); % because 2.5 cycle might be over 10 seconds. other notes: *10 because of units.
        trange_56 = 6*1e4:endtime_56;
      else
        trange_56 = 6*1e4:8*1e4;
      end

      % 1.4: high K ac_shift states
      tic2 = tic;
      parfor j = 1:length(all_params)
      % for j = 200:201
        hx1 = hx.copyHKX();
        hx1.x.set({'*KCa.ac_shift_m', '*Kd.ac_shift_m'}, all_params(:, j));
    
        results_and_spiketimes = hx1.x.integrate;
        PD_V = results_and_spiketimes.ABPD.V;

        [~, states] = classifier_2312(PD_V);
        ns(2, j) = states{1};
      end
      t2 = toc(tic2);
      disp(['Finished in ' mat2str(t2,3) ' seconds.']);

      % 2: Plot
      % 2.1: ctrl voltage trace
      tl = tiledlayout(4, 3, 'TileSpacing', 'compact', 'Padding', 'compact');
      nexttile([1 2]);
      plot(hx.x.time, V80, 'Color', 'k', 'LineWidth', 1.5); % just as a test
      ylim([-80, 50]);

      % 2.2: ctrl ac_shift states 
      nexttile([2 1])
      param_idx = 1;

      cond_pairs{1, 1} = '*KCa.ac_shift_m';
      cond_pairs{1, 2} = '*Kd.ac_shift_m';
      cond_pairs{2, 1} = '*KCa.ac_shift_m';
      cond_pairs{2, 2} = '*Kd.ac_shift_m';
      my_plots.heatmap_ac_shifts(param_idx, ns, cond_pairs, dm_var1_space, all_params, '', '');

      % 2.3: high K voltage trace
      nexttile([1 2]);
      plot(hx.x.time, V56, 'Color', 'k', 'LineWidth', 1.5); % just as a test
      ylim([-80, 50]);

      % 2.4: ctrl currentscape
      nexttile([2 1]);
      size(trange_80);
      [~, sum_currents] = hx.x.mycurrentscape(results_and_spiketimes_80.ABPD, tl, trange_80, false, true);
      if ~isnan(metrics_80.burst_period)
        xlim([6, min(6+(bp_80/1000)*2.5, 10)]);
      else
        xlim([6, 8]);
      end


      % 2.5: high K currentscape
      nexttile([2 1]);
      [~, sum_currents] = hx.x.mycurrentscape(results_and_spiketimes_56.ABPD, tl, trange_56, false, true);
      if ~isnan(metrics_56.isi_mean)
        xlim([6, min(6+(bp_56/1000)*5, 10)]);
      else
        xlim([6, 8]);
      end
      

      % 2.6: high k ac_shift states
      nexttile([2 1]);
      param_idx = 2;
      my_plots.heatmap_ac_shifts(param_idx, ns, cond_pairs, dm_var1_space, all_params, '', '');


      
    end
  end
  
  end