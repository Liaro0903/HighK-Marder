% Class the holds all the methods

classdef FindABcPD_rand
  properties
    x (1, 1) xolotl
    p (1, 1) xfind
  end
  methods
    function a = FindABcPD_rand(exp_category, exp_num)
      a.x = xolotl;
      a.p = xfind;
      a.p.x = a.x;
      setup_name = ['setup_', exp_category, num2str(exp_num)];
      FindABcPD_rand.(setup_name)(a.x, a.p);
      % a.p.parallelSearch;
      a.p.simulate;
    end
  end
  methods(Static)
    function setup_3(x, p)
      FindABcPD_rand.setup4(x, p);
      x.AB.NaV.destroy();
      x.snapshot('initial');
      p.ParameterNames = p.x.find('*gbar');
      p.Upper = [2e3 240 200 0.2 400 5000 0.2 2e3 240 200 0.2 400 5000 0.2 16e3];
      p.Lower = zeros(15, 1);
    end
    function setup_4(x, p)
      x = PD(x, 'PD', 'prinz', 1, 10000, 0.12);
      x = PD(x, 'AB', 'prinz', 1, 10000, 0.0628);
      x = setPotential(x, -80, 24, ["AB" "PD"]);
      synapse_type = 'Electrical';
      x.connect('AB','PD', synapse_type, 'gmax', 0);
      x.connect('PD','AB', synapse_type, 'gmax', 0);
      x.snapshot('initial');

      p.ParameterNames = p.x.find('*gbar');
      p.Upper = [2e3 240 200 0.2 400 5000 0.2 16e3 2e3 240 200 0.2 400 5000 0.2 16e3];
      p.Lower = zeros(16, 1);
      p.SampleFcn = @p.uniformRandom;
      p.SimFcn = @FindABcPD_rand.criteria3;
      p.DiscardFcn = @(data) data == 0.0;
    end
    function setup_high7(x, p)
      FindABcPD_rand.setup_high9(x, p);
      x.AB.NaV.destroy();
      p.ParameterNames = p.x.find('*gbar');
      p.Upper = [2e3 240 200 0.2 400 5000 0.2 2e3 240 200 0.2 400 5000 0.2 16e3];
      p.Lower = zeros(15, 1);
    end
    function setup_high9(x, p)
      x = PD(x, 'PD', 'prinz', 1, 10000, 0.12);
      x = PD(x, 'AB', 'prinz', 1, 10000, 0.0628);
      x = setPotential(x, -56, 24, ["AB" "PD"]);
      synapse_type = 'Electrical';
      base = 110;
      x.connect('AB','PD', synapse_type, 'gmax', base * 4);
      x.connect('PD','AB', synapse_type, 'gmax', base);

      p.ParameterNames = p.x.find('*gbar');
      p.Upper = [2e3 240 200 0.2 400 5000 0.2 16e3 2e3 240 200 0.2 400 5000 0.2 16e3];
      p.Lower = zeros(16, 1);
      p.SampleFcn = @p.uniformRandom;
      p.SimFcn = @FindABcPD_rand.criteria_high7;
      p.DiscardFcn = @(data) data == 0.0;
    end
    function setup_ac1(x, p)
      x = PD(x, 'PD', 'prinz-ac', 1, 10000, 0.12);
      x = PD(x, 'AB', 'prinz-ac', 1, 10000, 0.628);
      x.AB.NaV.destroy();
      x = setPotential(x, -56, 24, ["AB" "PD"]);
      synapse_type = 'Electrical';
      base = 110;
      x.connect('AB','PD', synapse_type, 'gmax', base * 4);
      x.connect('PD','AB', synapse_type, 'gmax', base);

      p.ParameterNames = [p.x.find('*gbar'); p.x.find('*ac_shift_m'); p.x.find('*ac_shift_h')];
      p.Upper = [2e3 240 200 0.2 400 5000 0.2 2e3 240 200 0.2 400 5000 0.2 16e3 (10*rand(1, 20) - 5)];
      p.Lower = zeros(1, 35);
      p.SampleFcn = @p.uniformRandom;
      p.SimFcn = @FindABcPD_rand.criteria_high7;
      p.DiscardFcn = @(data) data == 0.0;
    end

    function qualifies = criteria3(x)
      arguments
        x (1, 1) xolotl
      end
      % pause(1);
      x.set('AB.ElectricalPD.gmax', 0);
      x.set('PD.ElectricalAB.gmax', 0);
      [AB_isWave, PD_isTonic, AB_V, PD_V] = meta_criteria(x, "bursting", "tonic");
      metrics_AB = xtools.V2metrics(AB_V(50001:100000), 'spike_threshold', -40, 'sampling_rate', 1);
      metrics_PD = xtools.V2metrics(PD_V(50001:100000), 'sampling_rate', 1);
      % disp([
      %   num2str(AB_isWave), ' | ', num2str(PD_isTonic), ...
      %   ' | ', num2str(metrics_AB.firing_rate), ' | ', num2str(metrics_PD.firing_rate), ...
      %   ' | ', num2str(metrics_PD.n_spikes_per_burst_mean), ' | ', num2str(metrics_PD.isi_std) ...
      % ]);
      % all_ABPD_V = zeros(x.t_end * 10, 2);
      % all_ABPD_V(1:50000, 1) = AB_V(1:50000);
      % all_ABPD_V(1:50000, 2) = PD_V(1:50000);
      if (AB_isWave && ...
        0.5 < metrics_AB.firing_rate && metrics_AB.firing_rate < 1.5 && ...
        3 < metrics_PD.firing_rate && metrics_PD.firing_rate < 20 && ...
        metrics_PD.n_spikes_per_burst_mean <= 1.1 && metrics_PD.isi_std < 200 ...
      ) % restrict isi_std so isi are consistent not having 2 spikes that are close (which is more like a bursts than tonic)
        x.set('AB.ElectricalPD.gmax', 110);
        x.set('PD.ElectricalAB.gmax', 440);
        [AB_isWave, PD_isBursting, AB_V, PD_V] = meta_criteria(x, "bursting", "bursting");
        if (AB_isWave && PD_isBursting)
          % all_ABPD_V(50001:100000, 1) = AB_V(1:50000);
          % all_ABPD_V(50001:100000, 2) = PD_V(1:50000);
          % x.myplot2({[num2str(metrics_PD.firing_rate), ' | ', num2str(metrics_PD.isi_std)]}, all_ABPD_V);
          qualifies = 1.0;
        else
          qualifies = 0.0;
        end
      else
        qualifies = 0.0;
      end
      x.reset('initial');
    end

    function qualifies = criteria_high7(x)
      x.snapshot('initial');
      x = setPotential(x, -56, 24, ["AB" "PD"]);
      results_and_spiketimes = x.integrate;
      AB_V = results_and_spiketimes.AB.V(50001:100000);
      PD_V = results_and_spiketimes.PD.V(50001:100000);
    
      max_n_spikes_per_burst = 0;
      max_n_spikes_per_burst_V = 10;
      for spike_threshold = -40:5:0
        metrics_AB = xtools.V2metrics(AB_V, 'sampling_rate', 1, 'spike_threshold', spike_threshold);
        if max_n_spikes_per_burst < metrics_AB.n_spikes_per_burst_mean
          max_n_spikes_per_burst = metrics_AB.n_spikes_per_burst_mean;
          max_n_spikes_per_burst_V = spike_threshold;
        end
      end
      metrics_AB = xtools.V2metrics(AB_V, 'sampling_rate', 1, 'spike_threshold', max_n_spikes_per_burst_V);
      metrics_PD = xtools.V2metrics(PD_V, 'sampling_rate', 1);
      % disp([
      %   'n_spikes_PD: ', num2str(metrics_PD.n_spikes_per_burst_mean) ...
      %   ' | PD_ibi_mean: ', num2str(metrics_PD.ibi_mean) ...
      %   ' | PD_ibi_std: ', num2str(metrics_PD.ibi_std) ...
      %   ' | n_spikes_AB: ', num2str(metrics_AB.n_spikes_per_burst_mean), ...
      %   ' | ibi_std: ', num2str(metrics_AB.ibi_std) ...
      %   ' | AB_ibi_mean: ', num2str(metrics_AB.ibi_mean) ...
      % ]);
      % all_ABPD_V = zeros(x.t_end * 10, 2);
      % all_ABPD_V(1:50000, 1) = AB_V;
      % all_ABPD_V(1:50000, 2) = PD_V;
      % x.myplot('hi');
      if ( ...
        1 < metrics_PD.n_spikes_per_burst_mean && metrics_PD.ibi_mean > 500 && ...
        metrics_AB.n_spikes_per_burst_mean >= 3 && metrics_AB.ibi_std < 100 ...
      )
        % disp('Found bursts at -56');
        x = setPotential(x, -80, 24, ["AB" "PD"]);
        results_and_spiketimes = x.integrate;
        AB_V = results_and_spiketimes.AB.V(50001:100000);
        PD_V = results_and_spiketimes.PD.V(50001:100000);
    
        max_n_spikes_per_burst = 0;
        max_n_spikes_per_burst_V = 10;
        for spike_threshold = -40:5:0
          metrics_AB = xtools.V2metrics(AB_V, 'sampling_rate', 1, 'spike_threshold', spike_threshold);
          if max_n_spikes_per_burst < metrics_AB.n_spikes_per_burst_mean
            max_n_spikes_per_burst = metrics_AB.n_spikes_per_burst_mean;
            max_n_spikes_per_burst_V = spike_threshold;
          end 
        end
        metrics_AB = xtools.V2metrics(AB_V, 'sampling_rate', 1, 'spike_threshold', max_n_spikes_per_burst_V);
        metrics_PD = xtools.V2metrics(PD_V, 'sampling_rate', 1);
        % disp([
        %   'n_spikes_PD: ', num2str(metrics_PD.n_spikes_per_burst_mean) ...
        %   ' | PD_ibi_mean: ', num2str(metrics_PD.ibi_mean) ...
        %   ' | PD_ibi_std: ', num2str(metrics_PD.ibi_std) ...
        %   ' | n_spikes_AB: ', num2str(metrics_AB.n_spikes_per_burst_mean), ...
        %   ' | ibi_std: ', num2str(metrics_AB.ibi_std) ...
        %   ' | AB_ibi_mean: ', num2str(metrics_AB.ibi_mean) ...
        % ]);
        % x.myplot('hi2');
        if (1 < metrics_AB.n_spikes_per_burst_mean && 500 < metrics_PD.ibi_mean && 1 < metrics_PD.n_spikes_per_burst_mean)
          % disp('Found burst at -80');
          % all_ABPD_V(50001:100000, 1) = AB_V(1:50000);
          % all_ABPD_V(50001:100000, 2) = PD_V(1:50000);
          % x.myplot2({'Criteria high 7 example'}, all_ABPD_V);
          qualifies = 1.0;
        else
          qualifies = 0.0;
        end
      else 
        qualifies = 0.0;
      end
      x.reset('initial');
    end

    % Under construction
    function qualifies = criteria_high8(x)
      % x.snapshot('initial');
      % x = setPotential(x, -56, 24, ["AB" "PD"]);
      % results_and_spiketimes = x.integrate;
      % AB_V = results_and_spiketimes.AB.V(50001:100000);
      % PD_V = results_and_spiketimes.PD.V(50001:100000);

      % max_n_spikes_per_burst = 0;
      % max_n_spikes_per_burst_V = 10;

    end
  end
end