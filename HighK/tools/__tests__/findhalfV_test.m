% Test file for 
clear; close all;

hx = HKX(10000, -50, 24);
hx.add_pyloric_neuron('ABPD', 'PD1', 'prinz-ac', 1);
hx.setKPot(-80);

hx2 = HKX(10000, -50, 24);
hx2.add_pyloric_neuron('ABPD', 'PD2', 'prinz', 1);
hx2.setKPot(-80);

% test for m_inf
hp_H = findhalfV(hx.x.PD1.HCurrent, 'm_inf', 0);
assert(hp_H == -75, 'Case failed: expected -75');

% test for h_inf
hp_A = findhalfV(hx.x.PD1.ACurrent, 'h_inf', 0);
assert(hp_A == -56.9, 'Case failed: expected -56.9');

% should be -78mV, test for m_inf shift ac
hp_H_shift = findhalfV(hx.x.PD1.HCurrent, 'm_inf', 3);
assert(hp_H_shift == -78, 'Case failed: expected -78');

% should be -52.9mV, test for h_inf shift ac
hp_A_shift = findhalfV(hx.x.PD1.ACurrent, 'h_inf', -4);
assert(hp_A_shift == -52.9, 'Case failed: expected -52.9');

% should be -56.9mV, test for functions without ac_shift
hp_A2 = findhalfV(hx2.x.PD2.ACurrent, 'h_inf', 0);
assert(hp_A2 == -56.9, 'Case failed: expected -56.9');

% should be -56.9mV, no ac_shift stays the same.
hp_A2_shift = findhalfV(hx2.x.PD2.ACurrent, 'h_inf', 3);
assert(hp_A2_shift == -56.9, 'Case failed: expected -56.9');

% test case on under construction
% no_h_test_failed = false;
% try
%   % attempt to trigger the custom error by passing h_inf on conductance without h_inf
%   hp_Kd_no_h = findhalfV(hx.x.PD1.Kd, 'm_inf', 3);
% catch ME
%   ME
%   if strcmp(ME.identifier, 'custom:nohWarning')
%     no_h_test_failed = true;
%   end
% end
% assert(no_h_test_failed == true, 'Test failed: No no-h_inf error thrown');

% testing KCa (requiring Ca_average)

hp_KCa = findhalfV(hx.x.PD1.KCa, 'm_inf', 0);

% hx.x.PD1.Ca_average
