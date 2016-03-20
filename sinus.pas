program sinus;
uses graph;
const pi=3.141592;
var x,y:real;
    gd,gm:integer;
begin
  gd := detect;
  initgraph(gd,gm,'');
  x:=-pi;
  while x<pi do
  begin
    y := sin(x);
    putpixel(trunc(720/(2*pi)*(x+pi)), trunc(-348/2*y+348/2), 15);
    x:=x+2*pi/720;
  end;
end.
