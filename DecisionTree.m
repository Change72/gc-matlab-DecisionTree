function [tree] = DecisionTree(Data, activeFeature, lastFeature, list, layer, brotherNumber)
%%DecisionTree.m  基于ID3 的决策树
%参考：http://blog.csdn.net/lfdanding/article/details/50753239

%建树过程：
    %函数用于建树，建好的树要用来查找测试
    %同一层的数据如何传？？？（记录上一层特征，在下一层节点重新分类）
        %Data：为上一层的特征数据（理由如下：采用孩子兄弟表示法后，要保证兄弟间数据的一致性）
            %所以在每个节点对数据进行更新
    %怎么建数据节点？ list管理上层兄弟列表，layer管理层数，brotherNumber兄弟剩余个数）
        %兄弟剩余个数暗含顺序，因为与建表的list顺序相同（本着在建树过程中，同一组遍历方法一致）
    %考虑控制递归层数、gains值，来控制树的大小

    
%输入参数：
    %Data: 上一层的数据
    %activeFeature: 特征活跃情况，未建立node的为1，else为0
    %lastFeature：上一层选出的特征，根据该特征在兄弟中对数据重新分组
    %list：管理上层兄弟列表（一维数组，需要时转char）
    %layer：管理层数
    %brotherNumber：目前建立的兄弟节点位置
        %如果 brotherNumber == size(list); 兄弟层建立完成
    
%输出参数：
    %tree： 树节点
        
%% 前期判断
    if(isempty(Data))
        error('提供的数据集为空！');
    end

    %创建树节点（孩子兄弟表示法）
        %name: 节点特征序号，搜索时如果brotherList找不到对应特征，返回judgement；    
        %展示具体每一个特征时，画图在箭头上，或者在节点另设名称标注
        %brotherList: 记录该节点特征中有几个属性，传数组即可，本层兄弟列表
        %judgement: 记录该节点返回值（即如果不满足判断条件，走不下去了返回的值）
            % 规定：true 表示 可食用的（edible）；flase 表示 有毒的（poisonous）
    tree = struct('name', 'null', 'firstchild', 'null', 'nextsibling', 'null', 'brotherList', 'null', 'judgement', 'null');
 
    %brother
    if(brotherNumber < size(list,1) && layer ~= 0)
        tree.nextsibling = DecisionTree(Data, activeFeature, lastFeature, list, layer, brotherNumber+1);
    end
%% 利用上一层的数据更新本节点数据：newData

% list = title{2,2}(:,1);
% brotherNumber = 2;
% lastFeature = 2;
% layer = 1;
    n = size(Data,2);       %特征数目
    if(layer ~= 0)
        newData = cell(size(Data));     %本节点数据
        [m,~] = size(Data{1,1});    %上一层的数据数量
        property = list(brotherNumber);       %本层属性
        newDataNumber = 0;  %本节点数据数目
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

%% 对当前节点的类别信息进行处理（无特征）

    %为传进来的数据进行统计分类，一个cell来记录每个特征的info及熵
    Handling = cell(3,n);  %第一行特征名（optional），第二行二维数组信息，第三行特征熵
    info = Statistics(newData{1,1}, newData{1,1});  %统计信息
    [m,~] = size(info);     %统计类别数，如果只有一类则直接作为叶子节点
    
    %利用当前的分类情况，初始化judgement
    if(sum(info(:,2)) >= sum(info(:,3)))
        tree.judgement = 'true';
    else
        tree.judgement = 'false';
    end
    
    tree.brotherList = char(list(brotherNumber));
    
    %如果只有一类 或者 已经没有活动的属性，作为叶子节点结束递归
        %注意：叶子节点没有firstchild，但有兄弟(注意构建兄弟树！！！)
    if(m == 1 || sum(activeFeature) == 0)      %（初始化activeFeature时，记得将第一列（类别列）为0）
        return;
    end
    
    if(layer > 1)
        return;
    end
    
    %当前不考虑任何特征时的熵不纯度
    entropy = info(1,7)*log2(info(1,7))+info(2,7)*log2(info(2,7)); 
    Handling{2,1} = info;
    Handling{3,1} = - entropy;
    
%% 对当下active的特征，计算熵不纯度，并寻找最大增益

    gains = zeros(1,n);        %增益数组
   
    for i = 2:n
        if(activeFeature(i))
        %info=Statistics(class,feature);
        %计算当前属性的熵
            %参考模式识别教材       
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
    
 %% 根据最大信息增益，设置当前节点   
 
    [~, bestFeature] = max(gains);
    tree.name = bestFeature;
    activeFeature(bestFeature) = 0;
    tree.brotherList = char(Handling{2, bestFeature}(:,1));
    
 %% 设置后续节点，进行递归
 
    %child
    tree.firstchild = DecisionTree(newData, activeFeature, bestFeature, Handling{2, bestFeature}(:,1), layer+1, 1);
    %对activeFeature 先传兄弟的，因为兄弟是上一层的，本层activeFeature改变
    
end