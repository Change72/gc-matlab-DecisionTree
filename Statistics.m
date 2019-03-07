function  info = Statistics(class, feature)
%class 为类别结果，feature 为输入的特征，  返回的info为7列数组

    number=0;
    info=zeros(number,7); %七列，特征种类一列，edible一列，poisonous一列，总数一列，
    %edible概率一列，poisonous概率一列，该特征概率一列
    m = size(feature,1);
    flag = 0; %在已有表中是否找到
    for i = 1:m
        %遍历特征
        for j = 1:number
           %循环查找
           if(info(j,1)==feature{i,1})
               flag = 1;
               if(class{i,1}=='e')
                  info(j,2)=info(j,2)+1;
               elseif(class{i,1}=='p')
                  info(j,3)=info(j,3)+1;
               end          
           end
           %如果找到，flag==1，字符表++
        end
        if(flag==0)
          %没有找到，字符表扩增 ，对应字符+1 
          number=number+1;
          info(number,1)=feature{i,1};
          if(class{i,1}=='e')
              info(number,2)=info(number,2)+1;
          elseif(class{i,1}=='p')
              info(number,3)=info(number,3)+1;
          end
        end
        flag = 0;
    end
    for k=1:number
        info(k,4)=info(k,2)+info(k,3);
        info(k,5)=info(k,2)/info(k,4);
        info(k,6)=info(k,3)/info(k,4);
        info(k,7)=info(k,4)/m;
    end
end