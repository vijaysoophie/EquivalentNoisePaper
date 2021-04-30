function [fitresult, gof] = createFit(decisionSigma, surroundValue, RMSE)
%CREATEFIT(DECISIONSIGMA,SURROUNDVALUE,RMSE)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : decisionSigma
%      Y Input : surroundValue
%      Z Output: RMSE
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 22-Jan-2021 21:48:21


%% Fit: 'untitled fit 1'.
[xData, yData, zData] = prepareSurfaceData( decisionSigma, surroundValue, RMSE );

% Set up fittype and options.
ft = fittype( 'poly22' );

% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft );

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( fitresult, [xData, yData], zData );
legend( h, 'untitled fit 1', 'RMSE vs. decisionSigma, surroundValue', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'decisionSigma', 'Interpreter', 'none' );
ylabel( 'surroundValue', 'Interpreter', 'none' );
zlabel( 'RMSE', 'Interpreter', 'none' );
grid on

