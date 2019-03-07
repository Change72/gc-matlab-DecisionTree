function [TrainingSet,TestSet] = SelectData(Data, percentage)
%�����������������ֱ�������������Ϊѵ�����Ͳ��Լ�
%�޷Żز���
%percentage = 0.8;
    m = size(Data{1,1},1);      %��������

    trainNumber = round(m*percentage);      %ѵ����������
    sequence = round(rand(trainNumber,1)*m);
    sequence = sort(sequence);
    lastNumber = 0;         %�������ȡ���������ȥ�ز���
    for i = 1:trainNumber
        if(sequence(i)<=lastNumber)
            sequence(i) = lastNumber + 1;
        end
        lastNumber = sequence(i);
    end
    
    n = size(Data,2);
    TrainingSet = cell(size(Data));
    TestSet = cell(size(Data));
    lastNumber = 1;         %����ȥ�غ�����飬��ԭʼ���ݷֿ�
    TrainingNumber = 0;
    TextNumber = 0;
    for i = 1:m
        if(lastNumber <= trainNumber && i == sequence(lastNumber))
            lastNumber = lastNumber + 1;
            TrainingNumber = TrainingNumber + 1;
            for j = 1:n
                TrainingSet{1,j}(TrainingNumber,1) = Data{1,j}(i,1);
            end
        else
            TextNumber = TextNumber + 1;
            for j = 1:n
                TestSet{1,j}(TextNumber,1) = Data{1,j}(i,1);
            end
        end
    end
c=0;
end