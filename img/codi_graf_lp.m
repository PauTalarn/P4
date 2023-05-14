
data = load('graf_lp.txt');
x = data(:,1);
y = data(:,2);

sz = 10;
scatter(x, y, sz, 'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[0 .1 .7],...
              'LineWidth',0.5);
grid on
xlabel('coef 2')
ylabel('coef 3')
title('LP')
hold on

hlines=line([0 0], ylim, 'Color', 'k', 'LineWidth', 0.5); 
vlines=line(xlim, [0 0], 'Color', 'k', 'LineWidth', 0.5); 
hold off

uistack(hlines, 'bottom');
uistack(vlines, 'bottom');