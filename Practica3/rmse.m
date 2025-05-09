function error_total=rmse(true,path)
    suma=0;
    for i=1:1:size(true,2)
        suma=suma+(true(:,i)-path(:,i)).^2;
    end
    error_por_variable=sqrt(suma/size(true,2));
    error_total=sum(error_por_variable);
end