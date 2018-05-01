PROGRAM elastiskpendel(Input,Output);

{$I graph.p }

CONST g=9.80665;
      dt=0.01;
      vx0=3.03;     {y0=0.5   3.03 4.24  8.30 2.095}
      vy0=0.0;
      x0=0.0;
      y0=0.5;
      K=50.0;
      L=1.0;
      m=1.0;
      fac=100;

VAR t,vx,vy,x,y,lx,ly:Real;
    tkn:char;

PROCEDURE plotk(x,y,vx,vy,t:Real);

var r,wp,wk,v:real;
    ix,iy:integer;

BEGIN
  r:=sqrt(sqr(x)+sqr(y))-l;
  if r<0 then r:=0;
  wp:=k*sqr(r)/2-m*g*y;
  v:=sqrt(sqr(vx)+sqr(vy));
  wk:=m*sqr(v)/2;
  gotoXY(1,1);
  write((wk+wp):8:4);
  write(t:8:4);
  draw(round(300+lx*fac),round(ly*fac),round(300+x*fac),round(y*fac),1);
END;




PROCEDURE initiate(VAR x,y,vx,vy,t:Real);
BEGIN
  hires;
  circle(300,0,round(fac*l),1);
  draw(300,0,300,199,1);
  t:=0;         vx:=vx0;   vy:=vy0;   x:=x0;   y:=y0;
END;

PROCEDURE step(VAR x,y,vx,vy,t:Real);

VAR ax,ay,axn,ayn,r,fx,fy:Real;

BEGIN
  lx:=x;
  ly:=y;
  t:=t+dt;
  r:=sqrt(sqr(x)+sqr(y));
  if r<l then
     r:=l;
  fx:=k*x*(l/r-1);
  fy:=k*y*(l/r-1)+m*g;
  ax:=fx/m;
  ay:=fy/m;
  x:=x+vx*dt+ax*sqr(dt)/2;
  y:=y+vy*dt+ay*sqr(dt)/2;
  r:=sqrt(sqr(x)+sqr(y));
  if r<l then
     r:=l;
  fx:=k*x*(l/r-1);
  fy:=k*y*(l/r-1)+m*g;
  axn:=fx/m;
  ayn:=fy/m;
  vx:=vx+0.5*(axn+ax)*dt;
  vy:=vy+0.5*(ay+ayn)*dt;
END;



{*********************    HUVUDPROGRAM  *******************}

BEGIN
  ClrScr;
  initiate(x,y,vx,vy,t);
  REPEAT
      step(x,y,vx,vy,t);
      plotk(x,y,vx,vy,t);
  UNTIL keypressed;
  textmode;
END.

