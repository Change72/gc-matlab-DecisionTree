%ROC曲线绘制——单个2层决策树
clear all;
clc;
%%--------------------------  read data  ---------------------------------

File_Train = fopen('mushrooms.csv');
title = textscan(File_Train, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1, 'delimiter', ',');
Data = textscan(File_Train, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 'delimiter', ',');      %已去表头
fclose(File_Train);

m = size(Data{1,1},1);

%%--------------------------------      Decision Tree      ----------------------------------
rocNumber = 6;
TestAccuracy = zeros(1, rocNumber);
TestError= zeros(1, rocNumber);

for j = 1: rocNumber
    %随机选取80%作为训练集，20%作为测试集
    [TrainingSet, TestSet] = SelectData(Data, 0.8);
    k = 1;                  %随机森林中决策树的个数
    [TrainingNumber, ~] = size(TrainingSet{1,1});
    [TestNumber, ~] = size(TestSet{1,1});
    TrainingResult = zeros(TrainingNumber, k+1);
    TestResult = zeros(TestNumber, k+1);

    for i = 1:k                             %for  2p+1次（保证奇数）
        %有放回取样作为训练样本，训练多个决策树进行表决，构成随机森林
        %BackTrainingSet = BackSelectData(TrainingSet, 1);       %有放回的重新采样
        BackTrainingSet = TrainingSet;        %一颗决策树时，不采用有放回采样
        activeFeature = ones(1, 23);            %记录当前未被选中的特征
        activeFeature(1) = 0;           
        tree = DecisionTree(BackTrainingSet, activeFeature,0,0,0,1);            %建树
        %PrintTree(tree);
        for p = 1:TestNumber
            node = tree;
            while(~strcmp(node.name, 'null'))
                feature = node.name;
                n = size(node.brotherList, 1);
                location = 1;
                while((~strcmp(TestSet{1, feature}(p), node.brotherList(location))))
                    location = location + 1;
                    if(location > n)
                        break;
                    end
                end
                if(location <= n)     %在字母表中找到了，继续向下走
                    node = node.firstchild;
                    while(location > 1)
                        location = location - 1;
                        node = node.nextsibling;
                    end
                end           
            end
            if(strcmp(node.judgement, 'true') && strcmp(TestSet{1,1}(p),'e'))
                TestResult(p,1) = 1;
            elseif(strcmp(node.judgement, 'true') && strcmp(TestSet{1,1}(p),'p'))
                TestResult(p,2) = 1;
            end
        end
    end


    TestAccuracy(1, j) = sum(TestResult(:, 1))/TestNumber;
    TestError(1, j) = sum(TestResult(:, 2))/TestNumber;

    fprintf('测试错误率： %d\n', TestError(1, j));
    fprintf('测试正确率： %d\n', TestAccuracy(1, j));
end

figure, plot(TestError, TestAccuracy, 'r*-');