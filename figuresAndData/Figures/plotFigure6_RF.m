% This script plots the receptive fields of the model.

addpath('../ModelThreshold/');

hFig = figure;
set(hFig,'units','pixels', 'Position', [1 1 400 300]);

RF = make2DRF(51, 10);
imagesc(RF);
% colormap('autumn');
colorbar;

% axis square;
xticks([]);
yticks([]);
save2pdf('Figure6.pdf',gcf,600);