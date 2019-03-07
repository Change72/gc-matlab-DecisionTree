function PrintTree(tree)
    %�����õ�����ͼ�εķ�ʽչ�ֳ���
        %���ö��У�������
        %չʾһ�����ݣ�
            %�ڵ������ӹ�ϵ
            %��ǰ�ڵ�����
            %����������������list��double -> char/str��
            %����ڸýڵ������ɣ����ص�ֵjudgement
    global nodeId;
    global nodeSequence;
    global nodeInfo;
    nodeSequence(1) = 0;                  %���ڵ���Ϊ0
    nodeId = 0;                                 %�ڵ�λ����Ϣ��ʼ��Ϊ0
    nodeInfo = cell(3,1);                     %���Ʒ��ص���Ϣ
            
    if isempty(tree) 
        disp('������');
        return ;
    end

    queue = Push([],tree);      
    while(~isempty(queue))          %����
         [node,queue] = Pop(queue); % ������
         Visit(node, size(queue,2));
         if( ~strcmp(node.firstchild,'null')) % ��һ�����Ӳ�Ϊ��
            queue = Push(queue,node.firstchild); % ����
         end
         if( ~strcmp(node.nextsibling,'null')) % �ֵܽڵ㲻Ϊ��
            queue = Push(queue,node.nextsibling); % ����
         end
    end
    %������
    figure, treeplot(nodeSequence);
    [x,y] = treelayout(nodeSequence);
    x = x';
    y = y';
    name = nodeInfo(1,:);
    list = nodeInfo(2,:);
    judgement = nodeInfo(3,:);
    for i = 1:size(name,2)
        if(strcmp(name{1,i},'null'))
            name{1,i} = [];
        else
            list{1,i} = list{1,i}';
        end
    end
    text(x(:,1) + 0.01, y(:,1), name', 'VerticalAlignment','bottom','HorizontalAlignment','left')
    text(x(:,1) - 0.01, y(:,1), list, 'VerticalAlignment','bottom','HorizontalAlignment','right')
    text(x(:,1) + 0.005, y(:,1) - 0.04, judgement, 'VerticalAlignment','bottom','HorizontalAlignment','right')
    title({'Decision Tree'},'FontSize',12,'FontName','Times New Roman');       
    
end

function Visit(node, queueLength)
    global nodeId;
    global nodeSequence;
    global nodeInfo;
    nodeId = nodeId + 1;
    nodeInfo{1, nodeId} = node.name;            %���ʽڵ���Ϣ
    nodeInfo{2, nodeId} = node.brotherList;
    nodeInfo{3, nodeId} = node.judgement;
    if(~strcmp(node.firstchild,'null') && ~strcmp(node.nextsibling,'null'))       %������к���Ҳ���ֵ�
        nodeSequence(nodeId + queueLength + 1) = nodeId;
        nodeSequence(nodeId + queueLength + 2) = nodeSequence(nodeId);
    elseif(~strcmp(node.firstchild,'null'))         %ֻ�к��ӣ�û���ֵ�
        nodeSequence(nodeId + queueLength + 1) = nodeId;
    elseif(~strcmp(node.nextsibling,'null'))
        nodeSequence(nodeId + queueLength + 1) = nodeSequence(nodeId);
    end
end

function newQueue = Push(queue, item)
    newQueue = [queue, item];
end

function [item, newQueue] = Pop(queue)
    if isempty(queue)
        disp('����Ϊ�գ����ܷ��ʣ�');
        return;
    end

    item = queue(1); % ��һ��Ԫ�ص���
    newQueue=queue(2:end); % �����ƶ�һ��Ԫ��λ��
end