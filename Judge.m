function result = Judge(TestSet, tree)
% 测试函数，根据传进来的测试集、决策树，判断是否决策正确

    m = size(TestSet{1,1},1);
    result = zeros(m,1);    %第一列为1或0
    %识别特征
    %在特征列表中寻找对应点
        %如果有，向下走
        %如果没有，返回当前judgement

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
            if(location <= n)     %在字母表中找到了，继续向下走
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