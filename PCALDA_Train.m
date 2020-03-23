function [FFACE, PCA, pcaTotalFACE] = PCALDA_Train

people = 40;
% �C�Ӽ˥��� 5
withinsample = 5;
% 32 * 32 == 1024 ������ 50
principlenum = 50;
% �����᪺�V�m�˥�
FFACE = [];
% Ū��
for k = 1:1:people
    for m = 1:2:10
        matchstring = ['ORL3232' '\' num2str(k) '\' num2str(m) '.bmp'];
        matchX = imread(matchstring);
        % matchX �O 32 * 32 ���}�C
        matchX = double(matchX);
        if (k == 1 && m == 1)
            [row, col] = size(matchX);
        end
        matchtempF = [];
        %--arrange the image into a vector
        for n = 1:row
            % ':' means all
            % ',' ���k�䱵
            matchtempF = [matchtempF, matchX(n, :)];
        end
        % ';' ���U����
        % FFACE �ܦ� 200 * 1024
        % MATLAB �D�X�Ӫ� eigenvector �O����
        % �ҥH�ڭ̸�ƥΦ���A���F�n�ۭ�
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
% �����ܲ��q����ն��ܲ��q�[�W�դ��ܲ��q
SST = zeromeanTotalFACE' * zeromeanTotalFACE;
% PCA �O�ܼƦW�٬��� eigenvector
% latent ���� eigenvalue
[PCA, latent] = eig(SST);
% latent �u���﨤�u���ȡA��L���O 0
% �� latent �s���@��
eigvalue = diag(latent);
% ��j�� eigenvalue
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
% ��Ҧ� eigenvector ���Ƨ�
PCA = PCA(:, index);
eigvalue = eigvalue(index);

% projectPCA 1024 * 50
projectPCA = PCA(:, 1:principlenum);
pcaTotalFACE = [];
% 200 ����ƥ����Q���� 50 ��
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