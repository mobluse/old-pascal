program fractal1(input,output);

{$I init}
{$I plot.pas}

const minlen=4.0;
      pi=3.141592;


procedure cut(x1,y1,x2,y2:real);

var xm,ym,fi,l:real;

begin
  l:=sqrt(sqr(x1-x2)+sqr(y1-y2));
  if l<minlen then
    plotlineto(round(x2*42.8),round(y2*50))
  else
  begin
    if abs(x2-x1)<0.0001 then
      if (y2-y1)>0 then
        fi:=pi/2
      else
        fi:=-pi/2
    else
    begin

      fi:=arctan((y2-y1)/(x2-x1));
      if (x2-x1)<0 then
        fi:=fi+pi;
    end;


    l:=l/sqrt(2);
    fi:=fi-pi/4;
    xm:=x1+l*cos(fi);
    ym:=y1+l*sin(fi);
    cut(x1,y1,xm,ym);
    cut(xm,ym,x2,y2);
  end;
end;

begin
  initplot('plfil');
  selectpen(1);
  movepen(round(100*42.8),round(150*50));
  cut(100,150,250,150);
  exitplot(plotter);
end.