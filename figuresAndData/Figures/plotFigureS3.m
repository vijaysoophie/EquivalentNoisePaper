% This script plots figure 4 (psychometric function for all observers) for 
% the Equivalent noise paper. The script requires Palamedes_1.9.0 toolbox. 
%
% The figure is saved in the folder 
% EquivalentNoisePaper/figuresAndData/Figures as Figure4.pdf.
%
% Aug 14 2021: Vijay Singh wrote this.
% Aug 15 2021: Vijay Singh modified this to change names.
%
%%
clear; close all;
makeDataForFigure4;

%% Plot Figure
hFig = figure();
set(hFig,'units','pixels', 'Position', [100 100 1600 1200]);

for rowSubplot = 1:4
    for colSubplot = 1:6
        subplot(4, 6, (rowSubplot - 1)*6 + colSubplot)
        hold on; box on;
        %% Plot a vertical line indicating the standard
        lStdY = plot([LRFLevels(6) LRFLevels(6)], yLimits,':r','LineWidth', 1);

        covNumber = colSubplot;
        subjectNumber = rowSubplot;
        for iterAcquisition = 1:3
            acquisitionNumber = iterAcquisition;
            indexToplot(iterAcquisition) = (subjectNumber-1)*18 + (covNumber - 1)*3 + acquisitionNumber + 1;       
        end
        
        %% Plot Data 
        
        % Plot proportion comparison
        lData1 = plot(LRFLevels,data(3:end,indexToplot(1))./totalTrial,'r.','MarkerSize',10);
        lData2 = plot(LRFLevels,data(3:end,indexToplot(2))./totalTrial,'gs','MarkerSize',5, 'MarkerFaceColor', 'g');
        lData3 = plot(LRFLevels,data(3:end,indexToplot(3))./totalTrial,'b*','MarkerSize',5);
        
        % Plot Fit Line
        lTh1 = plot(xx, yy(:, indexToplot(1)),'r', 'LineWidth', 1);
        lTh2 = plot(xx, yy(:, indexToplot(2)),'g', 'LineWidth', 1);
        lTh3 = plot(xx, yy(:, indexToplot(3)),'b', 'LineWidth', 1);

        %% Make Figure Pretty
        % Set Limits
        xlim(xLimits);
        ylim(yLimits);
        xticks(LRFLevels);
        hAxis = gca;
        set(hAxis,'FontSize',10);
        hAxis.XTickLabelRotation = 90;

        % Subplot Title
        if (colSubplot == 1)
            switch rowSubplot
                case 1
                    text(0.23, 0.5, 'Observer 2', 'Fontsize', 20);
                case 2
                    text(0.23, 0.5, 'Observer 4', 'Fontsize', 20);
                case 3
                    text(0.23, 0.5, 'Observer 8', 'Fontsize', 20);
                case 4
                    text(0.23, 0.5, 'Observer 17', 'Fontsize', 20);
            end
        end
        
        
        % Subplot x-Label
        if (rowSubplot == 4)
            xlabel('Comparison LRF', 'Fontsize', 15);
        end
        
        % Subplot y-Label
        if (colSubplot == 1)
            ylabel('Proportion Chosen', 'Fontsize', 15);
        end

        % Subplot legend
        legend([lData1 lData2 lData3],{num2str(threshPal(indexToplot(1)),3), ...
            num2str(threshPal(indexToplot(2)),3), num2str(threshPal(indexToplot(3)),3)},...
            'Location','Northwest','FontSize',10);
        
        % Subplot Title
        if (rowSubplot == 1)
            switch colSubplot
                case 1
                    title('\sigma^2 = 0.00', 'Fontsize', 20);
                case 2
                    title('\sigma^2 = 0.01', 'Fontsize', 20);
                case 3
                    title('\sigma^2 = 0.03', 'Fontsize', 20);
                case 4
                    title('\sigma^2 = 0.10', 'Fontsize', 20);
                case 5
                    title('\sigma^2 = 0.30', 'Fontsize', 20);
                case 6
                    title('\sigma^2 = 1.00', 'Fontsize', 20);
            end
        end
        
    end
end


% save2pdf('FigureS3.pdf',gcf,600);