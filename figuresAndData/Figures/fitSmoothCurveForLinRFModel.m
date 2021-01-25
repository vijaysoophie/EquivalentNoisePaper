% FT = fittype('a + b.^(x.^c)')
% 
% fit([0 4:12]'/10, logModelThresholdsSq', FT, 'StartPoint', [-4.23 2 3.3])
% 
% ans = 
% 
%      General model:
%      ans(x) = a + b.^(x.^c)
%      Coefficients (with 95% confidence bounds):
%        a =      -4.224  (-4.236, -4.212)
%        b =       1.112  (1.09, 1.133)
%        c =       6.345  (5.368, 7.322)