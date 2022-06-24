% To use with xtools.findBurstMetrics

function state = detect_burst_state(burst_metrics, spike_times)
  if isempty(spike_times)
    state = 'silent';
  else
    if (burst_metrics(2) == -1) % tonic
      state = 'tonic';
    else
      state = 'bursting';
    end
  end 
end