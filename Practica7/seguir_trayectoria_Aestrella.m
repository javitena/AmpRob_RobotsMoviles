function seguir_trayectoria_Aestrella (ini,fin,map_in,G,nodos)
%Datos costes y posicion nodos con comando: mapa2
close all
map_img=imread(map_in);
map_neg=imcomplement(map_img);
map_bin=imbinarize(map_neg);
mapa=binaryOccupancyMap(map_bin);
show(mapa);
hold on
G_act=calcula_costes(G,nodos); %Se calculan coste y la heuristica con la distancia euclidea
H=calcula_H(nodos);
[coste, ruta] = Aestrella(G_act,H,ini,fin); 
for i=1:1:(length(ruta)-1)
    fin=campos_potenciales([nodos(ruta(i),2:3)],[nodos(ruta(i+1),2:3)],mapa);
    if fin==true
        break
    end
end
if fin==false
    fprintf('Se ha alcanzado el destino.\n')
end
end

%#ok<*ASGLU>
%% 
function [coste, ruta] = Aestrella(Gcoste,H,in,fin)
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
end

function fin=campos_potenciales(origen,destino,mapa)

% Configuracion del sensor (laser de barrido)
max_rango=10;
angulos=-pi/2:(pi/180):pi/2; % resolucion angular barrido laser
fin=false;
% Caracteristicas del vehiculo y parametros del metodo
v=0.4;            % Velocidad del robot
D=1.5;           % Rango del efecto del campo de repulsión de los obstáculos
alfa=10;           % Coeficiente de la componente de atracción
beta=20000;      % Coeficiente de la componente de repulsión
robot=[origen 0];     % El robot empieza en la posición de origen (orientacion cero)
path = [];                 % Se almacena el camino recorrido
path = [path; robot];     % Se añade al camino la posicion actual del robot
iteracion=0;              % Se controla el nº de iteraciones por si se entra en un minimo local
while norm(destino-robot(1:2)) > v && iteracion<1000    % Hasta menos de una iteración de la meta (10 cm)
   % TU CODIGO AQUI %%%%%%%%%%%%%
   lidar=SimulaLidar(robot, mapa, angulos, max_rango);
   Fatr=alfa*(destino-robot(1:2));
   Frep=0;
   for i=1:1:length(lidar)
      if isnan(lidar(i,:))==false
          rho_obs=norm(robot(1:2)-lidar(i,:));
         if rho_obs<=D
             Frep=Frep+beta*(1/rho_obs-1/D)*(robot(1:2)-lidar(i,:))/(rho_obs^3);
         end
      end
   end
   Fres=Fatr+Frep;
   orient=atan2(Fres(2),Fres(1));
   robot=[robot(1:2)+Fres/norm(Fres)*v orient];
   path = [path;robot];	% Se añade la nueva posición al camino seguido
   plot(path(:,1),path(:,2),'r');
   drawnow

   iteracion=iteracion+1;
end

if iteracion==1000   % Se ha caído en un mínimo local
    fprintf('No se ha podido llegar al destino.\n')
    fin=true;
end
end

function [obs]=SimulaLidar(robot, mapa, angulos, max_rango)
    obs=rayIntersection(mapa,robot,angulos, max_rango);
    % plot(obs(:,1),obs(:,2),'*r') % Puntos de interseccion lidar
    % plot(robot(1),robot(2),'ob') % Posicion del robot
    % for i = 1:length(angulos)
    %     plot([robot(1),obs(i,1)],...
    %         [robot(2),obs(i,2)],'-b') % Rayos de interseccion
    % end
    % % plot([robot(1),robot(1)-6*sin(angulos(4))],...
    % %     [robot(2),robot(2)+6*cos(angulos(4))],'-b') % Rayos fuera de
    % %     rango
end

function costes_act=calcula_costes(costes,nodos)
    costes_act=zeros(size(costes));
    for i=1:1:size(costes,1)
        for j=1:1:size(costes,2)
            if costes(i,j)~=0
                costes_act(i,j)=sqrt((nodos(i,2)-nodos(j,2))^2 + (nodos(i,3)-nodos(j,3))^2);
            end
        end
    end
end

function H=calcula_H(nodos)
    H=zeros(size(nodos,1));
    for i=1:1:size(H,1)
        for j=1:1:size(H,2)
            H(i,j)=sqrt((nodos(i,2)-nodos(j,2))^2 + (nodos(i,3)-nodos(j,3))^2);
        end
    end
end