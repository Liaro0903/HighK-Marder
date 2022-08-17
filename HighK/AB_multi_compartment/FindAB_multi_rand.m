
classdef FindAB_multi_rand

properties
  x (1, 1) xolotl
  p (1, 1) xfind
end

methods
  function a = FindAB_multi_rand(exp_category, exp_num, par_or_sim)
    close all;
    a.x = xolotl;
    a.p = xfind;
    a.p.x = a.x;
    setup_name = ['setup_', exp_category, num2str(exp_num)];
    FindAB_multi_rand.(setup_name)(a.x, a.p);
    if par_or_sim == "par"
      a.p.parallelSearch;
    else
      a.p.simulate;
    end
  end
  % A function to stop the parallel search, this function makes your life easier: instead of typing 2 lines you only need to type 1
  function [params, data] = stop_parallel_search(a)
    cancel(a.p.workers);
    [params, data] = a.p.gather;
  end
end

methods(Static)
  function setup_1(x, p)
    x = PD(x, 'ABsn', 'prinz', 1, 10000, 0.12);
    x = PD(x, 'ABaxon', 'prinz', 1, 10000, 0.0628);
    x = setPotential(x, -80, 24, ["ABsn" "ABaxon"]);
    x.ABsn.NaV.destroy();
    x.ABaxon.CaS.destroy();
    x.ABaxon.CaT.destroy();
    x.ABaxon.HCurrent.destroy();
    x.ABaxon.KCa.destroy();

    synapse_type = 'Electrical';
    x.connect('ABsn','ABaxon', synapse_type, 'gmax', 110);
    x.connect('ABaxon','ABsn', synapse_type, 'gmax', 110);

    p.ParameterNames = p.x.find('*gbar');
    p.Upper = [2e3 5000 0.2 16e3 2e3 240 200 0.2 400 5000 0.2];
    p.Lower = zeros(11, 1);
    p.SampleFcn = @p.uniformRandom;
    p.SimFcn = @FindAB_multi_rand.criteria_1;
    p.DiscardFcn = @(data) data == 0.0;
  end
  function setup_high1(x, p)
    FindAB_multi_rand.setup_1(x, p);
    p.SimFcn = @FindAB_multi_rand.criteria_high1;
  end
  function qualifies = criteria_1(x)
    % a lot of the commented out are useful for debugging
    % pause(2);
    x = setPotential(x, -80, 24, ["ABaxon", "ABsn"]);
    results_and_spiketimes = x.integrate;
    ABsn_V = results_and_spiketimes.ABsn.V(50001:100000);
    ABaxon_V = results_and_spiketimes.ABaxon.V(50001:100000);
    metrics_ABsn = xtools.V2metrics(ABsn_V, 'spike_threshold', -40, 'sampling_rate', 1, 'ibi_thresh', 1000); % using 1000 because default 300 won't catch some of the burst (but this is not an issue in single ABcPD model)
    metrics_ABaxon = xtools.V2metrics(ABaxon_V, 'sampling_rate', 1, 'ibi_thresh', 1000);

    % disp([
    %   'n_spikes_ABaxon: ', num2str(metrics_ABaxon.n_spikes_per_burst_mean) ...
    %   ' | ABaxon_ibi_mean: ', num2str(metrics_ABaxon.ibi_mean) ...
    %   ' | ABaxon_ibi_std: ', num2str(metrics_ABaxon.ibi_std) ...
    %   ' | ABsn_fr: ', num2str(metrics_ABsn.firing_rate) ...
    % ]);

    % At baseline saline, if ABsn firing rate at 0.5Hz - 2 Hz and ABaxon fires 3 spikes per burst
    if (metrics_ABaxon.n_spikes_per_burst_mean >= 3 && metrics_ABsn.firing_rate >= 0.5 && metrics_ABsn.firing_rate <= 2)
      % x.myplot2({'hi'}, [ABsn_V, ABaxon_V], {'ABsn', 'ABaxon'});
      x = setPotential(x, -56, 24, ["ABaxon", "ABsn"]);
      results_and_spiketimes = x.integrate;
      % ABsn_V = results_and_spiketimes.ABsn.V(50001:100000);
      ABaxon_V = results_and_spiketimes.ABaxon.V(50001:100000);
      metrics_ABaxon = xtools.V2metrics(ABaxon_V, 'sampling_rate', 1, 'ibi_thresh', 1000);
      % disp(['mean isi: ', num2str(metrics_ABaxon.isi_mean), ' | std isi: ', num2str(metrics_ABaxon.isi_std)]);
      if (metrics_ABaxon.isi_std < 100)
        % x.myplot2({'high'}, [ABsn_V, ABaxon_V], {'ABsn', 'ABaxon'});
        qualifies = 1.0;
      else
        qualifies = 0.0;
      end
    else 
      qualifies = 0.0;
    end
  end
  function qualifies = criteria_high1(x)
    % pause(2);
    x = setPotential(x, -80, 24, ["ABaxon", "ABsn"]);
    results_and_spiketimes = x.integrate;
    ABsn_V = results_and_spiketimes.ABsn.V(50001:100000);
    ABaxon_V = results_and_spiketimes.ABaxon.V(50001:100000);
    metrics_ABsn = xtools.V2metrics(ABsn_V, 'spike_threshold', -40, 'sampling_rate', 1, 'ibi_thresh', 1000);
    metrics_ABaxon = xtools.V2metrics(ABaxon_V, 'sampling_rate', 1, 'ibi_thresh', 1000);

    % disp([
    %   'n_spikes_ABaxon: ', num2str(metrics_ABaxon.n_spikes_per_burst_mean) ...
    %   ' | ABaxon_ibi_mean: ', num2str(metrics_ABaxon.ibi_mean) ...
    %   ' | ABaxon_ibi_std: ', num2str(metrics_ABaxon.ibi_std) ...
    %   ' | ABsn_fr: ', num2str(metrics_ABsn.firing_rate) ...
    % ]);

    if (metrics_ABaxon.n_spikes_per_burst_mean >= 3 && metrics_ABsn.firing_rate >= 0.5 && metrics_ABsn.firing_rate <= 2)
      % x.myplot2({'hi'}, [ABsn_V, ABaxon_V], {'ABsn', 'ABaxon'});
      x = setPotential(x, -56, 24, ["ABaxon", "ABsn"]);
      results_and_spiketimes = x.integrate;
      % ABsn_V = results_and_spiketimes.ABsn.V(50001:100000);
      ABaxon_V = results_and_spiketimes.ABaxon.V(50001:100000);
      metrics_ABaxon = xtools.V2metrics(ABaxon_V, 'sampling_rate', 1, 'ibi_thresh', 1000);
      % disp(['mean isi: ', num2str(metrics_ABaxon.isi_mean), ' | std isi: ', num2str(metrics_ABaxon.isi_std)]);
      
      if (metrics_ABaxon.ibi_mean >= 500 && metrics_ABaxon.ibi_std < 2 && metrics_ABaxon.n_spikes_per_burst_mean >= 3)
        % disp([
        % 'n_spikes_ABaxon: ', num2str(metrics_ABaxon.n_spikes_per_burst_mean) ...
        % ' | ABaxon_ibi_mean: ', num2str(metrics_ABaxon.ibi_mean) ...
        % ' | ABaxon_ibi_std: ', num2str(metrics_ABaxon.ibi_std) ...
        % ]);
        % x.myplot2({'high'}, [ABsn_V, ABaxon_V], {'ABsn', 'ABaxon'});
        qualifies = 1.0;
      else
        qualifies = 0.0;
      end
    else 
      qualifies = 0.0;
    end
  end
end

end