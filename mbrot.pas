program mandelbrot;
uses graph;
label 1;
var rez, imz: real;
    reztmp: real;
    rec, imc: real;
    n: integer;
    xscale, yscale: real;
    xinc, yinc: real;
    gd, gm: integer;
begin
  gd := detect;
  initgraph(gd, gm, '\bgi');
  xscale := 640/3;
  yscale := -200/2;
  xinc := 1/xscale;
  yinc := -1/yscale;
  rec := -2;
  while rec<1 do begin
    imc := -1;
    while imc<1 do begin
      rez := 0;
      imz := 0;
      for n:=0 to 100 do begin
        (* z := z^2 + c *)
        reztmp := rez*rez - imz*imz + rec;
        imz := 2*rez*imz + imc;
        rez := reztmp;
        if rez*rez + imz*imz > 9 then goto 1;
      end; (* for n *)
1:    if (n <> 100) and (random(n) > 2) then
         putpixel(trunc(xscale*(rec-(-2))), trunc(yscale*(imc+(-1))), 15);
      imc := imc + yinc;
    end; (* while imc *)
    rec := rec + xinc;
  end; (* while rec *)
end. (* program mandelbrot *)
