function TrainingSet = BackSelectData(Data, percentage)
%�����������������ֱ�������������Ϊѵ�����Ͳ��Լ�
%�зŻز���
%percentage = 0.8;
    m = size(Data{1,1},1);      %��������

    trainNumber = round(m*percentage);      %ѵ����������
    sequence = round(rand(trainNumber,1)*m);
    sequence = sort(sequence);
    
    adjustment = 1;
    while(sequence(adjustment) == 0)
        sequence(adjustment) = 1;
        adjustment = adjustment +1;
    end
    
    n = size(Data,2);
    TrainingSet = cell(size(Data));
    for i = 1: size(sequence,1)
        for j = 1:n
        	TrainingSet{1,j}(i,1) = Data{1,j}(sequence(i),1);
      	end
    end
end