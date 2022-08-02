clear;
close all;

figure();
tight_subplot(3,2,[.01 .03],[.1 .01],[.01 .01]);
figure();
ha = tight_subplot(3,2,[.1 .03],[.1 .1],[.05 .1]); % The second figure is to let me understand what changed and how to use the parameters
for i = 1:6
  axes(ha(i));
  plot(randn(10,i));
end
set(ha(1:4),'XTickLabel',''); set(ha,'YTickLabel','')