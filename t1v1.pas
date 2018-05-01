program t1(input,output);




const  l=0.2;
       maxelem=20;
       kvarde=9.4e-7;
       dx=0.01;
       dt=10;

type   vektortyp=array [1..maxelem] of real;

var    k,u:vektortyp;
       t:real;



function xp(x:real):integer;

begin
  xp:=round(20+x*3000);
end;


function yp(y:real):integer;

begin
  yp:=round(185-y*8.5);
end;



procedure initiate(var k,u:vektortyp;var t:real);

var  i:integer;

begin
  hires;
  draw(xp(dx),yp(0),xp(0.2),yp(0),1);
  draw(xp(dx),yp(0),xp(dx),yp(20),1);
  gotoxy(1,3);
  write('T=20');
  gotoxy(74,25);
  write('x=0.2m');
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
end;




procedure plot(t:real;u:vektortyp);

var i:integer;

begin
  gotoxy(1,1);
  writeln('Temperatur profil vid t=',t:6:0);
  for i:=1 to maxelem-1 do
    draw(xp(i*dx),yp(u[i]),xp((i+1)*dx),yp(u[1+i]),1);
end;



begin
  initiate(k,u,t);
  randen(u);
  repeat
    step(t,u,k);
    if abs(t/1200-round(t/1200))<0.0001 then
      plot(t,u);
  until t>11000;
  gotoxy(1,24);
end.
