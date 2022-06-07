%% Purpose: Basically trying to copy bursting figures to another folder

%% Reset
clear;
close all;

burstings = readmatrix('../dk3_all_bursting.csv');
burstings_string = strings(length(burstings), 1);

for i = 1:length(burstings)
  for j = 1:length(burstings(i,:))
    burstings_string(i) = strcat(burstings_string(i), int2str(burstings(i,j))) ;
  end
end

for i = 1:length(burstings_string)
  if isfile(strcat('../221/221-', burstings_string(i), '.png'))
    s = strcat('../221/221-', burstings_string(i), '.png');
    d = strcat('../221/all_burstings');
    disp('yes');
    copyfile(s, d);
  else
    disp('no');
  end
end