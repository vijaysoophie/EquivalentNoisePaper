% Plot of figure 6. The internal and external noise for various observers.

% 
noiseEstimatedBySDTModel    = [24817   2       4       8       17;      % ObserverID
                               0.0256  0.0263  0.0246  0.0240  0.0274;  % Internal Noise
                               0.0294  0.0372  0.0183  0.0213  0.0393]; % External Noise

% noiseInModelGaussian = [24817   2       4       8       17;     % ObserverID
%                         18082.2 18490.2 17958.6 17636.1 18551.1];
% 
% % Value of C'                     
% valueOfCPrime        = [24817   2       4       8       17;     % ObserverID
%                         722600  716200  741300  738100  708200];
%                     
%                     
% valueOfSurround = [24817    2           4           8           17;     % ObserverID
%                   -0.119734 -0.132154  -0.0833749  -0.0896376   -0.147739];

                  
noiseEstimatedByCompRFModel = [24817   2       4       8       17;      % ObserverID
                               0.0250  0.0258  0.0242  0.0239  0.0262;  % Internal Noise
                               0.0429  0.0455  0.0365  0.0374  0.0492]; % External Noise                                    
                  
figure;
hold on;
plot([0.9:4.9], noiseEstimatedBySDTModel(2,:),'o', 'MarkerSize', 12, 'color', [0.39,0.83,0.07], 'linewidth', 2);
plot([0.9:4.9], noiseEstimatedBySDTModel(3,:),'o', 'MarkerSize', 12, 'MarkerFaceColor', [0.00,0.45,0.74],'color', [0.00,0.45,0.74]);

plot([1.1:5.1], noiseEstimatedByCompRFModel(2,:), 's', 'MarkerSize', 15,'color', [0.39,0.83,0.07], 'linewidth', 2);
plot([1.1:5.1], noiseEstimatedByCompRFModel(3,:), 's', 'MarkerSize', 15, 'MarkerFaceColor', [0.00,0.45,0.74],'color', [0.00,0.45,0.74]);

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