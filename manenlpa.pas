program manen (input,output);


{$I init}

const mj   = 5.97e24;
      mm   = 7.35e22;
      ms   = 1000.0;
      gamma= 6.67e-11;
      vx0  = 0.0;
      vy0  = 11074.5;
      x0   = -6370000.0;
      y0   = 0.0;
      am   = 380000000.0;


var dt,rj,rm,t,vx,vy,x,y,v,wk,wpj,wpm:real;
    count:integer;

procedure plota(x,y:real);

begin
  plot(50+round(x/1000000.0),100-round(y/1000000.0),1);
end;


procedure initiate(var t,x,y,vx,vy:real);

begin
   dt:=0.5;
   t:=0;
   x:=x0;
   y:=y0;
   vx:=vx0;
   vy:=vy0;
   hires;
   plota(0,0);
   plota(am,0);
end;

procedure step(var t,x,y,vx,vy:real);

var a,rj,rm,fj,fm,fjx,fjy,fmx,fmy,fx,fy,ax,ay:real;

begin
  t:=t+dt;
  rj:=sqrt(sqr(x)+sqr(y));
  rm:=sqrt(sqr(x-am)+sqr(y));
  fj:=gamma*mj*ms/sqr(rj);
  fm:=gamma*mm*ms/sqr(rm);
  fjx:=-x/rj*fj;
  fjy:=-y/rj*fj;
  fmx:=(am-x)/rm*fm;
  fmy:=-y/rm*fm;
  fx:=fjx+fmx;
  fy:=fjy+fmy;
  ax:=fx/ms;
  ay:=fy/ms;
  vx:=vx+ax*dt;
  vy:=vy+ay*dt;

  x:=x+vx*dt+ax*sqr(dt)/2;
  y:=y+vy*dt+ay*sqr(dt)/2;

end;

begin
  initiate(t,x,y,vx,vy);
  count:=0;
  repeat
    count:=count+1;
    step(t,x,y,vx,vy);
    plota(x,y);
    if count mod 10 =0 then
    begin
      gotoxy(1,1);
      v:=sqrt(sqr(vx)+sqr(vy));
      wk:=ms*sqr(v)/2;
      rj:=sqrt(sqr(x)+sqr(y));
      rm:=sqrt(sqr(x-am)+sqr(y));
      wpj:=-gamma*ms*mj/rj;
      wpm:=-gamma*ms*mm/rm;
      write('t=',t:10,'  x=',x:10,'  y=',y:10,'  E=',(wk+wpm+wpj):12);
    end;
  until t>1610000.0;
  textmode;
end.
