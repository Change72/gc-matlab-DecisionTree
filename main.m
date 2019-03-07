%main.m 主代码脚本
%author: Chang Guo
%data: 05.01.2018

%操作说明：
    %当选用单一决策树时，令k=1，将以下注释掉
        %            BackTrainingSet = BackSelectData(TrainingSet, 1);       %有放回的重新采样
    %当选用随机森林时，令k=2*i + 1，将以下注释掉
        %              BackTrainingSet = TrainingSet;        %一颗决策树时，不采用有放回采样
        
%特殊说明：  在绘制决策树时，单一决策树不会出错，但对于森林，可能会报错
        %探索后原因如下：在标注树节点信息时，text函数可能会将4图的信息画到3图上，这个问题没有解决
            %故建议在使用随机森林时将            %PrintTree(tree); 注释掉
            
%使用森林时，时间较长，请耐心等待


clear all;
clc;
%%--------------------------  read data  ---------------------------------

File_Train = fopen('mushrooms.csv');
title = textscan(File_Train, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1, 'delimiter', ',');
Data = textscan(File_Train, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 'delimiter', ',');      %已去表头
fclose(File_Train);

m = size(Data{1,1},1);

%% ------------------  画出类别与各个特征之间的关系  ---------------------

% for i = 2:23
%     Draw(Data{1,1},Data{1,i});   
% end

%%--------------------------------      Decision Tree      ----------------------------------
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
    TrainingResult(:,i) = Judge(BackTrainingSet, tree);             %测试，返回结果数组
    TestResult(:,i) = Judge(TestSet, tree);
end

for i = 1:TrainingNumber                %对应数组列相加，进行投票
    if(sum(TrainingResult(i,:)) >= ceil(k/2))
        TrainingResult(i, k+1) = 1;
    else
        TrainingResult(i, k+1) = 0;   
    end
end
TrainingAccuracy = sum(TrainingResult(:, k+1))/TrainingNumber;

for i = 1:TestNumber
    if(sum(TestResult(i,:)) >= ceil(k/2))
        TestResult(i, k+1) = 1;
    else
        TestResult(i, k+1) = 0;   
    end
end
TestAccuracy = sum(TestResult(:, k+1))/TestNumber;

fprintf('训练正确率： %d\n', TrainingAccuracy);
fprintf('测试正确率： %d\n', TestAccuracy);
    