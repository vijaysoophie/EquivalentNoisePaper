% This script plots Figure 7 of the Equivalent Noise paper. The figure is 
% saved in the folder EquivalentNoisePaper/figuresAndData/Figures as 
% Figure6.pdf.
%
% The internal and external noise for various observers are given below.
% The noise of the SDT model were estimated by fitting the SDT model to the
% subject threshold data. The noise for the LINRF model was estimated using
% the formulas given the main text. See subsection Linear Receptive Field
% Model Fit in the Methods section of the main text.
%
% Aug 15, 2021: Vijay Singh changed name to Figure7.

%% Estimate the internal and external noise of the SDT Model
% These were estimated by fitting the SDT model to the subject threshold
% data. See subsection SDT Model Fit in the Methods section of the main text.

noiseEstimatedBySDTModel    = [24817        2       4       8      17;  % ObserverID       24817: Mean Observer
                               0.0256  0.0263  0.0246  0.0240  0.0274;  % Internal Noise
                               0.0294  0.0372  0.0183  0.0213  0.0393]; % External Noise

%% Parameters of the LINRF model for each subject.
% These values were calculated by minimizing the root mean-square error 
% between LINRF model thresholds and threshold of the subject. See 
% estimateLINRFThresholds.m in the folder figuresAndData/ModelThreshold of 
% the supplementary materials for details. Also, see Linear Receptive Field
% Model Fit in the Methods section of the main text.

noiseInLINRFGaussian = [24817         2       4       8       17;     % ObserverID
                        18082.2 18490.2 17958.6 17636.1 18551.1];                    

% Value of surround pixels of the receptive field in the LINRF model. This 
% value was calculated by minimizing the root mean-square error between 
% LINRF model thresholds and threshold of the subject. See 
% estimateLINRFThresholds.m for details.
valueOfSurround      = [24817             2           4           8           17;     % ObserverID
                        -0.119734 -0.132154  -0.0833749  -0.0896376   -0.147739];
                    
% Value of C'. This parameter relates the receptive field response to the
% threshold. See sub-section Linear Receptive Field Model in the Methods 
% section of the main text.
valueOfCPrime        = [24817        2       4       8       17;      % ObserverID
                        722600  716200  741300  738100  708200];                    

%% Estimate the internal and external noise of the LINRFModel
load('../ModelThreshold/LMSImages/Cov_1_00.mat');
Sigma_e0 = cov(LMSImages');
% Image row/col nPixels
nPixels = 51;
% RF center size
rfCenterRadiusPixels = 10;

% Internal Noise
internalNoiseLINRF = noiseInLINRFGaussian(2,:)./valueOfCPrime(2,:);

% External Noise
for ii = 1:5
    surroundValueTemp = valueOfSurround(2,ii);
    cPrimeTemp = valueOfCPrime(2,ii);
    RF = repmat(reshape(make2DRF(nPixels, rfCenterRadiusPixels, [1, surroundValueTemp]),[],1),3,1);
    externalNoiseLINRF(1,ii) = sqrt((RF'*Sigma_e0*RF)/(cPrimeTemp.^2));
end

%%
noiseEstimatedByLINRFModel = [24817        2       4       8       17; % ObserverID
                              internalNoiseLINRF;                      % Internal Noise
                              externalNoiseLINRF];                     % External Noise                                    

                           
%%                  
figure;
set(gcf,'Position',[100 100 800 500]);
hold on;
plot([0.9:4.9], noiseEstimatedBySDTModel(2,:),'o', 'MarkerSize', 12, 'color', [0.39,0.83,0.07], 'linewidth', 2);
plot([0.9:4.9], noiseEstimatedBySDTModel(3,:),'o', 'MarkerSize', 12, 'MarkerFaceColor', [0.00,0.45,0.74],'color', [0.00,0.45,0.74]);

plot([1.1:5.1], noiseEstimatedByLINRFModel(2,:), 's', 'MarkerSize', 15,'color', [0.39,0.83,0.07], 'linewidth', 2);
plot([1.1:5.1], noiseEstimatedByLINRFModel(3,:), 's', 'MarkerSize', 15, 'MarkerFaceColor', [0.00,0.45,0.74],'color', [0.00,0.45,0.74]);

legend({'\sigma_{i,SDT}', '\sigma_{e0,SDT}', '\sigma_{i,LINRF}', '\sigma_{e0,LINRF}'}, 'location', 'northeastoutside', 'FontSize',20)
xlim([0.5 5.5]);
ylim([0. 0.05]);
xticks([1:5]);
yticks([0.01:0.01:0.05]);
xticklabels({'Mean Obs', '2', '4','8', '17'});
box on;
set(gca, 'FontSize', 20);
xlabel('Observer');
ylabel('Noise Standard Deviation');

