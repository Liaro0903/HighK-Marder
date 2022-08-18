% HKX stands for "High K Xolotl object". It is a xolotl wrapper that contains other
% useful information and methods that makes code looks nicer and reusable

classdef HKX

properties
  x (1, 1) xolotl
  conds = {
    'ACurrent', 'CaS', 'CaT', ...
    'HCurrent', 'KCa', 'Kd', ...
    'Leak', 'NaV'
  };
  gbars = cell(3, 1); % each cell houses the prinz gbars described in prinz paper
  leak_E0 = -50; % default base leak equilibrium is -50mV
  pot_dV = 24; % default step is 24mV
end
  
methods
  % Constructor
  % sim_t: the simulation time
  % base_EL: specify the base equilibrium potential for leak
  % pot_dV: specify the steps difference of high K
  function hx = HKX(sim_t, base_EL, pot_dV)
    hx.x = xolotl;
    
    % Read and initialize prinz gbars
    gbars_raw = readmatrix('gbars.csv');
    hx.gbars{1} = gbars_raw(1:5, :);
    hx.gbars{2} = gbars_raw(6:10,:);
    hx.gbars{3} = gbars_raw(11:16,:);

    % Base leak
    hx.leak_E0 = base_EL;

    % Potential difference of each step
    hx.pot_dV = pot_dV; 

    % Set up simulation time, turn off show Ca, and set output type to 2
    hx.x.t_end = sim_t;
    hx.x.pref.show_Ca = 0;
    hx.x.output_type = 2;
  end

  function add_pyloric_neuron(self, type, name, cond_author, model_or_custom_gbars, area)
    % Add compartment
    if ~exist('area', 'var') % if no area supplied
      self.x.add('compartment', name);
    else
      self.x.add('compartment', name, 'A', area);
    end

    % Add ion channels
    for i = 1:length(self.conds)
      if self.conds{i} ~= "Leak"
        self.x.(name).add([cond_author filesep self.conds{i}])
      end
    end
    self.x.(name).add('Leak');

    % Add conductances of each channel 
    if type == "ABPD"
      type_number = 1;
    elseif type == "LP"
      type_number = 2;
    elseif type == "PY"
      type_number = 3;
    end

    for i = 1:length(self.conds)
      if (isscalar(model_or_custom_gbars)) % if they supply a model number instead of a gbar array
        self.x.(name).(self.conds{i}).gbar = self.gbars{type_number}(model_or_custom_gbars, i);
      else
        self.x.(name).(self.conds{i}).gbar = model_or_custom_gbars(i);
      end
    end
    self.x.(name).Leak.E = self.leak_E0;

    % Adding calcium dynamics
    self.x.(name).add('prinz/CalciumMech');    
  end
  
  % pot: your desire K potential. Channels that somewhat depends on K will be updated through the pot_dV specified
  function [leak_E, glut_E] = setKPot(self, pot, compartments)
    if ~exist('compartments', 'var') % if no specified 
      compartments = self.x.find('compartment');
    end
    pot0 = -80; glut_E0 = -70;

    leak_dV = self.pot_dV / 2;
    glut_dV = self.pot_dV * 3 / 4;

    steps = (pot - pot0) / self.pot_dV;
    leak_E = self.leak_E0 + leak_dV * steps;
    glut_E = glut_E0 + glut_dV * steps;

    for i = 1:length(compartments)
      if isprop(self.x.(compartments{i}), 'Kd')
        self.x.(compartments{i}).Kd.E = pot;
      end
      if isprop(self.x.(compartments{i}), 'ACurrent')
        self.x.(compartments{i}).ACurrent.E = pot;
      end
      if isprop(self.x.(compartments{i}), 'KCa')
        self.x.(compartments{i}).KCa.E = pot;
      end
      self.x.(compartments{i}).Leak.E = leak_E;
    end

    synapses = self.x.find('synapse');
    for i = 1:length(synapses)
      comp_and_synapse = strsplit(synapses{i}, '.');
      if contains(comp_and_synapse{2}, 'Chol')
        self.x.(comp_and_synapse{1}).(comp_and_synapse{2}).E = pot;
      end
      if contains(comp_and_synapse{2}, 'Glut')
        self.x.(comp_and_synapse{1}).(comp_and_synapse{2}).E = glut_E;
      end
    end
  end

  % This is called default because the gmax value are what we defined as 
  function connect_default_pyloric(self)
    self.x.connect('AB','PY','prinz/Chol','gmax', 3);
    self.x.connect('AB','LP','prinz/Glut','gmax', 30);
    self.x.connect('AB','PY','prinz/Glut','gmax', 10);
    self.x.connect('LP','PY','prinz/Glut','gmax', 1);
    self.x.connect('PY','LP','prinz/Glut','gmax', 30);
    self.x.connect('LP','AB','prinz/Glut','gmax', 30);
  end

  % Connects AB and PD electrically
  function connect_ABPD(self, ABtoPD, PDtoAB)
    synapse_type = 'Electrical';
    self.x.connect('AB', 'PD', synapse_type, 'gmax', ABtoPD);
    self.x.connect('PD', 'AB', synapse_type, 'gmax', PDtoAB);
  end

  function hx = copyHKX(self)
    hx = HKX(self.x.t_end, self.leak_E0, self.pot_dV);
    hx.x = copy(self.x);
  end

  % Archaic, don't use. Keeping this only for network1 (which itself is wrong)
  function setKPot_without_synapses(self, pot, compartments)
    if ~exist('compartments', 'var') % if no specified 
      compartments = self.x.find('compartment');
    end
    pot0 = -80;

    leak_dV = self.pot_dV / 2;

    steps = (pot - pot0) / self.pot_dV;
    leak_E = self.leak_E0 + leak_dV * steps;

    for i = 1:length(compartments)
      if isprop(self.x.(compartments{i}), 'Kd')
        self.x.(compartments{i}).Kd.E = pot;
      end
      if isprop(self.x.(compartments{i}), 'ACurrent')
        self.x.(compartments{i}).ACurrent.E = pot;
      end
      if isprop(self.x.(compartments{i}), 'KCa')
        self.x.(compartments{i}).KCa.E = pot;
      end
      self.x.(compartments{i}).Leak.E = leak_E;
    end
  end
end

end

