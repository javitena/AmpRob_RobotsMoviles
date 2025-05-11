clear all
close all
clc
figure

% Entorno cerrado definido por una lista de puntos
x=[-0 30 30 0 0]';
y=[0 0 10 10 0]';
plot(x,y,LineWidth=2)
hold on

% Posición y orientación del vehiculo
x0= 1;
y0= 2;
phi0= 0; % Entre -pi y pi

%Distancia al punto objetivo
d=1;

%Velocidad enunciado
v=0.3;

%Anchura pasillo
L=10;

while x0<25
    rangos= laser2D(x, y, x0, y0, phi0);
    dist=rangos(18)+rangos(54);
    inc_theta=acos(L/dist);
    d_L=(L/2)-y0;
    inc_x=real(d_L*sin(inc_theta)+d*cos(inc_theta));
    inc_y=real(d_L*cos(inc_theta)-d*sin(inc_theta));
    phi0=atan2(inc_y,inc_x);
    norma=norm([inc_x inc_y]);%Norma del vector direccion
    x0=x0+v*(inc_x/norma);
    y0=y0+v*(inc_y/norma);
    plot(x0,y0,'*')
end