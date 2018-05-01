Program kurva(Input,Output);

{$I plot}

Var
  fi,r:Real;
  xp,yp:Integer;

Function radie(fi:Real):Real;

Begin
  radie:=2-cos(fi);
End;


Begin
  initplot('kalle');
  selectpen(1);
  fi:=0;
  xp:=7500+round(2000.0*cos(0)*radie(0));
  yp:=5000+round(2000.0*sin(0)*radie(0));
  MovePen(xp,yp);
  Repeat
    fi:=fi+0.01;
    xp:=7500+round(2000.0*cos(fi)*radie(fi));
    yp:=5000+round(2000.0*sin(fi)*radie(fi));
    plotlineto(xp,yp);
  Until fi>3.1415;
  exitplot(plotter);
End.
