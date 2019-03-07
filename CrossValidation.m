%十倍交叉验证
%操作说明：
    %当选用单一决策树时，令k=1，将以下注释掉
        %            BackTrainingSet = BackSelectData(TrainingSet, 1);       %有放回的重新采样
    %当选用随机森林时，令k=2*i + 1，将以下注释掉
        %              BackTrainingSet = TrainingSet;        %一颗决策树时，不采用有放回采样
        
%特殊说明：  在绘制决策树时，单一决策树不会出错，但对于森林，可能会报错
        %探索后原因如下：在标注树节点信息时，text函数可能会将4图的信息画到3图上，这个问题没有解决
            %故建议在使用随机森林时将            %PrintTree(tree); 注释掉
            
%使用森林时，时间较长，请耐心等待
%
clear all;
clc;
%%--------------------------  read data  ---------------------------------

File_Train = fopen('mushrooms.csv');
title = textscan(File_Train, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1, 'delimiter', ',');
Data = textscan(File_Train, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 'delimiter', ',');      %已去表头
fclose(File_Train);

m = size(Data{1,1},1);   
%%--------------------  10倍交叉验证 --------------------------
    k = 1;
    randSequence = randperm(m);
    n = size(Data,2);
    NewSet = cell(10, n);
    temp = zeros(10,floor(m/10));
    for i = 1 : 10          %将Data随机均分成10个数据集
        for u = 1: floor(m/10)
            for j = 1:n
                NewSet{i, j}(u,1) = Data{1,j}(randSequence(floor(m/10)*(i - 1) + u),1);
            end
            temp(i, u) = randSequence(floor(m/10)*(i - 1) + u);
        end
    end
    TrainingResult = zeros(9 * floor(m/10), 10, k);
    TestResult = zeros(floor(m/10), 10, k);
    Accuracy = zeros(2,10);
    %进行按序作为测试集，其余作为训练集，进行交叉验证
    for i = 1: 10   %10次交叉测试 
        TestSet = NewSet(i,:);
        TrainingSet = cell(size(Data));
        for u =1: 10    %连接剩余9个，作为训练集
            if(~ (i == u))
                for j = 1:n
                    TrainingSet{1, j} = cat(1, TrainingSet{1, j}, NewSet{u, j});
                end
            end
        end
        for p = 1: k        %k棵决策树
            activeFeature = ones(1, 23);            %记录当前未被选中的特征
            activeFeature(1) = 0;           
            %BackTrainingSet = BackSelectData(TrainingSet, 1);       %有放回的重新采样
            BackTrainingSet = TrainingSet;        %一颗决策树时，不采用有放回采样
            tree = DecisionTree(BackTrainingSet, activeFeature,0,0,0,1);
            %PrintTree(tree);
            TrainingResult(:, p, i) = Judge(BackTrainingSet, tree);
            TestResult(:, p, i) = Judge(TestSet, tree);
        end   
    end
    
    TrainingAccuracy = zeros(9 * floor(m/10),10);
    for i = 1: 10
        for j = 1: (9 * floor(m/10))
            if(sum(TrainingResult(j, :, i)) >= ceil(k/2))
                TrainingAccuracy(j, i) = 1;
            else
                TrainingAccuracy(j, i) = 0;   
            end
        end
        Accuracy(1, i) = sum(TrainingAccuracy(:, i))/(9 * floor(m/10));
    end

    
    TestAccuracy = zeros(floor(m/10),10);
    for i = 1: 10
        for j = 1: floor(m/10)
            if(sum(TestResult(j, :, i)) >= ceil(k/2))
                TestAccuracy(j, i) = 1;
            else
                TestAccuracy(j, i) = 0;   
            end
        end
        Accuracy(2, i) = sum(TestAccuracy(:, i))/ floor(m/10);
    end
    
    x = sort(randperm(10));
    figure, plot(x, Accuracy(1,:), 'b*-', x, Accuracy(2,:), 'r*-');
    legend('TrainingAccuracy', 'TestAccuracy');