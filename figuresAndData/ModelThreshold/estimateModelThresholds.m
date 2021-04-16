% This file gets the thresholds of the linear receptive field computational model.
%
% The model takes a dot product of the LMS cone response image with the
% receptive field and then adds a gaussian noise proportional to the mean
% response. The mean is taken over all stimuli, so that the it's just
% additive Gaussian noise, not multiplicative noise.
%

%% History
%    12/10/20  dhb  Add quick plot at end
%              dhb  Coding and comments for clarity
%    12/12/20  dhb  Check variance growth with lightness.

%% Initialize
clear; close all;

% Set factor that controls scale of additive noise variance.
% This was chosen by hand through trial and error, to provide
% a fit to our data set.
decisionSigma = [0.088];

% Average the full calculation 10 times
nAverage = 10;

% There are 11 comparison images and 100 per comparison
nComparisonPerLRF = 11;
nImagesPerComparison = 100;

% Image row/col nPixels
nPixels = 51;

% RF center size
rfCenterRadiusPixels = 10;

% Set labels for each of the covariance scalars to be loaded in
cov_factor = {'Cov_0_0001','Cov_0_0003','Cov_0_001','Cov_0_003','Cov_0_01','Cov_0_03','Cov_0_10','Cov_0_30','Cov_1_00'};

% Allocate space for the results
modelThresholds = zeros(nAverage, length(cov_factor)); 

% Allocate space and run simulation nAverage times over all covariance
% scalar levels.
for iterAverage = 1:nAverage
    for iterCovariance = 1:length(cov_factor)
        % Clear except for what we're carrying forward.  This can produce
        % weird bugs if you add a variable below that is not local to this loop,
        % but forget to add it to this list.
        clearvars -except outputStruct1 outputStruct2 cov_factor fig iterCovariance modelThresholds decisionSigma iterAverage ...
            nComparisonPerLRF nImagesPerComparison nPixels rfCenterRadiusPixels lightnessNoDecisionNoiseVar
        
        % Make 2D center-surround receptive field
        LMSFilter = repmat(reshape(make2DRF(nPixels, rfCenterRadiusPixels),[],1),3,1);
        
        % Load the images to be analyzed and get the images
        pathToStimulus = ['LMSImages/',cov_factor{iterCovariance},'.mat'];
        stimulusFile = load(pathToStimulus);
        LMSImages = stimulusFile.LMSImages;
        if (size(LMSImages,1) ~= nPixels^2*3)
            error('Did not get expected number of pixels in read images');
        end
        if (size(LMSImages,2) ~= nComparisonPerLRF*nImagesPerComparison)
            error('Did not read expected number of images');
        end
        
        % Get RF responses for all images.
        XEstimateNoDecisionNoise = LMSImages'*LMSFilter;
        meanXEstimates = reshape(repmat(mean(reshape(XEstimateNoDecisionNoise,[],nComparisonPerLRF)),nImagesPerComparison,1),[],1);     
        XEstimate = XEstimateNoDecisionNoise +  meanXEstimates.*normrnd(0,decisionSigma,size(XEstimateNoDecisionNoise,1),1);
        
        %% Make psychometric function
        %
        % Pick nComparisonImages*N points randomly from the 0.4 lightness level for standard image
        % Pick N points randomly from each level for comparison image
        % Compare the estimated lightness of comparison with standard image
        % Draw the psychometric function
        %
        % The term lightness is used in variable naming below to denote the RF
        % response.
        nSimulatedTrials = 10000;
        lightnessNoDecisionNoise = reshape(XEstimateNoDecisionNoise(:,1),nImagesPerComparison,nComparisonPerLRF);
        lightness = reshape(XEstimate(:,1),nImagesPerComparison,nComparisonPerLRF);
        cmpIndex = randi(nImagesPerComparison,nSimulatedTrials,nComparisonPerLRF);
        stdIndex = randi(nImagesPerComparison,nSimulatedTrials,nComparisonPerLRF);
        
        stdLightness = zeros(nSimulatedTrials,nComparisonPerLRF);
        cmpLightness = zeros(nSimulatedTrials,nComparisonPerLRF);
        for ii = 1:nComparisonPerLRF
            stdLightness(:,ii) = lightness(stdIndex(:,ii),6);
            cmpLightness(:,ii) = lightness(cmpIndex(:,ii),ii);
        end
        
        %% Get sample variance for standard.
        %
        % This should be proportional to the covariance factors, if there
        % is no truncation in our image set.  That's because the covariance
        % matrix of a linear function of a multivariate Gaussian is a linear
        % function of the covaraiance matrix.  So if we scale the
        % covariance matrix and pass the variable through a linear
        % receptive field, the resulting univariate distribution should be
        % Gaussian and have variance scaled in same proportion across our
        % covariance scalars.
        if (iterAverage == 1)
            lightnessNoDecisionNoiseVar(iterCovariance,:) = var(lightnessNoDecisionNoise);
        end
        
        % Get psychometric function and threshold
        cmpChosen = cmpLightness > stdLightness;
        modelThresholds(iterAverage, iterCovariance) = returnThreshold(cmpChosen);
    end
