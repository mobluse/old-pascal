program Hexagon; { by Mikael Bonnier }

  uses Crt, Graph;
  var
    graphDriver,
    graphMode,
    maxX, maxY     : integer;
    ch             : char;
    x0, y0, r,
    v, x, y        : real;
    i, j           : integer;

  begin
    graphDriver:=detect;
    InitGraph(graphDriver, graphMode, '\bgi');
    if GraphResult<>grOk then
      Halt(1);
    maxX:=GetMaxX;
    maxY:=GetMaxY;
    x0:=maxX div 2;
    y0:=maxY div 2;
    r:=y0;
    v:=0;
    x:=2.4*r;
    y:=0;
    repeat
      SetColor(GetMaxColor);
      for j:=1 to 40 do begin
        MoveTo(Round(x0+x), Round(y0+y));
        for i:=1 to 6 do begin
          v:=v+60;
          x:=2.4*r*cos(v*pi/180);
          y:=r*sin(v*pi/180);
          LineTo(Round(x0+x), Round(y0+y));
        end;
        r:=r*0.95;
        v:=v+2;
      end;
      SetColor(0);
      for j:=1 to 40 do begin
        r:=r*1.05263158;
        v:=v-2;
        for i:=1 to 6 do begin
          x:=2.4*r*cos(v*pi/180);
          y:=r*sin(v*pi/180);
          LineTo(Round(x0+x), Round(y0+y));
          v:=v-60;
        end;
      end;
    until keypressed;
    ch:=Readkey;
    CloseGraph;
  end.
