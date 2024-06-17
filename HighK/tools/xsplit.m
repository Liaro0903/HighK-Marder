function [neuron_name, conds, gates, cond_gates] = xsplit(xconds)
  conds = strings(1, length(xconds));
  gates = strings(1, length(xconds));
  cond_gates = strings(1, length(xconds));
  for i = 1:length(xconds)
    cond_str = string(xconds(i));
    cond_str = strsplit(cond_str, ".");
    neuron_name = cond_str(1);
    conds(i) = cond_str(2);
    gates(i) = strrep(cond_str(3), 'ac_shift_', '');
    cond_gates(i) = strcat(strrep(conds(i), 'Current', ''), '.', gates(i));
  end
end