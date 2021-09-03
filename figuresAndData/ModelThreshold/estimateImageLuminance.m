% Estimate average luminance of images and target objects used in the
% experiment. 
%
% This script estimates the average luminance of the standard image in the 
% simplest case (covariance scale factor zero). It also estimates the
% average luminance of the target object for all LRF values. For this we
% first calculate the values (settings) that were applied to the monitor
% primaries in the experiment. These correspond to the gamma corrected 
% values of the primaries that needs to be applied to the monitor for 
% producing the required LMS response for the standard observer. 
% We then convert these values back to the primary co-ordinates using the
% inverse gamma function. We use the tristimulus values of the 1931
% standard observer and the spectral power distribution of the monitor
% primaries to get the CIE-XYZ color co-ordiantes. The luminance is read as
% the Y coordinate.
%
% Sep 03, 2021; Vijay Singh wrote this.


%%
clear;

% Scale factor used in the experiment
scaleFactor = 5.4;

%% Load the LMS struct for the simplest case cov_0.00
pathToLMSStruct = fullfile('dataForLuminanceEstimation', 'Cov_0_00', 'LMSStruct.mat');
temp = load(pathToLMSStruct); LMSStruct = temp.LMSStruct; clear temp;

%% Load the calibration file
pathToFile = fullfile('dataForLuminanceEstimation', 'CNSU_0002_Condition_0_00_Iteration_1-1.mat');
load(pathToFile);
cal = data.cal;  clear data;

%% Convert LMS image to monitor settings image using calibration struct and scale factor
imageInSettings = zeros(size(LMSStruct.LMSImageInCalFormat));
for ii = 1:length(LMSStruct.luminanceLevels)
    imageInSettings(:,:,ii) = SensorToSettings(cal, scaleFactor*LMSStruct.LMSImageInCalFormat(:,:,ii));
end
imageInSettings(imageInSettings < 0 ) = 0;

%% Convert from monitor settings to primary
imageInPrimary = zeros(size(LMSStruct.LMSImageInCalFormat));
for ii = 1:length(LMSStruct.luminanceLevels)
    imageInPrimary(:,:,ii) = SettingsToPrimary(cal, imageInSettings(:,:,ii));
end

%% Check if there is any difference if we converted straight from sensor to primary
imageInPrimaryUsingSensor = zeros(size(LMSStruct.LMSImageInCalFormat));
for ii = 1:length(LMSStruct.luminanceLevels)
    imageInPrimaryUsingSensor(:,:,ii) = SensorToPrimary(cal, scaleFactor*LMSStruct.LMSImageInCalFormat(:,:,ii));
end

display(max(reshape(abs(imageInPrimaryUsingSensor-imageInPrimary)./imageInPrimaryUsingSensor, 1, [])));

%% Convert from primary values to CIE-XYZ
imagesInXYZ = zeros(size(LMSStruct.LMSImageInCalFormat));
for ii = 1:length(LMSStruct.luminanceLevels)
    imagesInXYZ(:,:,ii) = cal.M_linear_device*imageInPrimary(:,:,ii);
end

