function [TrainingSet,TestSet] = SelectData(Data, percentage)
%根据输入样本及划分比例，将样本分为训练集和测试集
%无放回采样
%percentage = 0.8;
    m = size(Data{1,1},1);      %样本总数

    trainNumber = round(m*percentage);      %训练样本总数
    sequence = round(rand(trainNumber,1)*m);
    sequence = sort(sequence);
    lastNumber = 0;         %对随机抽取的数组进行去重操作
    for i = 1:trainNumber
        if(sequence(i)<=lastNumber)
            sequence(i) = lastNumber + 1;
        end
        lastNumber = sequence(i);
    end
    
    n = size(Data,2);
    TrainingSet = cell(size(Data));
    TestSet = cell(size(Data));
    lastNumber = 1;         %利用去重后的数组，将原始数据分开
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