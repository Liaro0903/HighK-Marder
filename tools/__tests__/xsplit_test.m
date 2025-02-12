clear; close all;

hx = HKX(10000, -50, 24);
hx.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', 1);

target_conds = hx.x.find('*ac_shift_*');
cond_pairs = nchoosek(target_conds, 2);

disp(cond_pairs(3, :)); % output PD.ACurrent.ac_shift_h, PD.CaS.ac_shift_m
[neuron_name, conds, gates, cond_gates, gate_conds] = xsplit(cond_pairs(3, :));

assert(neuron_name == 'PD', 'Case failed: expected PD');
assert(isequal(conds, ["ACurrent", "CaS"]), 'Case failed: expected ["ACurrent, "CaS"]');
assert(isequal(gates, ["h", "m"]), 'Case failed: expected ["h", "m"]');
assert(isequal(cond_gates, ["A.h", "CaS.m"]), 'Case failed: expected ["A.h", "CaS.m"]');
assert(isequal(gate_conds, ["h_{A}", "m_{CaS}"]), 'Case failed: expected ["h_{A}", "m_{CaS}"]');