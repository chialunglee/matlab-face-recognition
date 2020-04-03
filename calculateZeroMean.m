function [zeroMeanOfAllDataSet] = calculateZeroMean(allDataSet)
    meanOfAllDataSet = mean(allDataSet);
    zeroMeanOfAllDataSet = allDataSet - meanOfAllDataSet;
end