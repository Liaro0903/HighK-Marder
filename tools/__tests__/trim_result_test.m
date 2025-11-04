clear; close all;

model = 1;
dhp_m_mag = 3;
dhp_m_slope = -10;
dhp_m_offset = -48.5;

hx = HKX(500*1000, -50, 10);
hx.add_pyloric_neuron('ABPD', 'PD', 'prinz-ac', model);
hx.x.PD.add('huang/EkSwitcher'); % changes the EK
hx.x.PD.add('huang/AlphaSensor');
hx.x.PD.KCa.add('huang/ACSensor', 'dhp_m_mag', dhp_m_mag, 'dhp_m_slope', dhp_m_slope, 'dhp_m_offset', dhp_m_offset);
E_L = hx.setKPot(-80);

result = hx.x.integrate;
result_trimmed = trim_result(result.PD, length(hx.x.time), 100);

fig = figure('outerposition',[0 0 800 600],'PaperUnits','points','PaperSize', [1200 1200]);
tl = tiledlayout(2, 1, 'TileSpacing', 'tight', 'Padding', 'compact');

tvec = hx.x.time;
tvec = tvec(1:400*1e4); % 400 seconds

nexttile;
plot(hx.x.time, result.PD.V, 'k', 'LineWidth', 1);
title('Full 0 to 500 seconds');
nexttile;
plot(tvec, result_trimmed.V, 'k', 'LineWidth', 1);
title('Trimmed 100 to 500 seconds (remapped to 0 to 400 seconds)');

