function [FFACE, PCA, pcaTotalFACE, tempSSW, finalEigVector, finalEigValue, allGroupMean, projectPCA] = PCALDA_Train()
    % 有 40 個人
    people = 40;
    % 每個樣本取 5
    withinsample = 5;
    % 32 * 32 == 1024 降維到 50
    principlenum = 50;
    fileName = ['ORL3232' '\' '1' '\' '1' '.bmp'];
    [imageHeight, imageWidth] = size(imread(fileName));
    % 訓練資料 startFrom == 1, 測試資料 startFrom == 2
    startFrom = 1;
    % 降維後的訓練樣本
    % FFACE 變成 200 * 1024
    FFACE = readImage(imageHeight, imageWidth, people, withinsample, startFrom);
    % output 1 * 1024
    zeromeanTotalFACE = calculateZeroMean(FFACE);

    % pcaSST = cov(zeromeanTotalFACE);
    % "'" Transpose
    % SST == SSB + SSW
    % 全部變異量等於組間變異量加上組內變異量
    SST = zeromeanTotalFACE' * zeromeanTotalFACE;
    % PCA 是變數名稱紀錄 eigenvector
    % latent 紀錄 eigenvalue
    [PCA, latent] = eig(SST);
    % latent 只有對角線有值，其他都是 0
    % 把 latent 存成一維
    eigvalue = diag(latent);
    % 找大的 eigenvalue
    % ex. [5, 2, 1, 4] index [1, 2, 3, 4]
    % junk == [5, 4, 2, 1]
    % index == [1, 4, 2, 3]
    [junk, index] = sort(eigvalue, 'descend');
    % 0.1 0.3 0.3 0.1
    % 0.2 0.4 0.7 0.8
    %index 1, 4
    % PCA
    % 0.1 0.1
    % 0.2 0.8
    % 對所有 eigenvector 做排序
    PCA = PCA(:, index);
    eigvalue = eigvalue(index);

    % projectPCA 1024 * 50
    projectPCA = PCA(:, 1:principlenum);
    pcaTotalFACE = [];
    % 200 筆資料全部被降成 50 維
    for i = 1:1:withinsample * people
        tempFACE = zeromeanTotalFACE(i, :);
        tempFACE = tempFACE * projectPCA;
        pcaTotalFACE = [pcaTotalFACE; tempFACE];
    end

    % groupset 5 * 50
    % pcaTotalFACE(1:1:5, :)
    tempSSW = zeros(50, 50);
    allGroupMean = [];
    for i = 1:withinsample:people * withinsample
        tempMean = mean(pcaTotalFACE(i:1:i + withinsample - 1, :));
        pcaTotalFACE(i:1:i + withinsample - 1, :) = calculateZeroMean(pcaTotalFACE(i:1:i + withinsample - 1, :));
        allGroupMean = [allGroupMean; tempMean];
        tempSSW = tempSSW + (pcaTotalFACE(i:1:i + withinsample - 1, :)' * pcaTotalFACE(i:1:i + withinsample - 1, :));
    end

    zeroAllGroupMean = calculateZeroMean(allGroupMean);
    SSB = zeroAllGroupMean' * zeroAllGroupMean;

    finalCov = inv(tempSSW) * SSB;

    [finalEigVector, finalEigValue] = eig(finalCov);

    % 沒 zeromean
    %{
    for i=1:withinsample:withinsample*people
        withinFACE = pcaTotalFACE(i:i + withinsample - 1, :);
        if (i == 1)
            SW = withinFACE' * withinFACE;
            ClassMean = mean(withinFACE);
        end
        if (i > 1)
            SW = SW + withinFACE' * withinFACE;
            ClassMean = [ClassMean;mean(withinFACE)];
        end
    end
    pcaTotalmean = mean(pcaTotalFACE);
    SB = ClassMean' * ClassMean;
    %}
end
