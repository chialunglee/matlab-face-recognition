function [correct] = PCALDA_Test(projectPCA, LDA, prototypeFACE, TotalMeanFACE)
    principlenum = 50;
    % 再次降維成你想要的維度
    ldanum = 50;
    
    people = 40;
    withinsample = 5;
    totalcount = 0;
    correct = 0;
    projectLDA = LDA(:, 1:1:ldanum);
    % Testing begin
    for i = 1:1:people
        for j = 2:2:10
            totalcount = totalcount + 1;
            tempF = [];
            s = ['ORL3232' '\' num2str(i) '\' num2str(j) '.bmp'];
            test = imread(s);
            [row, col] = size(test);
            test = double(test);
            for k = 1:1:row
                tempF = [tempF, test(k, :)];
            end
            tempF = tempF - TotalMeanFACE;
            % row
            tempF = tempF * projectPCA;
            resultF = tempF * projectLDA;
            mindistanceFinal = Inf;
            
            for k = 1:withinsample:people * withinsample
                mindistanceF = Inf;
                % Nearest neighbor
                for p = k:1:(k - 1 + withinsample)
                    OAF = resultF - prototypeFACE(p, :);
                    Eucdis = OAF * OAF';
                    if (Eucdis < mindistanceF)
                        mindistanceF = Eucdis;
                    end