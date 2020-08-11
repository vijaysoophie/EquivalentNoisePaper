% Ignore this file. Only Vijay Singh can understand this.
% This file is used to make the proportion comparison .csv file

for ii = 1:length(data.trialStruct.cmpY)
    trialsWithThisCmpLvl = find( data.trialStruct.cmpY(ii) == data.trialStruct.cmpYInTrial);
    numberOfCorrectResponses = (data.response.actualResponse(trialsWithThisCmpLvl) == data.response.correctResponse(trialsWithThisCmpLvl));
    if (data.trialStruct.cmpY(ii) < data.trialStruct.stdY)
        fractionCorrect(ii) = 1 - mean(numberOfCorrectResponses);
        totalCorrectResponse(ii) = length(numberOfCorrectResponses) - sum(numberOfCorrectResponses);
    else
        fractionCorrect(ii) = mean(numberOfCorrectResponses);
        totalCorrectResponse(ii) = sum(numberOfCorrectResponses);
    end
end
thresholds.stimPerLevel = length(numberOfCorrectResponses);

totalCorrectResponse'