function PrintTree(tree)
    %将建好的树以图形的方式展现出来
        %采用队列，遍历树
        %展示一下内容：
            %节点间的连接关系
            %当前节点特征
            %该特征包含的属性list（double -> char/str）
            %如果在该节点决策完成，返回的值judgement
    global nodeId;
    global nodeSequence;
    global nodeInfo;
    nodeSequence(1) = 0;                  %根节点设为0
    nodeId = 0;                                 %节点位置信息初始化为0
    nodeInfo = cell(3,1);                     %控制返回的信息
            
    if isempty(tree) 
        disp('空树！');
        return ;
    end

    queue = Push([],tree);      
    while(~isempty(queue))          %遍历
         [node,queue] = Pop(queue); % 出队列
         Visit(node, size(queue,2));
         if( ~strcmp(node.firstchild,'null')) % 第一个孩子不为空
            queue = Push(queue,node.firstchild); % 进队
         end
         if( ~strcmp(node.nextsibling,'null')) % 兄弟节点不为空
            queue = Push(queue,node.nextsibling); % 进队
         end
    end
    %画出树
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
    nodeInfo{1, nodeId} = node.name;            %访问节点信息
    nodeInfo{2, nodeId} = node.brotherList;
    nodeInfo{3, nodeId} = node.judgement;
    if(~strcmp(node.firstchild,'null') && ~strcmp(node.nextsibling,'null'))       %如果既有孩子也有兄弟
        nodeSequence(nodeId + queueLength + 1) = nodeId;
        nodeSequence(nodeId + queueLength + 2) = nodeSequence(nodeId);
    elseif(~strcmp(node.firstchild,'null'))         %只有孩子，没有兄弟
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
        disp('队列为空，不能访问！');
        return;
    end

    item = queue(1); % 第一个元素弹出
    newQueue=queue(2:end); % 往后移动一个元素位置
end