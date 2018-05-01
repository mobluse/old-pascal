PROGRAM frittfall(Input,Output);
{$I init}
CONST g=9.81 { gravitationskonstanten N/s2};
      v0=0.0 { utg†ngshastighet kg};
      dt=0.01 {tidssteg};
      tmax=19.0 {tiden som skall ber„knas};
      itstep=100 {antalet iterationer mellan utskrifterna};

VAR t,x,vx:Real;
    count:Integer;

PROCEDURE initiate(VAR t,vx,x:Real);
BEGIN
  t:=0;         vx:=0;         x:=0;
  ClrScr;
  WriteLn('       Frittfall med MedelPunktsAproximatio (MPA)!');
  WriteLn('     Tid  l„ge(ber)  hast(ber)   l„ge(ex)   hast(ex)');
  WriteLn;
  WriteLn('    0.00       0.00       0.00       0.00       0.00');
END;

PROCEDURE step(VAR t,vx,x:Real);

VAR vxdt:Real;

BEGIN
  t:=t+dt;
  vxdt:=vx+g*dt;
  x:=x+0.5*(vx+vxdt)*dt;
  vx:=vxdt;
END;

FUNCTION vxber(t:Real):Real;
BEGIN
  vxber:=v0+g*t;
END;

FUNCTION xber(t:Real):Real;
BEGIN
  xber:=v0*t+g*sqr(t)/2;
END;

PROCEDURE print(t,vx,x:Real);
BEGIN
  Write(t:8:2,'   ');
  Write(x:8:2,'   ');
  Write(vx:8:2,'   ');
  Write(xber(t):8:2,'   ');
  Writeln(vxber(t):8:2,'   ');
END;

{*********************    HUVUDPROGRAM  *******************}

BEGIN
  initiate(t,vx,x);
  REPEAT
    FOR count:=1 TO itstep DO
      step(t,vx,x);
    print(t,vx,x);
  UNTIL t>=(tmax-0.0001);
END.

