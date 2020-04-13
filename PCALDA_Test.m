function [correct] = PCALDA_Test(FFACE, projectPCA, finalEigVector)
    % 再次降維成你想要的維度
    ldanum = 50;
    
    people = 40;
    withinsample = 5;
    totalcount = 0;
    correct = 0;
    projectLDA = finalEigVector(:, 1:1:ldanum);
    fileName = ['ORL3232' '\' '1' '\' '2' '.bmp'];
    [imageHeight, imageWidth] = size(imread(fileName));
    % 訓練資料 startFrom == 1, 測試資料 startFrom == 2
    startFrom = 2;
    TestFFACE = readImage(imageHeight, imageWidth, people, withinsample, startFrom);
    zeroMeanTestFACE = TestFFACE - mean(FFACE);
    pcaTestTotalFACE = zeroMeanTestFACE * projectPCA;
    ldaTestTotalFACE = pcaTestTotalFACE * projectLDA;
    zeroMeanFACE = FFACE - mean(FFACE);
    pcaTrainTotalFACE = zeroMeanFACE * projectPCA;
    ldaTrainTotalFACE = pcaTrainTotalFACE * projectLDA;
    
    % sqrt(sum((A - B).^2));
    fortyDistance = zeros(1, 200);
    
    for i = 1:1:people * withinsample
        totalcount = totalcount + 1;
        for j = 1:1:people * withinsample
            fortyDistance(j) = sqrt(sum((ldaTestTotalFACE(i, :) - ldaTrainTotalFACE(j, :)).^2));
        end
        [~, minIndex] = min(fortyDistance);
        if (floor((i + 4) / withinsample) == floor((minIndex + 4) / withinsample))
            correct = correct + 1;
        end
    end
    correct = correct / totalcount;
end