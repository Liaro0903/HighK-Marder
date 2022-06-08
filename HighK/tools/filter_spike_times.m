% For example, I want to get all the spike times after 5 seconds.
% Inspired from binary search, but there might be some edge effect for the first and last item 

function filtered_spike_times = filter_spike_times(spiketimes, time)
  last_index = length(spiketimes);
  if (isempty(spiketimes) || spiketimes(1) > time)
    filtered_spike_times = spiketimes; % just return the original spiketimes
  elseif (spiketimes(last_index) < time) % if nothing is after
    filtered_spike_times = int16.empty; % returns an empty array
  else
    start = 1;
    stop = last_index;
    while (stop - start ~= 1)
      mid = fix((stop - start) / 2) + start;
      if (spiketimes(mid) > time)
        stop = mid;
      else
        start = mid;
      end
    end 
    filtered_spike_times = spiketimes(stop:last_index);
  end
end
