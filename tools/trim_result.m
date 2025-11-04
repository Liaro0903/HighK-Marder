function result_trimmed = trim_result(result, origin_len, new_t)

  fields = fieldnames(result);

  for i = 1:numel(fields)
    field = fields{i};

    if isstruct(result.(field))
      result_trimmed.(field) = trim_result(result.(field), origin_len, new_t);
    else
      if length(result.(field)) == origin_len
        % trim
        result_trimmed.(field) = result.(field)(new_t*1e4+1:end, :);
      else
        result_trimmed.(field) = result.(field);
      end
    end 
  end
end