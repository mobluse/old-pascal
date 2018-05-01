PROGRAM frittfall(Input,Output);
{$I init}
CONST g=9.81 { gravitationskonstanten N/s2};
      dt=0.001 {tidssteg};
      v0=0.0 {utgångshastigheten};
      l=1.0  {pendelns längd};
      pi=3.141592; {pi}
      tmax=2.5 {tid som beräknas};
      itstep=150 {antalet iterationer mellan utskrifterna};

VAR t,fi,vx,period,fig:Real;
    count:Integer;

PROCEDURE print(t,vx,fi:Real);
BEGIN
  Write(t:8:2,'   ');
  Write(fi*180/pi:8:2,'   ');
  WriteLn(vx:8:2,'   ');
END;




PROCEDURE initiate(VAR t,vx:Real);
BEGIN
  t:=0;         vx:=v0;
END;

PROCEDURE step(VAR t,vx,fi:Real);

VAR a,vxdt:Real;

BEGIN
  t:=t+dt;
  a:=-g*sin(fi);
  vxdt:=vx+a*dt;
  fi:=fi+0.5*(vx+vxdt)*dt;
  vx:=vxdt;
END;



{*********************    HUVUDPROGRAM  *******************}

BEGIN
  ClrScr;
  WriteLn('Periodtiden som funktion av utslagsvinkeln');
  WriteLn('Tiden enligt formeln från den matematiska pendeln:',2*pi*sqrt(l/g):6:4);
  fig:=10;
  REPEAT
    fi:=fig*pi/180;
    initiate(t,vx);
    REPEAT
      step(t,vx,fi);
    UNTIL fi<0;
    t:=t-fi*l/vx;
    period:=4*t;
    WriteLn('För utslagsvinkeln ',fig:5:1,' är perioden ',period:8:4);
    fig:=fig+10;
  UNTIL fig=180
END.

