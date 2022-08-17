function x = setPotential(x, pot, pot_dV, compartments)
  pot0    = -80;
  leak_E0 = -50; leak_dV = pot_dV / 2;

  steps = (pot - pot0) / pot_dV;
  leak_E = leak_E0 + leak_dV * steps;

  for i = 1:length(compartments)
    if isprop(x.(compartments(i)), 'Kd')
      x.(compartments(i)).Kd.E = pot;
    end
    if isprop(x.(compartments(i)), 'ACurrent')
      x.(compartments(i)).ACurrent.E = pot;
    end
    if isprop(x.(compartments(i)), 'KCa')
      x.(compartments(i)).KCa.E = pot;
    end
    x.(compartments(i)).Leak.E = leak_E;
  end
end