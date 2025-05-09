function p1_script(wid,wdd,ts)%ts es tiempo de simulacion en segundos
   wi=0;wd=0;phi=0;x=0;y=0;t_a=0;
   figure
   for t=0:0.025:ts
        wi=((wid-wi)/0.12)*(t-t_a)+wi;
        wd=((wdd-wd)/0.12)*(t-t_a)+wd;
        v=((wi+wd)*0.1)/2;
        w=((wd-wi)*0.1)/(2*0.8);
        phi=w*(t-t_a)+phi;
        is=v*(t-t_a);
        x=x+cos(phi)*is;
        y=y+sin(phi)*is;
        plot(x,y,'b*')
        hold on
        t_a=t;
   end
end