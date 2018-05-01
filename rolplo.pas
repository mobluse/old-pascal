program rolplo;
{$I plot.pas}

var u1,v1,u2,v2,x,y,x1,x2,y1,y2,xd,yd:Real;
    x3,y3:Integer;
    ukod,vkod,first:Boolean;
    stri:String[20];
    datafil:file of real;

function up(u:Real):Integer;
var a,b,c:Real;
begin
  if ukod then
   begin
    b:=(14000.0-500.0)/(u2-u1);
    a:=500.0-b*Ln(u1);
    if (u > u1) then
      c:=a+b*Ln(u);
   end
  else
   begin
    b:=(14000.0-500.0)/(u2-u1);
    a:=14000.0-b*u2;
    c:=a+b*u;
   end;

  if (u <= u1) then
    c:=500.0;
  if (u > u2) then
    c:=14000.0;
  up:=Round(c);
end;

function vp(v:Real):Integer;
var a,b,c:Real;
begin
  if vkod then
   begin
    b:=(9700.0-1200.0)/Ln(v2/v1);
    a:=1200.0-b*Ln(v1);
    if (v > v1) then
      c:=a+b*Ln(v);
   end
  else
   begin
    b:=(9700.0-1200.0)/(v2-v1);
    a:=9700.0-b*v2;
    c:=a+b*v;
   end;

  if (v > v2) then
    c:=9700.0;
  if (v <= v1) then
    c:=1200.0;
  vp:=Round(c);
end;

procedure Frame(x1,x2,y1,y2,xd,yd:Real;xkod,ykod:Integer);
var u,v,uu,vv:Real;
    i,j:Integer;
begin
  u1:=x1;v1:=y1;u2:=x2;v2:=y2;
  ukod:=false;
  if (xkod = 1) then
    ukod:=true;
  vkod:=false;
  if (ykod = 1) then
    vkod:=true;
  selectpen(1);
  movepen(500,1200);
  plotlineto(14000,1200);
  plotlineto(14000,9700);
  plotlineto(500,9700);
  plotlineto(500,1200);
  if ukod then
   begin
    u:=u1;
    for i:=0 to Round(Ln(u2/u1)/Ln(10.0))-1 do
     begin
      movepen(up(u),vp(v1));
      plotlineto(up(u),vp(v1)-200);
      uu:=u;
      for j:=2 to 9 do
       begin
        uu:=uu+u;
        movepen(up(uu),vp(v1));
        plotlineto(up(uu),vp(v1)-100);
       end;
      v:=v*10.0;
     end;
    movepen(up(u2),vp(v1));
    plotlineto(up(u2),vp(v1)-200);
   end
   else
    begin
     if (500.0*xd > x2-x1) then
      begin
       u:=u1;
       repeat
         movepen(up(u),vp(v1));
         plotlineto(up(u),vp(v1)-100);
         u:=u+xd;
       until (u > u2);
      end;
    end;

  if vkod then
   begin
    v:=v1;
    for i:=0 to Round(Ln(v2/v1)/Ln(10.0))-1 do
    begin
      movepen(up(u1),vp(v));
      plotlineto(up(u1)-200,vp(v));
      vv:=v;
      for j:=2 to 9 do
      begin
        vv:=vv+v;
        movepen(up(u1),vp(vv));
        plotlineto(up(u1)-100,vp(vv));
      end;
      v:=v*10.0;
     end;
    movepen(up(u1),vp(v2));
    plotlineto(up(u1)-200,vp(v2));
   end
  else
  begin
   if (500.0*yd > y2-y1) then
    begin
     v:=v1;
     repeat
       movepen(up(u1),vp(v));
       plotlineto(up(u1)-100,vp(v));
       v:=v+yd;
     until (v > v2);
    end;
  end;
end;

procedure PL(u,v:Real);
begin
  if first then
   begin
    movepen(up(u),vp(v));
    first:=false;
   end
  else
    plotlineto(up(u),vp(v));
end;

begin
  Write('name  of  the  data-file   ==> ');ReadLn(stri);
  Assign(datafil,stri);
  Reset(datafil);
  Write('min and max in x-direction ==> ');ReadLn(x1,x2);
  Write('lin or log in x   (0/1)    ==> ');ReadLn(x3);
  if x3=0 then
  begin
   Write('ticks  distance   in   x   ==> ');ReadLn(xd);
  end;
  Write('min and max in y-direction ==> ');ReadLn(y1,y2);
  Write('lin or log in y   (0/1)    ==> ');ReadLn(y3);
  if y3 = 0 then
  begin
   Write('ticks  distance   in   y   ==> ');ReadLn(yd);
  end;
  initplot('rol.dat');
  Frame(x1,x2,y1,y2,xd,yd,x3,y3);
  first:=true;
  selectpen(2);
  while not eof(datafil) do
   begin
    Read(datafil,x,y);
    PL(x,y);
   end;
  close(datafil);
  exitplot(plotter);
end.
