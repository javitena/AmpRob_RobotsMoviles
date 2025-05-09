function [coste, ruta] = Aestrella(Gcoste,H,in,fin)
%Cargar matrices coste: load('grafos.mat')
%Heuristica H1: load('matriz_H_cambiada.mat')
if(sum(Gcoste(in,:)~=0))
    num_nodos=size(Gcoste,1);
    aux=0; ruta=[];
    estructura_sol=[];
    ini_nodo=[1:num_nodos]';
    ini_coste=inf(num_nodos,1);
    ini_orig=zeros(num_nodos,1);
    estructura=[ini_nodo ini_coste ini_coste ini_orig];
    estructura(in,2)=0;
    estructura(in,3)=H(fin,in);
    estructura=sortrows(estructura,3);
    while (aux~=fin)
        for i=1:1:num_nodos
            if (Gcoste(estructura(1,1),i)~=0)
                for j=1:1:size(estructura,1)
                    if(estructura(j,1)==i)
                        if(estructura(j,2)>Gcoste(estructura(1,1),i)+estructura(1,2))
                            estructura(j,2)=Gcoste(estructura(1,1),i)+estructura(1,2);
                            estructura(j,3)=Gcoste(estructura(1,1),i)+estructura(1,2)+H(fin,i);
                            estructura(j,4)=estructura(1,1);
                        end
                        break;
                    end
                end
            end
        end
        estructura_sol=[estructura_sol;estructura(1,:)];
        estructura=estructura(2:end,:);
        estructura=sortrows(estructura,3);
        aux=estructura_sol(size(estructura_sol,1),1);
    end
    coste=estructura_sol(size(estructura_sol,1),2);
    if (coste~=inf)
        ruta=[estructura_sol(size(estructura_sol,1),4) fin];
        while (ruta(1)~=in)
            for k=1:1:size(estructura_sol,1)
                if(ruta(1)==estructura_sol(k,1))
                    ruta=[estructura_sol(k,4) ruta];
                    break;
                end
            end
        end
    end
else
    coste="Se trata de un nodo aislado";
    ruta="Se trata de un nodo aislado";
end