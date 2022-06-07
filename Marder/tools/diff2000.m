function neuronstate = diff2000(data)
  % data_diff = zeros(length(data) - 1, 1);
  for i = 2:length(data)
    % data_diff(i-1) = data(i) - data(i-1);
    if (data(i) - data(i-1) > 2000)
      neuronstate = true;
      return
    end
  end
  neuronstate = false;
end