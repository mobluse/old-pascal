PROGRAM osciliator(Input,Output);
{$I init}
CONST g=9.81 { gravitationskonstanten N/s2};
      v0=0.0 { utgångshastighet kg};
      dt=0.01 {tidssteg};
      tmax=20 {tiden som skall beräknas};
      itstep=100 {antalet iterationer mellan utskrifterna};

VAR t,x,vx:Real;
    count:Integer;

PROCEDURE initiate(VAR t,vx,x:Real);
BEGIN
  t:=0;         vx:=0;         x:=0;
  ClrScr;
  WriteLn('Tid       läge(ber)  hast(ber)  läge(ex)   hast(ex)');
  WriteLn;
  WriteLn('     0.00      0.00      0.00      0.00      0.00');
END;

PROCEDURE step(VAR t,vx,x:Real);
BEGIN
  t:=t+dt;
  vxdt:=vx+g*dt;
  x:=x+0.5*(vx+vxdt)*dt;
  vx:=vxdt;
END;

FUNCTION vxber(t:Rael):Real;
BEGIN
  vxber:=v0+g*t;
END;

FUNCTION xber(t:Real):Real;
BEGIN
  xber:=v0+t+g*sqr(t)/2;
END;

PROCEDURE print(t,vx,x:Real);
BEGIN
  Write(t:6:2,'  ');
  Write(x:6:2,'  ');
  Write(vx:6:2,'  ');
  Write(xber(t):6:2,'  ');
  Writeln(vxber(t):6:2,'  ');
END;

{*********************    HUVUDPROGRAM  *******************}

BEGIN
  initiate(t,vx,x);
  REPEAT
    FOR count:=1 TO itstep DO
    BEGIN
      step(t,vx,x);
      drawscr(period,x,t);
    END;
    print(t,vx,x);
  UNTIL t>=tmax;
END.

