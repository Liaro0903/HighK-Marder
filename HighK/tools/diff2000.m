function neuronstate = diff2000(data)
  if isempty(data)
    neuronstate = 'silent';
  else
    % data_diff = zeros(length(data) - 1, 1);
    for i = 2:length(data)
      % data_diff(i-1) = data(i) - data(i-1);
      if (data(i) - data(i-1) > 2000)
        neuronstate = 'bursting';
        return
      end
    end
    neuronstate = 'tonic';
  end
end