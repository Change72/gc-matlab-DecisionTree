function  info = Statistics(class, feature)
%class Ϊ�������feature Ϊ�����������  ���ص�infoΪ7������

    number=0;
    info=zeros(number,7); %���У���������һ�У�edibleһ�У�poisonousһ�У�����һ�У�
    %edible����һ�У�poisonous����һ�У�����������һ��
    m = size(feature,1);
    flag = 0; %�����б����Ƿ��ҵ�
    for i = 1:m
        %��������
        for j = 1:number
           %ѭ������
           if(info(j,1)==feature{i,1})
               flag = 1;
               if(class{i,1}=='e')
                  info(j,2)=info(j,2)+1;
               elseif(class{i,1}=='p')
                  info(j,3)=info(j,3)+1;
               end          
           end
           %����ҵ���flag==1���ַ���++
        end
        if(flag==0)
          %û���ҵ����ַ������� ����Ӧ�ַ�+1 
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