PROGRAM osciliator(Input,Output);
{$I init}
CONST k=1.2 { fj„derkonstanten N/m};
      m=1.0 { massa kg};
      offsett=50 { se fig 2 };
      offsetx=100 { se fig 2};
      ampilitud=1.0;
      pi=3.14159;
      dt=0.05 {tidssteg};

VAR t,x,vx,period:Real;

PROCEDURE initiate(VAR t,vx,x,per:Real);
BEGIN
  t:=0;         vx:=0;         x:=ampilitud;
  per:=2*pi*Sqrt(m/k);
  ClrScr;       HiRes;
  Draw(offsett,offsetx,600,offsetx,1);
END;

PROCEDURE step(VAR t,vx,x:Real);
VAR fx,ax:Real;
BEGIN
  t:=t+dt;
  fx:=-k*x;
  ax:=fx/m;
  x:=x+vx*dt+ax*sqr(dt)/2;
  vx:=vx+ax*dt;
END;

PROCEDURE drawscr(period:Real; VAR x,t:Real);
VAR tpl,xpl:Integer;
BEGIN
  tpl:=Round(offsett+t/(5*period)*550);
  xpl:=Round(offsetx-x/ampilitud*70);
  Plot(tpl,xpl,1);
END;

{*********************    HUVUDPROGRAM  *******************}

BEGIN
  initiate(t,vx,x,period);
  REPEAT
    step(t,vx,x);
    drawscr(period,x,t);
  UNTIL t>5*period;
END.

