function [FFACE, PCA, pcaTotalFACE] = PCALDA_Train

people = 40;
% 每個樣本取 5
withinsample = 5;
% 32 * 32 == 1024 降維到 50
principlenum = 50;
% 降維後的訓練樣本
FFACE = [];
% 讀圖
for k = 1:1:people
    for m = 1:2:10
        matchstring = ['ORL3232' '\' num2str(k) '\' num2str(m) '.bmp'];
        matchX = imread(matchstring);
        % matchX 是 32 * 32 的陣列
        matchX = double(matchX);
        if (k == 1 && m == 1)
            [row, col] = size(matchX);
        end
        matchtempF = [];
        %--arrange the image into a vector
        for n = 1:row
            % ':' means all
            % ',' 往右邊接
            matchtempF = [matchtempF, matchX(n, :)];
        end
        % ';' 往下面接
        % FFACE 變成 200 * 1024
        % MATLAB 求出來的 eigenvector 是直的
        % 所以我們資料用成橫的，為了要相乘
        FFACE = [FFACE; matchtempF];
    end
end
% output 1 * 1024
TotalMeanFACE = mean(FFACE);
zeromeanTotalFACE = FFACE;

for i = 1:1:withinsample * people
    for j = 1:1:(row) * (col)
        zeromeanTotalFACE(i, j) = zeromeanTotalFACE(i, j) - TotalMeanFACE(j);
    end
end
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

% cov = [];
for i = 1:1:people
    withinFACE = pcaTotalFACE(i:i+4, :);
    groupmean = mean(withinFACE);
    fprintf('%iHello\n', i);
    disp(withinFACE);
end