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
        % Clear except for what we're carrying forward
        clearvars -except outputStruct1 outputStruct2 cov_factor fig iterCovariance modelThresholds decisionSigma iterAverage nComparisonPerLRF nImagesPerComparison nPixels rfCenterRadiusPixels
        
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
        XEstimate = LMSImages'*LMSFilter;
        meanXEstimates = reshape(repmat(mean(reshape(XEstimate,[],nComparisonPerLRF)),nImagesPerComparison,1),[],1);
        XEstimate = XEstimate +  meanXEstimates.*normrnd(0,decisionSigma,size(XEstimate,1),1);
        
        %% Make psychometric function
        %
        % Pick nComparisonImages*N points randomly from the 0.4 lightness level for standard image
        % Pick N points randomly from each level for comparison image
        % Compare the estimated lightness of comparison with standard image
        % Draw the psychometric function
        %
        % The term lightness is used in variable naming below to denote the RF
        % response.
        N = 10000;
        Lightness = reshape(XEstimate(:,1),nImagesPerComparison,nComparisonPerLRF);
        cmpIndex = randi(nImagesPerComparison,N,nComparisonPerLRF);
        stdIndex = randi(nImagesPerComparison,N,nComparisonPerLRF);
        
        stdLightness = zeros(N,nComparisonPerLRF);
        cmpLightness = zeros(N,nComparisonPerLRF);
        for ii = 1:nComparisonPerLRF
            stdLightness(:,ii) = Lightness(stdIndex(:,ii),6);
            cmpLightness(:,ii) = Lightness(cmpIndex(:,ii),ii);
        end
        
        % Get psychometric function and threshold
        cmpChosen = cmpLightness > stdLightness;
        modelThresholds(iterAverage, iterCovariance) = returnThreshold(cmpChosen);
    end
end
modelThresholds = mean(modelThresholds);
covScalar = [0.0001 0.0003, 0.001,0.003,0.01, 0.03,0.10, 0.30,1];
save('modelThresholds.mat', 'covScalar', 'modelThresholds');

% Quick plot
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


