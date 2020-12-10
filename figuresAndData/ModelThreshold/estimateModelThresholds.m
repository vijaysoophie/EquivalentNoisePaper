% This file gets the thresholds of the computational model.
%
% The model takes a dot product of the LMS cone response image with the
% receptive field and then adds a gaussian noise proportional to the mean
% response. 
%

clear;
decisionSigma = [0.088]; % Noise in the decision making process.
nAverage = 10;
cov_factor = {'Cov_0_0001','Cov_0_0003','Cov_0_001','Cov_0_003','Cov_0_01','Cov_0_03','Cov_0_10','Cov_0_30','Cov_1_00'};
modelThresholds = zeros(nAverage, length(cov_factor)); % Space allocation

for iterAverage = 1:nAverage
    
    for iterCovariance = 1:length(cov_factor)
        
        clearvars -except outputStruct1 outputStruct2 cov_factor fig iterCovariance modelThresholds decisionSigma iterAverage

        % Load the images to be analyzed
        pathToStimulus = ['LMSImages/',cov_factor{iterCovariance},'.mat'];
        stimulusFile = load(pathToStimulus);
        
        % Perform Analysis
        % Make RFs
        LMSFilter = repmat(reshape(make2DRF(51, 10),[],1),3,1);
        
        % Initialize LMS images set
        LMSImages = stimulusFile.LMSImages;
        
        % Get Estimates
        XEstimate =[];
        
        XEstimate = LMSImages'*LMSFilter;
        meanXEstimates = reshape(repmat(mean(reshape(XEstimate,[],11)),100,1),[],1);
        XEstimate = XEstimate +  meanXEstimates.*normrnd(0,decisionSigma,size(XEstimate,1),1);
        
        %% Make psychometric function
        
        % Pick 11*N points randomly from the 0.4 lightness level for standard image
        % Pick N points randomly from each level for comparison image
        % Compare the estimated lightness of comparison with standard image
        % Draw the psychometric function
        
        N = 10000;
        Lightness = reshape(XEstimate(:,1), 100,11);
        cmpIndex = randi(100,N,11);
        stdIndex = randi(100,N,11);
        
        stdLightness = zeros(N,11);
        cmpLightness = zeros(N,11);
        
        for ii = 1:11
            stdLightness(:,ii) = Lightness(stdIndex(:,ii),6);
            cmpLightness(:,ii) = Lightness(cmpIndex(:,ii),ii);
        end
        
        cmpChosen = cmpLightness > stdLightness;
        modelThresholds(iterAverage, iterCovariance) = returnThreshold(cmpChosen);
    end
end
modelThresholds = mean(modelThresholds);
covScalar = [0.0001 0.0003, 0.001,0.003,0.01, 0.03,0.10, 0.30,1];
save('modelThresholds.mat', 'covScalar', 'modelThresholds');


%%
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


