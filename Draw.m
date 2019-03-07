function Draw(class,feature)
%统计并画图的功能
    info=Statistics(class,feature);
    %用info画直方图
    T = info(:,[2,3]);
    [most,~]=max(max(T));
    figure,bar(T,'grouped');
    %标注细节
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