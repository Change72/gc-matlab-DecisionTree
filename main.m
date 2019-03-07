%main.m ������ű�
%author: Chang Guo
%data: 05.01.2018

%����˵����
    %��ѡ�õ�һ������ʱ����k=1��������ע�͵�
        %            BackTrainingSet = BackSelectData(TrainingSet, 1);       %�зŻص����²���
    %��ѡ�����ɭ��ʱ����k=2*i + 1��������ע�͵�
        %              BackTrainingSet = TrainingSet;        %һ�ž�����ʱ���������зŻز���
        
%����˵����  �ڻ��ƾ�����ʱ����һ�������������������ɭ�֣����ܻᱨ��
        %̽����ԭ�����£��ڱ�ע���ڵ���Ϣʱ��text�������ܻὫ4ͼ����Ϣ����3ͼ�ϣ��������û�н��
            %�ʽ�����ʹ�����ɭ��ʱ��            %PrintTree(tree); ע�͵�
            
%ʹ��ɭ��ʱ��ʱ��ϳ��������ĵȴ�


clear all;
clc;
%%--------------------------  read data  ---------------------------------

File_Train = fopen('mushrooms.csv');
title = textscan(File_Train, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1, 'delimiter', ',');
Data = textscan(File_Train, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 'delimiter', ',');      %��ȥ��ͷ
fclose(File_Train);

m = size(Data{1,1},1);

%% ------------------  ����������������֮��Ĺ�ϵ  ---------------------

% for i = 2:23
%     Draw(Data{1,1},Data{1,i});   
% end

%%--------------------------------      Decision Tree      ----------------------------------
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
    TrainingResult(:,i) = Judge(BackTrainingSet, tree);             %���ԣ����ؽ������
    TestResult(:,i) = Judge(TestSet, tree);
end

for i = 1:TrainingNumber                %��Ӧ��������ӣ�����ͶƱ
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

fprintf('ѵ����ȷ�ʣ� %d\n', TrainingAccuracy);
fprintf('������ȷ�ʣ� %d\n', TestAccuracy);
    