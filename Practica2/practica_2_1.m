function practica_2_1(G,puntos) %G=0.3;puntos=[0 20 20 -10 -20 0 0;0 0 20 30 -10 -30 0];
   
wi=0;wd=0;phi=0;x=0;y=0;salto_t=0.025;
   figure
   tiempo_gps=-1;
   for p=puntos
       d=10;
       while(d>=1) %Cada salto es 0.025 segundos, pero el gps solo se actualiza cada 0.3 segundos
            if tiempo_gps>=0.3 | tiempo_gps==-1
                pos=DGPS(x,y,phi); %Ruido
                x_gps=pos(1);y_gps=pos(2);phi_gps=pos(3);
                px_loc=cos(phi_gps)*(p(1)-x_gps)+sin(phi_gps)*(p(2)-y_gps);
                py_loc=-sin(phi_gps)*(p(1)-x_gps)+cos(phi_gps)*(p(2)-y_gps);
                d=sqrt(px_loc^2+py_loc^2);
                angulo_deseado=atan2(py_loc,px_loc);
                curvatura=G*angulo_deseado;
                wid=(1.2*(1-curvatura))/0.1;
                wdd=(1.2*(1+curvatura))/0.1;
                tiempo_gps=0;
            end
            wi=((wid-wi)/0.12)*(salto_t)+wi;
            if wi>15
                wi=15;
            end
            wd=((wdd-wd)/0.12)*(salto_t)+wd;
            if wd>15
                wd=15;
            end
            v=((wi+wd)*0.1)/2;
            w=((wd-wi)*0.1)/(2*0.8);
            phi=w*(salto_t)+phi;
            is=v*(salto_t);
            x=x+cos(phi)*is;
            y=y+sin(phi)*is;
            tiempo_gps=tiempo_gps+salto_t;
            plot(x,y,'b*')
            hold on
       end
   end
end