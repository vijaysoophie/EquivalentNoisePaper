% This script calcautes the root mean squared error (RMSE) between the 
% thresholds of the mean human subject and the LINRF model. The RMSE is fit
% by a quadratic polynomial in two variables. The polynomial is minimized 
% to get the parameters that give lowest RMSE.
% 
% The same process was repeated for individual subjects to get the best
% fit parametes of the individual subjects. To do this, remove the
% appropriate lines from the thresholdAllSubjects matrix in the section below.
%
% May 02 2021 Vijay Singh wrote this.
%
%%
% Load human subject threholds 
clear;
load('subjectThresholds.mat');

thresholdAllSubjects = [Subject2Thresholds;
                        Subject4Thresholds;
                        Subject8Thresholds;
                        Subject17Thresholds];

% Load model threholds 
load('modelThresholds.mat');
                    
%% Create a 3D matrix of the threshold of the mean human subject.

% Calcuate the mean threshold of all subjects
thresholdMeanSubject = mean(thresholdAllSubjects);

% Reorganize the thresholds to create a 3D matrix.
thresholdMeanSubject = repmat(thresholdMeanSubject, size(modelThresholds, 2),1);
thresholdMeanSubject3D = zeros(size(modelThresholds, 1), size(modelThresholds, 2), 6);

for ii = 1:size(modelThresholds, 1)
    thresholdMeanSubject3D(ii, :, :) = thresholdMeanSubject;
end

%% Calculate the root mean squared error between human and model threhsolds
RMSE = sum((squeeze(mean(modelThresholds,3)) - thresholdMeanSubject3D).^2,3);

%%
[xData, yData, zData] = prepareSurfaceData( decisionSigma, surroundValue, RMSE );

% Set up fittype and options.
ft = fittype( 'poly22' );

% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft );

% Plot fit with data.
figure( 'Name', 'RMSE between mean human subject and computational model' );
h = plot( fitresult, [xData, yData], zData );
legend( h, 'Fit of quadratic polynomial in two variables', 'RMSE vs. decisionSigma, surroundValue', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'decisionSigma', 'Interpreter', 'none' );
ylabel( 'surroundValue', 'Interpreter', 'none' );
zlabel( 'RMSE', 'Interpreter', 'none' );
grid on;

%% Parameters that give minimum RMSE
decisionSigmaMin = -((2*fitresult.p02*fitresult.p10 - fitresult.p01*fitresult.p11)/(-fitresult.p11^2 + 4*fitresult.p02*fitresult.p20));
surroundValueMin = -((fitresult.p10*fitresult.p11 - 2*fitresult.p01*fitresult.p20)/(fitresult.p11^2 - 4*fitresult.p02*fitresult.p20));



