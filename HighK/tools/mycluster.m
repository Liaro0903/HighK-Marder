function neuronstate = mycluster(data)
  if isempty(data)
    neuronstate = 'silent';
  else
    ss = zeros(10, 1);
    max_s = 0;
    max_s_id = 0;
    disFunctions = {'sqEuclidean', 'cityblock' };
    disID = 1; 

    maxk = min(10, length(data));
    % disp(maxk);

    for num_classes = 2:maxk
      cluster = kmeans(data, num_classes, 'distance', disFunctions{disID});
      s = silhouette(data, cluster, disFunctions{disID});
      for i = 1:length(s)
        ss(num_classes) = ss(num_classes) + s(i);
      end
      ss(num_classes) = ss(num_classes) / length(s); % find the average silhouette score
      if ss(num_classes) > max_s
        max_s = ss(num_classes);
        max_s_id = num_classes;
      end
    end
    % disp(max_s_id); 
    % disp(max_s);

    if max_s > 0.85
      neuronstate = 'bursting';
    else
      neuronstate = 'tonic';
    end
  end
end

% %% k-means
% num_classes = 6;
% disFunctions = {'sqEuclidean', 'cityblock' };
% disID = 1;
% ind = kmeans( data, num_classes, 'distance', disFunctions{disID} ) ;

% subsets = [];
% for m = 1 : num_classes
%     subsets{m}.data = [];
% end
% for k = 1 : num_points
%     for m = 1 : num_classes
%         if ind(k) == m
%             subsets{m}.data = [subsets{m}.data; data(k,:)];
%         end
%     end
% end

% figure;
% for k = 1 : length( subsets )
%     ind = mod( k, numColor );
%     if ind == 0, ind = numColor; end
%     plot( subsets{k}.data(:,1), subsets{k}.data(:,2), '.', 'Color', cmap(ind, :) ); 
%     if k == 1
%         hold;
%     end
% end
% title( ['k-means: ', num2str(num_classes), ' clusters'] );