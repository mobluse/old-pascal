program t1(input,output);

{$I init}

const  dx=0.01;
       dt=0.1;
       k=1.1e-4;

type  matristyp=array [0..11,0..11] of real;

var   u:matristyp;
      t:real;

procedure initiate(var u:matristyp;var t:real);
var i,j:integer;
begin
  clrscr;
  t:=0;
  for i:=1 to 10 do
    for j:=1 to 10 do
      u[i,j]:=0;
  u[1,1]:=99;
  u[10,10]:=99;
end;

procedure step(var u:matristyp;var t:real);

var i,j:integer;
    du:matristyp;


begin
  t:=t+dt;
  for i:=1 to 10 do
    for j:=1 to 10 do
      du[i,j]:=0;


  for i:=1 to 10 do
  begin
    u[0,i]:=u[1,i];
    u[11,i]:=u[10,i];
    u[i,0]:=u[i,1];
    u[i,11]:=u[i,10];
  end;



  for i:= 1 to 10 do
    for j:=1 to 10 do
      du[i,j]:=dt*k/sqr(dx)*(u[i+1,j]+u[i-1,j]+u[i,j+1]+u[i,j-1]-4*u[i,j]);

  for i:=1 to 10 do
    for j:=1 to 10 do
      u[i,j]:=u[i,j]+du[i,j];
  u[1,1]:=99;
  u[10,10]:=99;
end;

procedure skrivut(u:matristyp;t:real);

var i,j:integer;

begin
  gotoxy(1,1);
  writeln(t:6:2);
  for i:= 1 to 10 do
  begin
    for j:= 1 to 10 do
      write(u[i,j]:3:0);
    writeln;
  end;
end;


begin
  initiate(u,t);
  repeat
    step(u,t);
    skrivut(u,t);
  until t>1000;
end.
