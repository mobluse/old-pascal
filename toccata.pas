program toccata;
(*
  Toccata.
  Copyright (c) 1993 by Mikael Bonnier, Lund, Sweden.
  Language:  Turbo Pascal 6.0.
  Requirents: GRAFTABL loaded.
  Purpose:  Plots the Mandelbrot set (=mängden), with probability corona.
  Why named Toccata:  A complex mapping to which my view of the musical
  meaning of J.S.Bach's famous fugue inclines me, upon ground of analogy,
  to give the name of Toccata, as expressing the presence of both vulgar
  and sublime qualities.
  Excuse: Föregående mening är inte avsedd att vara helt begriplig!
*)

uses graph, crt;

label 1;

(* crt aspect ratio y/x=0.75 *)
const xmin = -4;
      xmax = 4;
      ymin = -3;
      ymax = 3;
      mesg = 'z'+chr(27)+'z²+c';

var rez, imz:           real;
    reztmp:             real;
    rec, imc:           real;
    n:                  integer;
    xscale, yscale:     real;
    xinc, yinc:         real;
    gd, gm:             integer;
    ch:                 char;


begin
  gd := detect;
  initgraph(gd, gm, '\bgi');
  randomize;

  xscale := (getmaxx+1)/(xmax-xmin);
  yscale := -(getmaxy+1)/(ymax-ymin);
  xinc := 1/xscale;
  yinc := -1/yscale;
  outtextxy(trunc(xscale*(-0.5-xmin)), trunc(yscale*(0+ymin)), mesg);

  rec := xmin;
  while rec<xmax do begin
    imc := ymin;
    while imc<ymax do begin
      rez := 0;
      imz := 0;
      for n:=0 to 100 do begin
        (*  z := z^2 + c  *)
        reztmp := rez*rez - imz*imz + rec;
        imz := 2*rez*imz + imc;
        rez := reztmp;
        if rez*rez + imz*imz > 9 (*  |z| > 3  *)
           then goto 1;
      end; (* for n *)
1:    if (n <> 100) and (random(n*n+21) > 19) then
         putpixel(trunc(xscale*(rec-xmin)), trunc(yscale*(imc+ymin)), 15);
      imc := imc + yinc;
    end; (* while imc *)
    rec := rec + xinc;
  end; (* while rec *)
  while not keypressed do begin (* blinking mesg *)
    setcolor(black);
    outtextxy(trunc(xscale*(-0.5-xmin)), trunc(yscale*(0+ymin)), mesg);
    delay(1000);
    setcolor(white);
    outtextxy(trunc(xscale*(-0.5-xmin)), trunc(yscale*(0+ymin)), mesg);
    delay(500);
  end; (* while not keypressed *)
  ch := readkey;
end. (* program toccata *)
