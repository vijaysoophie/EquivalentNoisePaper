% Comparision of the rate of increase of threshold for the Linear RF model.

covScaleModelForMarkers = [0.000001 0.0001 0.0003 0.001 0.003 0.01 0.03 0.1 0.3 1]';
ModelThresholdObserver2  = [0.0243 0.0255 0.0258 0.0267 0.0247 0.0256 0.0269 0.0302 0.0326 0.0422]; % decision noise = 0.10; surround value = -0.15
ModelThresholdObserver4  = [0.0242 0.0242 0.0244 0.0239 0.0241 0.0245 0.0239 0.0248 0.0265 0.0294]; % decision noise = 0.08; surround value = -0.10
ModelThresholdObserver8  = [0.0240 0.0241 0.0235 0.0232 0.0240 0.0237 0.0246 0.0243 0.0260 0.0288]; % decision noise = 0.08; surround value = -0.11
ModelThresholdObserver17 = [0.0245 0.0244 0.0247 0.0246 0.0245 0.0255 0.0265 0.0320 0.0382 0.0509]; % decision noise = 0.11; surround value = -0.16
ModelThresholds          = [0.0248 0.0246 0.0242 0.0245 0.0248 0.0251 0.0255 0.0281 0.0315 0.0386]; %decision noise 18082.2 surround value -0.0119734


figure;
hold on

plot(log10(covScaleModelForMarkers), log10(ModelThresholds.^2), 'linewidth', 2);
plot(log10(covScaleModelForMarkers), log10(ModelThresholdObserver2.^2), 'linewidth', 2);
plot(log10(covScaleModelForMarkers), log10(ModelThresholdObserver4.^2), 'linewidth', 2);
plot(log10(covScaleModelForMarkers), log10(ModelThresholdObserver8.^2), 'linewidth', 2);
plot(log10(covScaleModelForMarkers), log10(ModelThresholdObserver17.^2), 'linewidth', 2);

legend({'Mean Ob', '2', '4','8', '17'},'location', 'northwest');

set(gca, 'fontsize', 20);