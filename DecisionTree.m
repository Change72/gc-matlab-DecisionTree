function [tree] = DecisionTree(Data, activeFeature, lastFeature, list, layer, brotherNumber)
%%DecisionTree.m  ����ID3 �ľ�����
%�ο���http://blog.csdn.net/lfdanding/article/details/50753239

%�������̣�
    %�������ڽ��������õ���Ҫ�������Ҳ���
    %ͬһ���������δ�����������¼��һ������������һ��ڵ����·��ࣩ
        %Data��Ϊ��һ����������ݣ��������£����ú����ֵܱ�ʾ����Ҫ��֤�ֵܼ����ݵ�һ���ԣ�
            %������ÿ���ڵ�����ݽ��и���
    %��ô�����ݽڵ㣿 list�����ϲ��ֵ��б�layer���������brotherNumber�ֵ�ʣ�������
        %�ֵ�ʣ���������˳����Ϊ�뽨���list˳����ͬ�������ڽ��������У�ͬһ���������һ�£�
    %���ǿ��Ƶݹ������gainsֵ�����������Ĵ�С

    
%���������
    %Data: ��һ�������
    %activeFeature: ������Ծ�����δ����node��Ϊ1��elseΪ0
    %lastFeature����һ��ѡ�������������ݸ��������ֵ��ж��������·���
    %list�������ϲ��ֵ��б�һά���飬��Ҫʱתchar��
    %layer���������
    %brotherNumber��Ŀǰ�������ֵܽڵ�λ��
        %��� brotherNumber == size(list); �ֵܲ㽨�����
    
%���������
    %tree�� ���ڵ�
        
%% ǰ���ж�
    if(isempty(Data))
        error('�ṩ�����ݼ�Ϊ�գ�');
    end

    %�������ڵ㣨�����ֵܱ�ʾ����
        %name: �ڵ�������ţ�����ʱ���brotherList�Ҳ�����Ӧ����������judgement��    
        %չʾ����ÿһ������ʱ����ͼ�ڼ�ͷ�ϣ������ڽڵ��������Ʊ�ע
        %brotherList: ��¼�ýڵ��������м������ԣ������鼴�ɣ������ֵ��б�
        %judgement: ��¼�ýڵ㷵��ֵ��������������ж��������߲���ȥ�˷��ص�ֵ��
            % �涨��true ��ʾ ��ʳ�õģ�edible����flase ��ʾ �ж��ģ�poisonous��
    tree = struct('name', 'null', 'firstchild', 'null', 'nextsibling', 'null', 'brotherList', 'null', 'judgement', 'null');
 
    %brother
    if(brotherNumber < size(list,1) && layer ~= 0)
        tree.nextsibling = DecisionTree(Data, activeFeature, lastFeature, list, layer, brotherNumber+1);
    end
%% ������һ������ݸ��±��ڵ����ݣ�newData

% list = title{2,2}(:,1);
% brotherNumber = 2;
% lastFeature = 2;
% layer = 1;
    n = size(Data,2);       %������Ŀ
    if(layer ~= 0)
        newData = cell(size(Data));     %���ڵ�����
        [m,~] = size(Data{1,1});    %��һ�����������
        property = list(brotherNumber);       %��������
        newDataNumber = 0;  %���ڵ�������Ŀ
        for i = 1:m
            if(abs(cell2mat(Data{1, lastFeature}(i))) == property)
                newDataNumber = newDataNumber + 1;
                for j = 1:n
                    newData{1,j}(newDataNumber,1) = Data{1,j}(i,1);
                end
            end
        end
    else
        newData = Data;
    end

%% �Ե�ǰ�ڵ�������Ϣ���д�����������

    %Ϊ�����������ݽ���ͳ�Ʒ��࣬һ��cell����¼ÿ��������info����
    Handling = cell(3,n);  %��һ����������optional�����ڶ��ж�ά������Ϣ��������������
    info = Statistics(newData{1,1}, newData{1,1});  %ͳ����Ϣ
    [m,~] = size(info);     %ͳ������������ֻ��һ����ֱ����ΪҶ�ӽڵ�
    
    %���õ�ǰ�ķ����������ʼ��judgement
    if(sum(info(:,2)) >= sum(info(:,3)))
        tree.judgement = 'true';
    else
        tree.judgement = 'false';
    end
    
    tree.brotherList = char(list(brotherNumber));
    
    %���ֻ��һ�� ���� �Ѿ�û�л�����ԣ���ΪҶ�ӽڵ�����ݹ�
        %ע�⣺Ҷ�ӽڵ�û��firstchild�������ֵ�(ע�⹹���ֵ���������)
    if(m == 1 || sum(activeFeature) == 0)      %����ʼ��activeFeatureʱ���ǵý���һ�У�����У�Ϊ0��
        return;
    end
    
    if(layer > 1)
        return;
    end
    
    %��ǰ�������κ�����ʱ���ز�����
    entropy = info(1,7)*log2(info(1,7))+info(2,7)*log2(info(2,7)); 
    Handling{2,1} = info;
    Handling{3,1} = - entropy;
    
%% �Ե���active�������������ز����ȣ���Ѱ���������

    gains = zeros(1,n);        %��������
   
    for i = 2:n
        if(activeFeature(i))
        %info=Statistics(class,feature);
        %���㵱ǰ���Ե���
            %�ο�ģʽʶ��̲�       
            info = Statistics(newData{1,1}, newData{1,i});
            m=size(info,1);   
            entropy=0;   
            for j = 1:m
                if(info(j,5)~=0 && info(j,6)~=0)
                    entropy = entropy + info(j,7)*(info(j,5)*log2(info(j,5))+info(j,6)*log2(info(j,6)));
                end
            end    
            Handling{2,i} = info;
            Handling{3,i} = - entropy;       
            gains(i) = Handling{3,1} - Handling{3,i};
        end
    end
    
 %% ���������Ϣ���棬���õ�ǰ�ڵ�   
 
    [~, bestFeature] = max(gains);
    tree.name = bestFeature;
    activeFeature(bestFeature) = 0;
    tree.brotherList = char(Handling{2, bestFeature}(:,1));
    
 %% ���ú����ڵ㣬���еݹ�
 
    %child
    tree.firstchild = DecisionTree(newData, activeFeature, bestFeature, Handling{2, bestFeature}(:,1), layer+1, 1);
    %��activeFeature �ȴ��ֵܵģ���Ϊ�ֵ�����һ��ģ�����activeFeature�ı�
    
end