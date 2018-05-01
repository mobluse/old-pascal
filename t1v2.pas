program t1(input,output);

{$I init}

const  l=0.2;
       maxelem=21;
       kvarde=9.4e-7;
       dx=0.01;
       dt=10;

type   vektortyp=array [1..maxelem] of real;

var    k,u:vektortyp;
       t,tempgammal:real;



function xp(x:real):integer;

begin
  xp:=round(20+x*0.01);
end;


function yp(y:real):integer;

begin
  yp:=round(185-y*8.5);
end;



procedure initiate(var k,u:vektortyp;var t:real);

var  i:integer;

begin
  hires;
  draw(xp(0),yp(0),xp(60000.0),yp(0),1);
  draw(xp(0),yp(0),xp(0),yp(20),1);
  gotoxy(4,1);
  write('Temperatur utvecklingen i den isolerade „nden');
  gotoxy(1,3);
  write('T=20');
  gotoxy(74,25);
  write('t=17 h');
  t:=0;
  for i:=1 to maxelem do
  begin
    k[i]:=kvarde;
    u[i]:=0;
  end;
end;


procedure randen(var u:vektortyp);

begin
  u[1]:=20;
  u[maxelem]:=0;
end;


procedure step(var t:real;var u:vektortyp;k:vektortyp);

var i:integer;
    v:vektortyp;

begin
  t:=t+dt;
  for i:=2 to maxelem-1 do
    v[i]:=u[i]+k[i]*(u[i-1]+u[i+1]-2*u[i])/sqr(dx)*dt;
  for i:=2 to maxelem-1 do
    u[i]:=v[i];
    u[maxelem]:=v[maxelem-1];

end;




procedure plotta(t:real;u:vektortyp);

var i:integer;

begin
  plot(xp(t),yp(u[20]),1);
end;



begin
  tempgammal:=0;
  initiate(k,u,t);
  randen(u);
  repeat
    step(t,u,k);
    plotta(t,u);
  until t>60000.0;
  gotoxy(1,24);
end.
