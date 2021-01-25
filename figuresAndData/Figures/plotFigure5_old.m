% This script plots figure 5 log threshold squared vs log sigma squared
%
clear; close all;
%% Load .csv file
dataFile = importfileForFigure4('../ObserverData/subjectThreshold.csv');
data = table2array(dataFile);

%% Subject covariance scales and thresholds
covScale = [eps data(3:end,1)']';
covScaleForMarkers = [0.00001 data(3:end,1)']';

ThresholdSubject2 = data(2:end, 2:4)';
ThresholdSubject4 = data(2:end, 5:7)';
ThresholdSubject8 = data(2:end, 8:10)';
ThresholdSubject17 = data(2:end, 11:13)';

ThresholdMeanSubject = [ThresholdSubject2; ThresholdSubject4; ThresholdSubject8; ThresholdSubject17];

%% Model covariance scales and thresholds
covScaleModel = [eps 0.0003 0.001 0.003 0.01 0.03 0.1 0.3 1]';
covScaleModelForMarkers = [0.0001 0.0003 0.001 0.003 0.01 0.03 0.1 0.3 1]';
ModelThresholds = [ 0.0232    0.0236    0.0234    0.0232    0.0234    0.0244    0.0284    0.0325    0.0390];

%% Plot thresholds
hFig2 = figure(); % This starts a new plotting window
set(hFig2,'units','normalized', 'Position', [0.1 0.1 0.8 0.25]);


%% Plot Figure for Subject 2
s1 = subplot(1,4,1);
hold on; box on;

% Threshold for computational observer
hold on; box on;
lFitLabel{3} = 'Computational Observer';
lFitLabel{4} = plotFigure(s1, covScaleModel, covScaleModelForMarkers, repmat(ModelThresholds,3,1), '--b', 'db');

% Threshold for mean subject
hold on; box on;
lFitLabel{1} = 'Subject 2';
lFitLabel{2} = plotFigure(s1, covScale, covScaleForMarkers, ThresholdSubject2, '-k', 'ok');

%
text(0,1.1,[{'Trendline: $\log_{10}(T^2) = \min\{\log_{10}(T^2_0), \log_{10}(T^2_0) + \alpha [\log_{10}(\sigma^2) - \log_{10}(\sigma^2_0)]\}$'}],...
    'interpreter','latex', 'fontsize',20)
legend(lFitLabel,'interpreter','latex','location','northwest');

logXScaleForPlotting = [-5; log10(covScaleModelForMarkers)];
xticks(logXScaleForPlotting);
xticklabels({'-Inf' '-4.00'   '-3.52'  '-3.00'   '-2.52'   '-2.00'   '-1.52'   '-1.00'   '-0.52'         '0.00'});
xtickangle(90);

%% Plot Figure for Subject 4
s2 = subplot(1,4,2);
hold on; box on;

% Threshold for computational observer
hold on; box on;
lFitLabel{3} = 'Computational Observer';
lFitLabel{4} = plotFigure(s2, covScaleModel, covScaleModelForMarkers, repmat(ModelThresholds,3,1), '--b', 'db');

% Threshold for mean subject
hold on; box on;
lFitLabel{1} = 'Subject 4';
lFitLabel{2} = plotFigure(s2, covScale, covScaleForMarkers, ThresholdSubject4, '-k', 'ok');

%
text(0,1.1,[{'Trendline: $\log_{10}(T^2) = \min\{\log_{10}(T^2_0), \log_{10}(T^2_0) + \alpha [\log_{10}(\sigma^2) - \log_{10}(\sigma^2_0)]\}$'}],...
    'interpreter','latex', 'fontsize',20)
legend(lFitLabel,'interpreter','latex','location','northwest');

logXScaleForPlotting = [-5; log10(covScaleModelForMarkers)];
xticks(logXScaleForPlotting);
xticklabels({'-Inf' '-4.00'   '-3.52'  '-3.00'   '-2.52'   '-2.00'   '-1.52'   '-1.00'   '-0.52'         '0.00'});
xtickangle(90);

%% Plot Figure for Subject 8
s3 = subplot(1,4,3);
hold on; box on;

% Threshold for computational observer
hold on; box on;
lFitLabel{3} = 'Computational Observer';
lFitLabel{4} = plotFigure(s3, covScaleModel, covScaleModelForMarkers, repmat(ModelThresholds,3,1), '--b', 'db');

% Threshold for mean subject
hold on; box on;
lFitLabel{1} = 'Subject 8';
lFitLabel{2} = plotFigure(s3, covScale, covScaleForMarkers, ThresholdSubject8, '-k', 'ok');

%
text(0,1.1,[{'Trendline: $\log_{10}(T^2) = \min\{\log_{10}(T^2_0), \log_{10}(T^2_0) + \alpha [\log_{10}(\sigma^2) - \log_{10}(\sigma^2_0)]\}$'}],...
    'interpreter','latex', 'fontsize',20)
legend(lFitLabel,'interpreter','latex','location','northwest');

logXScaleForPlotting = [-5; log10(covScaleModelForMarkers)];
xticks(logXScaleForPlotting);
xticklabels({'-Inf' '-4.00'   '-3.52'  '-3.00'   '-2.52'   '-2.00'   '-1.52'   '-1.00'   '-0.52'         '0.00'});
xtickangle(90);


%% Plot Figure for Subject 17
s4 = subplot(1,4,4);
hold on; box on;

% Threshold for computational observer
hold on; box on;
lFitLabel{3} = 'Computational Observer';
lFitLabel{4} = plotFigure(s4, covScaleModel, covScaleModelForMarkers, repmat(ModelThresholds,3,1), '--b', 'db');

% Threshold for mean subject
hold on; box on;
lFitLabel{1} = 'Subject 17';
lFitLabel{2} = plotFigure(s4, covScale, covScaleForMarkers, ThresholdSubject17, '-k', 'ok');

%
text(0,1.1,[{'Trendline: $\log_{10}(T^2) = \min\{\log_{10}(T^2_0), \log_{10}(T^2_0) + \alpha [\log_{10}(\sigma^2) - \log_{10}(\sigma^2_0)]\}$'}],...
    'interpreter','latex', 'fontsize',20)
legend(lFitLabel,'interpreter','latex','location','northwest');

logXScaleForPlotting = [-5; log10(covScaleModelForMarkers)];
xticks(logXScaleForPlotting);
xticklabels({'-Inf' '-4.00'   '-3.52'  '-3.00'   '-2.52'   '-2.00'   '-1.52'   '-1.00'   '-0.52'         '0.00'});
xtickangle(90);

save2pdf('Figure5.pdf', gcf, 600);
%%

function [fitCurve,gof2] = fitDoubleLinear(logXScale, logSquaredThreshold)
    fo = fitoptions('Method','NonlinearLeastSquares',...
        'Lower',[min(logSquaredThreshold(:)),0,min(logXScale)],...
        'Upper',[max(logSquaredThreshold(:)),10,max(logXScale)],...
        'StartPoint',[mean(logSquaredThreshold(:,1)) 1 mean(logXScale)]);
    ft = fittype('max(a,a+b*(x-c))','options',fo);
    [fitCurve,gof2] = fit(repmat(logXScale,size(logSquaredThreshold,1),1),reshape(logSquaredThreshold',[],1),ft);
end

function lFitLabel = plotFigure(s1, covScale, covScaleMarkers, Thresholds, colorLine, colorMarker)
    logXScale = log10(covScale);
    logXScaleForPlotting = log10(covScaleMarkers);
    logSquaredThreshold = log10(Thresholds.^2);
    [fitCurve, gof2] = fitDoubleLinear(logXScale, logSquaredThreshold);
    xxx = linspace(min(logXScaleForPlotting), max(logXScale), 100);
    yyy = fitCurve(xxx);
    l2 = errorbar(s1,logXScaleForPlotting, mean(logSquaredThreshold,1),std(logSquaredThreshold)/sqrt(12), ...
        colorMarker, 'linewidth', 2, 'MarkerSize', 10, 'MarkerFaceColor',colorMarker(2));
    lFit = plot(s1,xxx, yyy, colorLine, 'linewidth', 2);
    set(gca, 'Fontsize',20);
    xlabel('$\log_{10}(\sigma^2)$','interpreter', 'latex');
    ylabel('$\log_{10}(T^2)$','interpreter', 'latex');
    xlim([-5.5 0.5]);
    ylim([-3.4 -2.6]);
    lFitLabel = ['\{',num2str((fitCurve.a),3), ', ', ...
        num2str(fitCurve.b,3), ', ', num2str(fitCurve.c,3),'\}'];    
end