function result = Judge(TestSet, tree)
% ���Ժ��������ݴ������Ĳ��Լ������������ж��Ƿ������ȷ

    m = size(TestSet{1,1},1);
    result = zeros(m,1);    %��һ��Ϊ1��0
    %ʶ������
    %�������б���Ѱ�Ҷ�Ӧ��
        %����У�������
        %���û�У����ص�ǰjudgement

    for i = 1:m
        node = tree;
        while(~strcmp(node.name, 'null'))
            feature = node.name;
            n = size(node.brotherList, 1);
            location = 1;
            while((~strcmp(TestSet{1, feature}(i), node.brotherList(location))))
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
        if(strcmp(node.judgement, 'true') && strcmp(TestSet{1,1}(i),'e'))
            result(i,1) = 1;
        elseif(strcmp(node.judgement, 'false') && strcmp(TestSet{1,1}(i),'p'))
            result(i,1) = 1;
        end
    end
end