program twoparticle;
(* Tvådimensionell tvåpartikelsimulering *)
(* SI-enheter *)

uses graph;

const dt = 0.0005;
      tmax = 100;
      nmax = 10;
      q1 = +1.60E-19;  (* elementarladdningen *)
      q2 = -1.60E-19; (* elektronens laddning *)
      m1 = 0.911E-30; (* elektronens massa *)
      m2 = 1.822E-30; (* 2*me *)
      g = -11;
      k = 8.99E9; (* konstanten i Coulombs lag *)

var   F1, F2, (* kraften på partikel 1 från part 2, respektive på 2 från 1. *)
      a1, a2, (* accelerationen hos 1 resp 2. *)
      v1, v2, (* hastigheten hos 1 resp 2. *)
      r1, r2: array[1..2] of real; (* positionen hos 1 resp 2 *)
      t, (* aktuell tid *)
      d2, (* kvadraten på avståndet mellan 1 och 2 *)
      C: real; (* faktor för att snabba upp beräkning av Coulombs lag *)
      gd, gm: integer; (* graph variables *)
      n: integer; (* loop räknare *)

begin
   r1[1] := -3;
   r1[2] :=  2;
   v1[1] :=  7;
   v1[2] :=  -3;

   r2[1] :=  3;
   r2[2] :=  0;
   v2[1] :=  -4;
   v2[2] :=  2.5;

   t := 0;

   gd := detect; initgraph(gd,gm,'\bgi'); if graphresult<>grok then halt(1);

   while(t<=tmax) do begin
    for n:=1 to nmax do begin
      d2 := sqr(r1[1]-r2[1]) + sqr(r1[2]-r2[2]);
      C := k*q1*q2/(sqrt(d2)*d2);
      F1[1] := C*(r1[1]-r2[1]);  (* Coulombs lag *)
      F1[2] := C*(r1[2]-r2[2]);
      F2[1] := -F1[1]; (* Newtons 3:e lag *)
      F2[2] := -F1[2];
      F1[2] := F1[2]+m1*g;
      F2[2] := F2[2]+m2*g;

      a1[1] := F1[1]/m1; (* Newtons 2:a lag för partikel 1 *)
      a1[2] := F1[2]/m1;
      a2[1] := F2[1]/m2; (* -"-     -"- -"- -"- -"-      2 *)
      a2[2] := F2[2]/m2;

      v1[1] := v1[1] + a1[1]*dt; (* ny hastighet för partikel 1 *)
      v1[2] := v1[2] + a1[2]*dt;
      v2[1] := v2[1] + a2[1]*dt; (* "  -"-       -"- -"-      2 *)
      v2[2] := v2[2] + a2[2]*dt;

      r1[1] := r1[1] + v1[1]*dt; (* ny position för partikel 1 *)
      r1[2] := r1[2] + v1[2]*dt;
      r2[1] := r2[1] + v2[1]*dt; (* "  -"-      -"- -"-      2 *)
      r2[2] := r2[2] + v2[2]*dt;

(*      t := t + dt;*)
    end; (* for n:=... *)
(*      writeln('t=',t:6:2,'; r1[1]=',r1[1]:5:1,'; r1[2]=',r1[2]:5:1,
              '; r2[1]=',r2[1]:5:1,'; r2[2]=',r2[2]:5:1);*)
(*      cleardevice;*)
      circle(trunc(100*r1[1])+300,-trunc(50*r1[2])+100,2);
      circle(trunc(100*r2[1])+300,-trunc(50*r2[2])+100,5);
   end;
   closegraph;
end.

