% This script plots Figure 5 of the Equivalent Noise paper.
%
% In this figure we plot log threshold squared vs log sigma squared for the
% mean observer. The data is then fit by Signal Detection Theory (SDT) 
% model and the Linear Receptive Field (Linear RF) model. The figure is
% saved in the folder EquivalentNoisePaper/figuresAndData/Figures as 
% Figure4.pdf.
%
% Unknown date: Vijay Singh wrote this.
% May 02, 2021: Vijay Singh modified and added comments.
% Aug 15, 2021: Vijay Singh changed name to Figure5.
%
%%

clear; close all;
%% Load .csv file
dataFile = importfileForFigure5('../ObserverData/subjectThreshold.csv');
data = table2array(dataFile);

%% Get the covariance scales and subject thresholds
covScale = [eps data(3:end,1)']'; % Covariance scales used for plotting. eps is used for covariance scale zero for calculations.
covScaleForMarkers = [0.000001 data(3:end,1)']'; % Zero covariance scale is replaced by 0.000001 for plotting.

nCovScalarsPlot = 100; % Number of points used in plot for the smooth curves.
covScalarsPlot = logspace(log10(covScaleForMarkers(1)),log10(covScaleForMarkers(end)),nCovScalarsPlot);

ThresholdSubject2 = data(2:end, 2:4)';
ThresholdSubject4 = data(2:end, 5:7)';
ThresholdSubject8 = data(2:end, 8:10)';
ThresholdSubject17 = data(2:end, 11:13)';

ThresholdMeanSubject = [ThresholdSubject2; ThresholdSubject4; ThresholdSubject8; ThresholdSubject17];

%% Model covariance scales and thresholds
covScaleModel = [eps 0.0001 0.0003 0.001 0.003 0.01 0.03 0.1 0.3 1]';
covScaleModelForMarkers = [0.000001 0.0001 0.0003 0.001 0.003 0.01 0.03 0.1 0.3 1]';
% Model thresholds obtained through simulations. The 
% estimateModelThresholds.m file in the folder ModelThreshold was used to
% obtain these values.
ModelThresholds = [0.0248 0.0246 0.0242 0.0245 0.0248 0.0251 0.0255 0.0281 0.0315 0.0386]; %decision noise 18082.2 surround value -0.0119734
%%
fitThresholdDPrime = false;
fitSignalExponent = false;

simThresholdDPrime = 1;
simSignalExponent = 1;

% Fit the underlying SDT model
%
% If we're fitting thresholdDPrime, pass [] in key/value pair.  Otherwise pass fixed value
% to use.
if (fitThresholdDPrime)
    passThresholdDPrime = [];
else
    passThresholdDPrime = simThresholdDPrime;
end

% If we're fitting signalExponent, pass [] in key/value pair. Otherwise
% pass fixed value to use.
if (fitSignalExponent)
    passSignalExponent = [];
else
    passSignalExponent = simSignalExponent;
end

%% This part fits the SDT model to the thresholds of the mean subject.
% It also finds the paramters of the SDT model fit.

[tsdThresholdDPrime,tsdSigma2_i,tsdSigma2_e,tsdSignalExponent] = FitSDTModel(covScale',mean(ThresholdMeanSubject),...
    'thresholdDPrime',passThresholdDPrime,'signalExponent',passSignalExponent);
fprintf('\nSDT fit to data: thresholdDPrime = %0.1f, sigma2_i = %0.4g, sigma2_e = %0.4g, signalExponent = %0.3f\n', ...
    tsdThresholdDPrime,tsdSigma2_i,tsdSigma2_e,tsdSignalExponent);

% Generate smooth curve for plotting
tsdThreshDeltaPlot = ComputeSDTModel(tsdThresholdDPrime,tsdSigma2_i,tsdSigma2_e,tsdSignalExponent,covScalarsPlot);


%% This part fits the SDT model to the thresholds of the LINRF model.
% It also finds the paramters of the SDT model fit.

[tsdThresholdDPrime_Model,tsdSigma2_i_Model,tsdSigma2_e_Model,tsdSignalExponent_Model] = FitSDTModel(covScaleModel,ModelThresholds,...
    'thresholdDPrime',passThresholdDPrime,'signalExponent',passSignalExponent);
fprintf('\nSDT fit to data: thresholdDPrime = %0.1f, sigma2_i = %0.4g, sigma2_e = %0.4g, signalExponent = %0.3f\n', ...
    tsdThresholdDPrime_Model,tsdSigma2_i_Model,tsdSigma2_e_Model,tsdSignalExponent_Model);

% Generate smooth curve for plotting
tsdThreshDeltaPlot_Model = ComputeSDTModel(tsdThresholdDPrime_Model,tsdSigma2_i_Model,tsdSigma2_e_Model,tsdSignalExponent_Model,covScalarsPlot);

%% Plot thresholds
figure;
hold on; box on;
errorbar(log10(covScaleForMarkers),mean((log10(ThresholdMeanSubject.^2))), std(log10(ThresholdMeanSubject.^2))/sqrt(12),'ro','MarkerFaceColor','r','MarkerSize',10,'LineWidth',2);
plot(log10(covScalarsPlot),log10(tsdThreshDeltaPlot.^2),'r','LineWidth',2);

plot(linspace(-6,0,100), -4.224 + 1.112.^(((linspace(-6,0,100)+6)/5).^6.345), 'k','LineWidth',2);
plot(log10(covScaleModelForMarkers),log10(ModelThresholds.^2),'ks','MarkerFaceColor','k','MarkerSize',5);

%%
lFitLabel{1} = 'Mean Subject';
lFitLabel{2} = ['SDT \{$\sigma_i, \sigma_{e0}$\} = ','\{',num2str(sqrt(tsdSigma2_i),3), ', ', num2str(sqrt(tsdSigma2_e),3),'\}'];

% Threshold for computational observer
hold on; box on;
lFitLabel{3} = ['LINRF \{$\sigma_i, \sigma_{e0}$\} = \{0.0250, 0.0429\}'];

legend(lFitLabel,'interpreter','latex','location','northwest');
set(gca, 'Fontsize',20);
xlabel('log_{10}(\sigma^2)');
ylabel('log_{10}(T^2)');
xlim([-6.5 0.5]);
ylim([-3.42 -2.49]);
xticks([-6 -4:0]);
xticklabels({'-Inf', '-4', '-3', '-2', '-1', '0'});
save2pdf('Figure5.pdf', gcf, 600);

%% Compute thresholds under simple underlying SDT model
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
function thresholdDelta = ComputeSDTModel(thresholdDPrime,sigma2_i,sigma2_e,signalExponent,covScalars)

for jj = 1:length(covScalars)
    thresholdDelta(jj) = (sqrt(sigma2_i + covScalars(jj)*sigma2_e)*thresholdDPrime);
end

end

%% FitSDTModel
function [thresholdDPrime,sigma2_i,sigma2_e,signalExponent] = FitSDTModel(covScalars,thresholdDelta,varargin)

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
    x = fmincon(@(x)FitSDTModelFun(x,covScalars,thresholdDelta),x0,[],[],[],[],vlb,vub,[],options);
    f = FitSDTModelFun(x,covScalars,thresholdDelta);
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

%% Error function for SDT model fitting
function f = FitSDTModelFun(x,covScalars,thresholdDelta)

thresholdDPrime = x(1);
sigma2_i = x(2);
sigma2_e = x(3);
signalExponent = x(4);
predictedDelta = ComputeSDTModel(thresholdDPrime,sigma2_i,sigma2_e,signalExponent,covScalars);
diff2 = (thresholdDelta - predictedDelta).^2;
f = sqrt(mean(diff2));

end