end
modelThresholds = mean(modelThresholds);
covScalar = [0.0001 0.0003, 0.001,0.003,0.01, 0.03,0.10, 0.30,1];
save('modelThresholds.mat', 'covScalar', 'modelThresholds');

% Quick plot of sample standard covariance versus covScalars
% shows they are not linear.  Note that there
% is some variance for the very smallest covariance factor, although
% the ratio to largest is ~10^-3 so maybe it makes sense if we in fact drew
% very small noise, or if it arises because of rendering noise.
figure; clf; hold on
theColors = ['r' 'g' 'b' 'k' 'c' 'y'];
colorIndex = 1;
for cc = 1:nComparisonPerLRF
    plot(covScalar,lightnessNoDecisionNoiseVar(:,cc),[theColors(colorIndex) 'o'],'MarkerFaceColor',theColors(colorIndex));
    plot(covScalar,lightnessNoDecisionNoiseVar(:,cc),theColors(colorIndex),'LineWidth',1);
    colorIndex = colorIndex +1;
    if (colorIndex > length(theColors))
        colorIndex = 1;
    end
    effectiveCovarianceScalarsRaw(:,cc) = lightnessNoDecisionNoiseVar(:,cc)/lightnessNoDecisionNoiseVar(end,cc);
end
xlabel('Covariance Scalar');
ylabel('Standard RF Response Var');
effectiveCovarianceScalars = mean(effectiveCovarianceScalarsRaw,2);

% Compute normalized effective covariance scalars


% Quick plot of predictions
figure; clf; hold on
plot(log10(covScalar),log10(modelThresholds.^2),'ro','MarkerSize',12,'MarkerFaceColor','r');
xlabel('Log Covariance Scalar');
ylabel('Log Threshold^2');

%% Compute threshold from simulated psychophysical trials
%
% Basically a Palemedes fit of cumulative normal to simulated PF
function modelThresholds = returnThreshold(cmpChosen)

% Psychometric function form
PF = @PAL_CumulativeNormal;         % Alternatives: PAL_Gumbel, PAL_Weibull, PAL_CumulativeNormal, PAL_HyperbolicSecant

% paramsFree is a boolean vector that determins what parameters get
% searched over. 1: free parameter, 0: fixed parameter
paramsFree = [1 1 1 1];

% Initial guess.  Setting the first parameter to the middle of the stimulus
% range and the second to 1 puts things into a reasonable ballpark here.
paramsValues0 = [0.4 10 0 0];
lapseLimits = [0 0.05];

% Set up standard options for Palamedes search
options = PAL_minimize('options');

% Fit with Palemedes Toolbox.  The parameter constraints match the psignifit parameters above.  Some thinking is
% required to initialize the parameters sensibly.  We know that the mean of the cumulative normal should be
% roughly within the range of the comparison stimuli, so we initialize this to the mean.  The standard deviation
% should be some moderate fraction of the range of the stimuli, so again this is used as the initializer.
xx = linspace(0.35, 0.45,1000);

[paramsValues] = PAL_PFML_Fit(...
    [0.35:0.01:0.45]',mean(cmpChosen)',ones(size(mean(cmpChosen)')), ...
    paramsValues0,paramsFree,PF, ...
    'lapseLimits',lapseLimits,'guessLimits',[],'searchOptions',options,'gammaEQlambda',true);

yy = PF(paramsValues,xx');
psePal = PF(paramsValues,0.5,'inverse');
modelThresholds = PF(paramsValues,0.7602,'inverse')-psePal;

end


