function [correct] = PCALDA_Test(projectPCA, LDAVector, allGroupMean)
    principlenum = 50;
    % 再次降維成你想要的維度
    ldanum = 50;
    
    people = 40;
    withinsample = 5;
    totalcount = 0;
    correct = 0;
    projectLDA = LDAVector(:, 1:1:ldanum);
    fileName = ['ORL3232' '\' '1' '\' '2' '.bmp'];
    [imageHeight, imageWidth] = size(imread(fileName));
    % 訓練資料 startFrom == 1, 測試資料 startFrom == 2
    startFrom = 2;
    TestFFACE = readImage(imageHeight, imageWidth, people, withinsample, startFrom);
    pcaTestTotalFACE = TestFFACE * projectPCA;
    
    % sqrt(sum((A - B).^2));
    % sqrt(sum((pcaTestTotalFACE(x, :) - allGroupMean(y, :)).^2));
    fortyDistance = zeros(1, 40);
    
    for i = 1:1:people * withinsample
        totalcount = totalcount + 1;
        for j = 1:1:people
            fortyDistance(j) = sqrt(sum((pcaTestTotalFACE(i, :) - allGroupMean(j, :)).^2));
        end
        [~, maxIndex] = max(fortyDistance);
        if (floor(i / withinsample) + 1 == maxIndex)
            correct = correct + 1;
        end
    end
    correct = correct / totalcount;
    
    
    
    
%     for i = 1:1:people
%         for j = 2:2:10
%             theData = pcaTestTotalFACE((i - 1) * withinsample + (j - startFrom) / 2 + 1, :)
%             for k = 1:1:people
%                 for m = 1:1:50
%                     distanceSquare = (allGroupMean(k, m) - theData(m))^2
            
    % Testing begin
%     for i = 1:1:people
%         for j = 2:2:10
%             totalcount = totalcount + 1;
%             tempF = [];
%             s = ['ORL3232' '\' num2str(i) '\' num2str(j) '.bmp'];
%             test = imread(s);
%             [row, col] = size(test);
%             test = double(test);
%             for k = 1:1:row
%                 tempF = [tempF, test(k, :)];
%             end
%             tempF = tempF - TotalMeanFACE;
%             % row
%             tempF = tempF * projectPCA;
%             resultF = tempF * projectLDA;
%         end
%     end
end
%             mindistanceFinal = Inf;
%             
%             for k = 1:withinsample:people * withinsample
%                 mindistanceF = Inf;
%                 % Nearest neighbor
%                 for p = k:1:(k - 1 + withinsample)
%                     OAF = resultF - prototypeFACE(p, :);
%                     Eucdis = OAF * OAF';
%                     if (Eucdis < mindistanceF)
%                         mindistanceF = Eucdis;
%                     end