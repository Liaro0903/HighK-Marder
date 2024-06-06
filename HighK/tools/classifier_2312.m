% A classfier I wrote in 2023.12.29. Can compare to other classifiers that I wrote before.

function [metrics, class] = classifier_2312(V)

metrics = xtools.V2metrics(V((length(V) / 2) : end));

  % Categorizer
  if (isnan(metrics.isi_std))
    class = {0, 'Quiescent'};
  elseif (metrics.isi_std > 10)
    class = {2, 'Bursting'};
  else
    class = {1, 'Tonic Spiking'};
  end
end