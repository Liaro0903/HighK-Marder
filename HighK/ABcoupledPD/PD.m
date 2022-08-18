function x = PD(x, name, cond_author, model_or_custom_gbars, sim_t, area)
  % Adding compartment
  x.add('compartment', name, 'A', area);

  % Adding conductances
  conds = {
    'ACurrent', 'CaS', 'CaT', ...
    'HCurrent', 'KCa', 'Kd', ...
    'Leak', 'NaV'
  };

  gbars_raw = readmatrix('gbars.csv');
  gbars = gbars_raw(1:5, :);

  if ~exist ('cond_author', 'var')
    cond_author = 'prinz';
  end

  for i = 1:length(conds) 
    if (conds{i} ~= "Leak")
      x.(name).add([cond_author filesep conds{i}])
    end
  end
  x.(name).add('Leak');

  for i = 1:length(conds)
    if (isscalar(model_or_custom_gbars)) % if they supply a model number instead of a gbar array
      x.(name).(conds{i}).gbar = gbars(model_or_custom_gbars, i);
    else
      x.(name).(conds{i}).gbar = model_or_custom_gbars(i);
    end
  end
 
  % Adding leak E
  x.(name).Leak.E = -50; % mV

  % Adding Calcium Dynamics
  x.(name).add('prinz/CalciumMech');

  x.t_end = sim_t;

  % Some other customization usually I use
  x.pref.show_Ca = 0;
  x.output_type = 2;
end