%% Reset
clear;
close all;

a1 = [1; 2; 3];
a2 = [1; 2; 3];

for i = 1:7
  a1 = setsprod(a1, a2);
end

% should turn out to be a 3^8 long possibility