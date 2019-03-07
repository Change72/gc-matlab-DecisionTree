function Draw(class,feature)
%ͳ�Ʋ���ͼ�Ĺ���
    info=Statistics(class,feature);
    %��info��ֱ��ͼ
    T = info(:,[2,3]);
    [most,~]=max(max(T));
    figure,bar(T,'grouped');
    %��עϸ��
    number=size(info,1);
    xlabel=cell(number,1);

    for i = 1:number
        for j=1:2
            text(i+((j-1.7)/2),T(i,j)+(most/30),num2str(T(i,j)),'color','r');
        end
        xlabel{i,1}=char(info(i,1));
    end
    set(gca, 'XTickLabel', xlabel) 
    legend('e','p');
    
end