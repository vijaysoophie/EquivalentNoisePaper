% This script plots SI Figure 2 threshold squared vs various conditions

clear;

ThresholdSubject4 = [0.0256    0.0281    0.0251    0.0422    0.034;
                     0.0249    0.0228    0.0246    0.038     0.0364;
                     0.0301    0.0228    0.0209    0.0296    0.0287];

ThresholdSubject5 = [0.0211    0.0393    0.0275    0.0359    0.0346
                     0.0212    0.0228    0.0283    0.0456    0.0382
                     0.0229    0.0294    0.0342    0.0331    0.0439];

ThresholdSubject8 = [0.0147    0.0209    0.0158    0.0362    0.0309
                     0.0161    0.0123    0.0150    0.0303    0.0267
                     0.0192    0.0175    0.0218    0.0309    0.0242];

ThresholdSubject11 = [0.0221    0.0309    0.0283    0.0603    0.0606
                     0.0273    0.0235    0.0289    0.0527    0.0361
                     0.0263    0.0261    0.0284    0.0444    0.0349];
                 
ThresholdExperiment3_observer2  = [0.0334    0.0454    0.0499];
ThresholdExperiment3_observer4  = [0.0270    0.0319    0.0295];
ThresholdExperiment3_observer8  = [0.0277    0.0399    0.0278];
ThresholdExperiment3_observer17  = [0.0395   0.0462    0.0505];


AllThresholdsExperiment2 = [ThresholdSubject4; ThresholdSubject5; 
                            ThresholdSubject8; ThresholdSubject11];
                        
AllThresholdsExperiment3 = [ThresholdExperiment3_observer2 ThresholdExperiment3_observer4 ...
                            ThresholdExperiment3_observer8 ThresholdExperiment3_observer17]';
                        
%% Plot subject thresholds
figure; 
hold on;
g1 = errorbar([1:6]-0.1 , mean(log10([ThresholdSubject4 ThresholdExperiment3_observer4'].^2)), std(log10([ThresholdSubject4 ThresholdExperiment3_observer4'].^2))/sqrt(3), '.','Markersize',30, 'linewidth',2);
g2 = errorbar([1:5]-0.05 , mean(log10(ThresholdSubject5.^2)), std(log10(ThresholdSubject5.^2))/sqrt(3), '.','Markersize',30, 'linewidth',2);
g3 = errorbar([1:6]+0.05 , mean(log10([ThresholdSubject8 ThresholdExperiment3_observer8'].^2)), std(log10([ThresholdSubject8 ThresholdExperiment3_observer8'].^2))/sqrt(3), '.','Markersize',30, 'linewidth',2);
g4 = errorbar([1:5]+0.1 , mean(log10(ThresholdSubject11.^2)), std(log10(ThresholdSubject11.^2))/sqrt(3), '.','Markersize',30, 'linewidth',2);

g5 = errorbar([6]-0.05 , mean(log10(ThresholdExperiment3_observer2.^2)), std(log10(ThresholdExperiment3_observer2.^2))/sqrt(3), '.','Markersize',30, 'linewidth',2);
g8 = errorbar([6]+0.05 , mean(log10(ThresholdExperiment3_observer17.^2)), std(log10(ThresholdExperiment3_observer17.^2))/sqrt(3), '.','Markersize',30, 'linewidth',2);

legend({'Observer 4','Observer 5','Observer 8','Observer 11','Observer 2','Observer 17'},'location','northwest');
xlim([0.5 6.5]);
ylim([-3.42 -2.49]);
xticks([1:6]);
xticklabels({'1','2','2a', '3', '3a', '\sigma^2 = 1'});
box on;
set(gca, 'FontSize', 20, 'yscale', 'log');
xlabel('Condition number');
ylabel('$\log_{10} T^2$', 'Interpreter','latex');

