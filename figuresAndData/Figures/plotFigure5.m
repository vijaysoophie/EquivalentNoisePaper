% This script plots figure 5 log threshold squared vs log sigma squared
%
clear; close all;
%% Load .csv file
dataFile = importfileForFigure4('../ObserverData/subjectThreshold.csv');
data = table2array(dataFile);

%% Observer covariance scales and thresholds
covScale = [eps data(3:end,1)']';
covScaleForMarkers = [0.000001 data(3:end,1)']';
nCovScalarsPlot = 100;
covScalarsPlot = logspace(log10(covScaleForMarkers(1)),log10(covScaleForMarkers(end)),nCovScalarsPlot);

ThresholdObserver2 = data(2:end, 2:4)';
ThresholdObserver4 = data(2:end, 5:7)';
ThresholdObserver8 = data(2:end, 8:10)';
ThresholdObserver17 = data(2:end, 11:13)';

covScaleModelForMarkers = [0.000001 0.0001 0.0003 0.001 0.003 0.01 0.03 0.1 0.3 1]';
ModelThresholdObserver2  = [0.0243 0.0255 0.0258 0.0267 0.0247 0.0256 0.0269 0.0302 0.0326 0.0422]; % decision noise = 0.10; surround value = -0.15
ModelThresholdObserver4  = [0.0244 0.0235 0.0235 0.0237 0.0240 0.0244 0.0244 0.0248 0.0271 0.0296]; % decision noise = 0.08; surround value = -0.10
ModelThresholdObserver8  = [0.0237 0.0233 0.0238 0.0234 0.0236 0.0235 0.0242 0.0250 0.0276 0.0307]; % decision noise = 0.08; surround value = -0.11
ModelThresholdObserver17 = [0.0265 0.0254 0.0254 0.0264 0.0251 0.0265 0.0273 0.0316 0.0361 0.0455]; % decision noise = 0.11; surround value = -0.16

%% Plot thresholds
hFig2 = figure(); % This starts a new plotting window
set(hFig2,'units','normalized', 'Position', [0.1 0.1 0.8 0.25]);


%% Plot Figure for Observer 2
s1 = subplot(1,4,1);
hold on; box on;

[tsdThresholdDPrime,tsdSigma2_i,tsdSigma2_e,tsdSignalExponent] = FitTSDModel(covScale',mean(ThresholdObserver2),...
    'thresholdDPrime', 1,'signalExponent', 1);
fprintf('\nTSD fit to data: thresholdDPrime = %0.1f, sigma2_i = %0.4g, sigma2_e = %0.4g, signalExponent = %0.3f\n', ...
    tsdThresholdDPrime,tsdSigma2_i,tsdSigma2_e,tsdSignalExponent);

% Generate smooth curve for plotting
tsdThreshDeltaPlot = ComputeTSDModel(tsdThresholdDPrime,tsdSigma2_i,tsdSigma2_e,tsdSignalExponent,covScalarsPlot);

errorbar(log10(covScaleForMarkers),mean(log10(ThresholdObserver2.^2)), std(log10(ThresholdObserver2.^2))/sqrt(3),'ro','MarkerFaceColor','r','MarkerSize',10,'LineWidth',2);
plot(log10(covScalarsPlot),log10(tsdThreshDeltaPlot.^2),'r','LineWidth',1);
plot(log10(covScaleModelForMarkers), log10(ModelThresholdObserver2.^2),'ks','MarkerFaceColor','k','MarkerSize',10,'LineWidth',2);

hold on; box on;
lFitLabel{1} = 'Observer 2';
lFitLabel{2} = ['\{$\sigma_i, \sigma_e$\} = ','\{',num2str(sqrt(tsdSigma2_i),3), ', ', num2str(sqrt(tsdSigma2_e),3),'\}'];
lFitLabel{3} = 'Computational Observer';

legend(lFitLabel,'interpreter','latex','location','northwest');
set(gca, 'Fontsize',20);
xlabel('log_{10}(\sigma^2)');
ylabel('log_{10}(T^2)');
xlim([-6.5 0.5]);
ylim([-3.4 -2.5]);
xticks([-6 -4:0]);
xticklabels({'-Inf', '-4', '-3', '-2', '-1', '0'})


%% Plot Figure for Observer 4
s2 = subplot(1,4,2);
hold on; box on;

[tsdThresholdDPrime,tsdSigma2_i,tsdSigma2_e,tsdSignalExponent] = FitTSDModel(covScale',mean(ThresholdObserver4),...
    'thresholdDPrime', 1,'signalExponent', 1);
fprintf('\nTSD fit to data: thresholdDPrime = %0.1f, sigma2_i = %0.4g, sigma2_e = %0.4g, signalExponent = %0.3f\n', ...
    tsdThresholdDPrime,tsdSigma2_i,tsdSigma2_e,tsdSignalExponent);

% Generate smooth curve for plotting
tsdThreshDeltaPlot = ComputeTSDModel(tsdThresholdDPrime,tsdSigma2_i,tsdSigma2_e,tsdSignalExponent,covScalarsPlot);

errorbar(log10(covScaleForMarkers),mean(log10(ThresholdObserver4.^2)), std(log10(ThresholdObserver4.^2))/sqrt(3),'ro','MarkerFaceColor','r','MarkerSize',10,'LineWidth',2);
plot(log10(covScalarsPlot),log10(tsdThreshDeltaPlot.^2),'r','LineWidth',1);
plot(log10(covScaleModelForMarkers), log10(ModelThresholdObserver4.^2),'ks','MarkerFaceColor','k','MarkerSize',10,'LineWidth',2);

hold on; box on;
lFitLabel{1} = 'Observer 4';
lFitLabel{2} = ['\{$\sigma_i, \sigma_e$\} = ','\{',num2str(sqrt(tsdSigma2_i),3), ', ', num2str(sqrt(tsdSigma2_e),3),'\}'];
lFitLabel{3} = 'Computational Observer';

legend(lFitLabel,'interpreter','latex','location','northwest');

legend(lFitLabel,'interpreter','latex','location','northwest');
set(gca, 'Fontsize',20);
xlabel('log_{10}(\sigma^2)');
ylabel('log_{10}(T^2)');
xlim([-6.5 0.5]);
ylim([-3.4 -2.5]);
xticks([-6 -4:0]);
xticklabels({'-Inf', '-4', '-3', '-2', '-1', '0'})

%% Plot Figure for Observer 8
s3 = subplot(1,4,3);
hold on; box on;

[tsdThresholdDPrime,tsdSigma2_i,tsdSigma2_e,tsdSignalExponent] = FitTSDModel(covScale',mean(ThresholdObserver8),...
    'thresholdDPrime', 1,'signalExponent', 1);
fprintf('\nTSD fit to data: thresholdDPrime = %0.1f, sigma2_i = %0.4g, sigma2_e = %0.4g, signalExponent = %0.3f\n', ...
    tsdThresholdDPrime,tsdSigma2_i,tsdSigma2_e,tsdSignalExponent);

% Generate smooth curve for plotting
tsdThreshDeltaPlot = ComputeTSDModel(tsdThresholdDPrime,tsdSigma2_i,tsdSigma2_e,tsdSignalExponent,covScalarsPlot);

errorbar(log10(covScaleForMarkers),mean(log10(ThresholdObserver8.^2)), std(log10(ThresholdObserver8.^2))/sqrt(3),'ro','MarkerFaceColor','r','MarkerSize',10,'LineWidth',2);
plot(log10(covScalarsPlot),log10(tsdThreshDeltaPlot.^2),'r','LineWidth',1);
plot(log10(covScaleModelForMarkers), log10(ModelThresholdObserver8.^2),'ks','MarkerFaceColor','k','MarkerSize',10,'LineWidth',2);

hold on; box on;
lFitLabel{1} = 'Observer 8';
lFitLabel{2} = ['\{$\sigma_i, \sigma_e$\} = ','\{',num2str(sqrt(tsdSigma2_i),3), ', ', num2str(sqrt(tsdSigma2_e),3),'\}'];
lFitLabel{3} = 'Computational Observer';

legend(lFitLabel,'interpreter','latex','location','northwest');

legend(lFitLabel,'interpreter','latex','location','northwest');
set(gca, 'Fontsize',20);
xlabel('log_{10}(\sigma^2)');
ylabel('log_{10}(T^2)');
ylim([-3.4 -2.5]);
xlim([-6.5 0.5]);
xticks([-6 -4:0]);
xticklabels({'-Inf', '-4', '-3', '-2', '-1', '0'})

%% Plot Figure for Observer 17
s4 = subplot(1,4,4);
hold on; box on;

[tsdThresholdDPrime,tsdSigma2_i,tsdSigma2_e,tsdSignalExponent] = FitTSDModel(covScale',mean(ThresholdObserver17),...
    'thresholdDPrime', 1,'signalExponent', 1);
fprintf('\nTSD fit to data: thresholdDPrime = %0.1f, sigma2_i = %0.4g, sigma2_e = %0.4g, signalExponent = %0.3f\n', ...
    tsdThresholdDPrime,tsdSigma2_i,tsdSigma2_e,tsdSignalExponent);

% Generate smooth curve for plotting
tsdThreshDeltaPlot = ComputeTSDModel(tsdThresholdDPrime,tsdSigma2_i,tsdSigma2_e,tsdSignalExponent,covScalarsPlot);

errorbar(log10(covScaleForMarkers),mean(log10(ThresholdObserver17.^2)), std(log10(ThresholdObserver17.^2))/sqrt(3),'ro','MarkerFaceColor','r','MarkerSize',10,'LineWidth',2);
plot(log10(covScalarsPlot),log10(tsdThreshDeltaPlot.^2),'r','LineWidth',1);
plot(log10(covScaleModelForMarkers), log10(ModelThresholdObserver17.^2),'ks','MarkerFaceColor','k','MarkerSize',10,'LineWidth',2);

hold on; box on;
lFitLabel{1} = 'Observer 17';
lFitLabel{2} = ['\{$\sigma_i, \sigma_e$\} = ','\{',num2str(sqrt(tsdSigma2_i),3), ', ', num2str(sqrt(tsdSigma2_e),3),'\}'];
lFitLabel{3} = 'Computational Observer';

legend(lFitLabel,'interpreter','latex','location','northwest');

legend(lFitLabel,'interpreter','latex','location','northwest');
set(gca, 'Fontsize',20);
xlabel('log_{10}(\sigma^2)');
ylabel('log_{10}(T^2)');
ylim([-3.4 -2.5]);
xlim([-6.5 0.5]);
xticks([-6 -4:0]);
xticklabels({'-Inf', '-4', '-3', '-2', '-1', '0'})

% save2pdf('Figure5.pdf', gcf, 600);
%% Compute thresholds under simple underlying TSD model
%
% For the signalExponent == 1 case, just need to invert the forward relation
%       thresholdDPrime = (thresholdLRF - standardLRF)/sqrt(sigman2_n + covScalar*sigma2_e);
%
% This corresponds to adding noise to both comparison and standard
% representationsm as per standard definition of d-prime under equal
% variance distributions.
%
% Since the threshold we want is the difference from the standard, we can
% just treat the standardLRF as 0 without loss of generality.
%
% The raising to the signalExponent is provides an ad-hoc parameter that allows us
% more flexibility in fiting the data, but its underlying interpretation
% isn't clear.  Note that when the signalExponent isn't 1, it's hard to
% interpret the sigma's of the fit.  Or at least, we have not thought that
% through yet.
function thresholdDelta = ComputeTSDModel(thresholdDPrime,sigma2_i,sigma2_e,signalExponent,covScalars)

for jj = 1:length(covScalars)
%     thresholdDelta(jj) = (sqrt(sigma2_i + covScalars(jj)*sigma2_e)*thresholdDPrime).^(1/signalExponent);
    thresholdDelta(jj) = (sqrt(sigma2_i + covScalars(jj)*sigma2_e)*thresholdDPrime);
end

end

%% FitTSDModel
function [thresholdDPrime,sigma2_i,sigma2_e,signalExponent] = FitTSDModel(covScalars,thresholdDelta,varargin)

p = inputParser;
p.addParameter('thresholdDPrime',1,@(x) (isempty(x) | isnumeric(x)));
p.addParameter('signalExponent',1,@(x) (isempty(x) | isnumeric(x)));
p.parse(varargin{:});

% Set thresholdDPrime initial value and bounds depending on parameters
% Empty means search over it, otherwise lock at passed
% value.
if (~isempty(p.Results.thresholdDPrime))
    thresholdDPrime0 = p.Results.thresholdDPrime;
    thresholdDPrimeL = p.Results.thresholdDPrime;
    thresholdDPrimeH = p.Results.thresholdDPrime;
else
    thresholdDPrime0 = 1;
    thresholdDPrimeL = 1e-10;
    thresholdDPrimeH = 1e10;
end

% Set signalExponent initial value and bounds depending on parameters
% Empty means search over it, otherwise lock at passed
% value.
if (~isempty(p.Results.signalExponent))
    signalExponent0 = p.Results.signalExponent;
    signalExponentL = p.Results.signalExponent;
    signalExponentH = p.Results.signalExponent;
    nExps = 1;
else
    signalExponent0 = 1;
    signalExponentL = 1e-2;
    signalExponentH = 1e2;
    nExps = 20;
end

% Bounds
vlb = [thresholdDPrimeL 1e-20 1e-20 signalExponentL];
vub = [thresholdDPrimeH  100 100 signalExponentH];

% Grid over starting parameters
trySignalExponents = linspace(signalExponentL,signalExponentH,nExps);

% Search
bestF = Inf;
bestX = [];
for ee = 1:nExps
    thresholdDPrime0 = thresholdDPrime0;
    signalExponent0 = trySignalExponents(ee);
    sigma2_i0 = ((min(thresholdDelta).^signalExponent0)/thresholdDPrime0).^2;
    sigma2_e0 = sigma2_i0;
    
    x0 = [thresholdDPrime0 sigma2_i0 sigma2_e0 signalExponent0];
    options = optimset(optimset('fmincon'),'Diagnostics','off','Display','off','LargeScale','off','Algorithm','active-set');
    x = fmincon(@(x)FitTSDModelFun(x,covScalars,thresholdDelta),x0,[],[],[],[],vlb,vub,[],options);
    f = FitTSDModelFun(x,covScalars,thresholdDelta);
    if (f < bestF)
        bestF = f;
        bestX = x;
    end
end

% Extract parameters
thresholdDPrime = bestX(1);
sigma2_i = bestX(2);
sigma2_e = bestX(3);
signalExponent = bestX(4);
end

%% Error function for TSD model fitting
function f = FitTSDModelFun(x,covScalars,thresholdDelta)

thresholdDPrime = x(1);
sigma2_i = x(2);
sigma2_e = x(3);
signalExponent = x(4);
predictedDelta = ComputeTSDModel(thresholdDPrime,sigma2_i,sigma2_e,signalExponent,covScalars);
diff2 = (thresholdDelta - predictedDelta).^2;
f = sqrt(mean(diff2));

end