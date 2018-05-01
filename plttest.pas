program plt;

{$I plot}

var x,y:integer;

begin
  initplot('pltfil.plt');
  readln(x,y);
  selectpen(1);
  plotcircle(x,y,10);
  exitplot(plotter);
end.

