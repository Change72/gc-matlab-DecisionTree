%ROC���߻��ơ�������2�������
clear all;
clc;
%%--------------------------  read data  ---------------------------------

File_Train = fopen('mushrooms.csv');
title = textscan(File_Train, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1, 'delimiter', ',');
Data = textscan(File_Train, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 'delimiter', ',');      %��ȥ��ͷ
fclose(File_Train);

m = size(Data{1,1},1);

%%--------------------------------      Decision Tree      ----------------------------------
rocNumber = 6;
TestAccuracy = zeros(1, rocNumber);
TestError= zeros(1, rocNumber);

for j = 1: rocNumber
    %���ѡȡ80%��Ϊѵ������20%��Ϊ���Լ�
    [TrainingSet, TestSet] = SelectData(Data, 0.8);
    k = 1;                  %���ɭ���о������ĸ���
    [TrainingNumber, ~] = size(TrainingSet{1,1});
    [TestNumber, ~] = size(TestSet{1,1});
    TrainingResult = zeros(TrainingNumber, k+1);
    TestResult = zeros(TestNumber, k+1);

    for i = 1:k                             %for  2p+1�Σ���֤������
        %�зŻ�ȡ����Ϊѵ��������ѵ��������������б�����������ɭ��
        %BackTrainingSet = BackSelectData(TrainingSet, 1);       %�зŻص����²���
        BackTrainingSet = TrainingSet;        %һ�ž�����ʱ���������зŻز���
        activeFeature = ones(1, 23);            %��¼��ǰδ��ѡ�е�����
        activeFeature(1) = 0;           
        tree = DecisionTree(BackTrainingSet, activeFeature,0,0,0,1);            %����
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
                if(location <= n)     %����ĸ�����ҵ��ˣ�����������
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

    fprintf('���Դ����ʣ� %d\n', TestError(1, j));
    fprintf('������ȷ�ʣ� %d\n', TestAccuracy(1, j));
end

figure, plot(TestError, TestAccuracy, 'r*-');