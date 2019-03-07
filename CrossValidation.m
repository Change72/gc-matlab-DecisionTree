%ʮ��������֤
%����˵����
    %��ѡ�õ�һ������ʱ����k=1��������ע�͵�
        %            BackTrainingSet = BackSelectData(TrainingSet, 1);       %�зŻص����²���
    %��ѡ�����ɭ��ʱ����k=2*i + 1��������ע�͵�
        %              BackTrainingSet = TrainingSet;        %һ�ž�����ʱ���������зŻز���
        
%����˵����  �ڻ��ƾ�����ʱ����һ�������������������ɭ�֣����ܻᱨ��
        %̽����ԭ�����£��ڱ�ע���ڵ���Ϣʱ��text�������ܻὫ4ͼ����Ϣ����3ͼ�ϣ��������û�н��
            %�ʽ�����ʹ�����ɭ��ʱ��            %PrintTree(tree); ע�͵�
            
%ʹ��ɭ��ʱ��ʱ��ϳ��������ĵȴ�
%
clear all;
clc;
%%--------------------------  read data  ---------------------------------

File_Train = fopen('mushrooms.csv');
title = textscan(File_Train, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1, 'delimiter', ',');
Data = textscan(File_Train, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 'delimiter', ',');      %��ȥ��ͷ
fclose(File_Train);

m = size(Data{1,1},1);   
%%--------------------  10��������֤ --------------------------
    k = 1;
    randSequence = randperm(m);
    n = size(Data,2);
    NewSet = cell(10, n);
    temp = zeros(10,floor(m/10));
    for i = 1 : 10          %��Data������ֳ�10�����ݼ�
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
    %���а�����Ϊ���Լ���������Ϊѵ���������н�����֤
    for i = 1: 10   %10�ν������ 
        TestSet = NewSet(i,:);
        TrainingSet = cell(size(Data));
        for u =1: 10    %����ʣ��9������Ϊѵ����
            if(~ (i == u))
                for j = 1:n
                    TrainingSet{1, j} = cat(1, TrainingSet{1, j}, NewSet{u, j});
                end
            end
        end
        for p = 1: k        %k�þ�����
            activeFeature = ones(1, 23);            %��¼��ǰδ��ѡ�е�����
            activeFeature(1) = 0;           
            %BackTrainingSet = BackSelectData(TrainingSet, 1);       %�зŻص����²���
            BackTrainingSet = TrainingSet;        %һ�ž�����ʱ���������зŻز���
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