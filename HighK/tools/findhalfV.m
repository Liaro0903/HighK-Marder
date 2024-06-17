% function serves to 
% cond: The conductance, the actual object for example hx.x.PD.ACurrent

function [halfV, x_inf_f] = findhalfV(cond, x_inf, ac_shift) % maybe add Ca_average back in the future

  % Read function from cpp_child_functions
  fun_name = {cond.cpp_child_functions.fun_name};
  if (length(fun_name) <= 3) % does not have h_inf
    if strcmp(x_inf, "h_inf") % prints error that there is no h_inf
      warning('error', 'custom:nohWarning');
      warning('custom:nohWarning', 'This conductance does not have h_inf');
    end
    [m_inf] = cond.cpp_child_functions.fun_handle;
  else % has h_inf
    [m_inf, h_inf] = cond.cpp_child_functions.fun_handle;
  end

  % Convert to a function that matlab can use
  x_inf = func2str(eval(x_inf)); % convert function to string
  x_inf_f = regexprep(x_inf, '\w+_\w+_\w', num2str(ac_shift)); % replace ac_shift with actual value
  x_inf_f = strrep(x_inf_f, '/', './');

  % check if function requires Ca_average, not used for the moment
  % Ca_occurrences = length(strfind(x_inf_f, "Ca"));
  % if (Ca_occurrences > 1 && nargin < 4)
  %   warning('error', 'custom:needCa');
  %   warning('custom:needCa', 'This conductance requires Ca_average');
  % end
  % if (Ca_occurrences == 1)
  %   Ca_average = 0;
  % else
  %   Ca_average = realmax;
  % end

  x_inf_f = str2func(x_inf_f); % convert string back to function

  % x_inf_f % debug
  % halfV = x_inf_f(-75, 0); % debug

  % use math to find out half potential value
  syms x y;
  x_inf_symbolic = symfun(x_inf_f(x, realmax), [x, y]);
  eqn = x_inf_symbolic == 0.5;
  S = solve(eqn, x);
  halfV = double(S);
end