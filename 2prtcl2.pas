program twoparticle; (* file: 2prtcl2.pas *)
(* Tvådimensionell tvåpartikelsimulering, klassisk mekanik. *)
(* Copyright (C) 1992  Mikael Bonnier, Lund, Sweden. *)
(* Programspråk: Turbo Pascal 5.5 *)
(* SI-enheter *)

uses  graph;

const dt = 0.5E-3; (* (s) tidssteg *)
      tmax = 10; (* (s) tid sen start då simulering slutar *)
      nmax = 10; (* tiden nmax*dt (s) mellan varje utritning *)
      e = +1.60E-19; (* (C) elementarladdningen *)
      me = 0.911E-30; (* (kg) elektronens massa *)
      g = -0; (* (N/kg) tyngdfaktorn/accelerationen *)
      k = 8.99E9; (* (Nm^2/C^2) konstanten i Coulombs lag. *)

type  dirn = (x, y); (* uppräknad datatyp *)

var   m, (* (kg) massan hos partikel 1, respektive hos part 2. *)
      q: array[1..2] of real; (* (C) laddningen hos part 1, resp part 2. *)
      F, (* (N) kraften på part 1 från part 2, respektive på 2 från 1. *)
      a, (* (m/s^2) accelerationen hos 1 resp 2. *)
      v, (* (m/s) hastigheten hos 1 resp 2. *)
      r: array[1..2, x..y] of real; (* (m) positionen hos 1 resp 2. *)
      t, (* (s) aktuell tid. *)
      d2, (* (m^2) kvadraten på avståndet mellan 1 och 2. *)
      C: real; (* (N/m) faktor för att snabba upp beräkning av Coulombs lag. *)
      i: 1..2; (* partikel-nummer *)
      j: dirn; (* riktnings-nummer *)
      n, (* loop-räknare *)
      gd, gm: integer; (* graph-variabler *)

begin
   (* Exempel på begynnelsevärden: *)
   (* Dubbelstjärna *)
   m[1] := me;
   q[1] := +e;
   r[1][x] := -3;   r[1][y] :=  0;
   v[1][x] :=  0;   v[1][y] :=  2;

   m[2] := 2*me;
   q[2] := -e;
   r[2][x] :=  3;   r[2][y] :=  0;
   v[2][x] :=  0;   v[2][y] := -1;

   (* Samma laddning *)
(*   m[1] := me;
   q[1] := +e;
   r[1][x] := -3;   r[1][y] :=  2;
   v[1][x] := 16;   v[1][y] := -5;

   m[2] := 2*me;
   q[2] := +e;
   r[2][x] :=  3;   r[2][y] :=  0;
   v[2][x] := -7;   v[2][y] :=  2.5;
*)
   (* Motsatt laddning, sätt g = -11 *)
(*   m[1] := me;
   q[1] := +e;
   r[1][x] := -3;   r[1][y] :=  2;
   v[1][x] :=  7;   v[1][y] := -3;

   m[2] := 2*me;
   q[2] := -e;
   r[2][x] :=  3;   r[2][y] :=  0;
   v[2][x] := -4;   v[2][y] :=  2.5;
*)
   (* Slunga *)
(*   m[1] := me;
   q[1] := +e;
   r[1][x] :=  3;   r[1][y] :=  1.2;
   v[1][x] :=-12;   v[1][y] := -0.5;

   m[2] := 50*me;
   q[2] := -10*e;
   r[2][x] := -3;   r[2][y] :=  0;
   v[2][x] :=  9;   v[2][y] :=  0;
*)

   t := 0;
                
   gd := detect; initgraph(gd,gm,'\bgi'); if graphresult<>grok then halt(1);
     (* startar grafikmode *)

   while(t<=tmax) do begin
     for n:=1 to nmax do begin
       d2 := sqr(r[1][x]-r[2][x]) + sqr(r[1][y]-r[2][y]); (* Pythagoras sats *)
       C := k*q[1]*q[2]/(sqrt(d2)*d2);
       for j:=x to y do begin (* loop över riktningarna *)
         F[1][j] := C*(r[1][j]-r[2][j]);  (* Coulombs lag, elektriska kraften *)
         (* Magnetiska kraften försummas, ty låg hastighet *)
         (* Newtons 4:e lag, gravitationskraften mellan partiklarna försummas *)
         F[2][j] := -F[1][j]; (* Newtons 3:e lag, reaktionskraften *)
         for i:=1 to 2 do begin (* loop över partiklarna *)
           F[i][y] := F[i][y] + m[i]*g; (* beräknas 2 gånger, beklagar... *)
             (* yttre gravitationsfält, g *)
           a[i][j] := F[i][j]/m[i]; (* Newtons 2:a lag för partikel i *)
           v[i][j] := v[i][j] + a[i][j]*dt; (* ny hastighet för partikel i *)
           r[i][j] := r[i][j] + v[i][j]*dt; (* ny position för partikel i *)
         end; (* for i... *)
       end; (* for j... *)
     end; (* for n... *)
     t := t + nmax*dt;
(*     writeln('t=',t:6:2,'; r1x=',r[1][x]:5:1,'; r1y=',r[1][y]:5:1,
              '; r2x=',r[2][x]:5:1,'; r2y=',r[2][y]:5:1);*)
     cleardevice;
(*     circle(trunc(100*r[1][x])+320,-trunc(50*r[1][y])+100,2);
     circle(trunc(100*r[2][x])+320,-trunc(50*r[2][y])+100,5);*)
     moveto(trunc(100*r[1][x])+320,-trunc(50*r[1][y])+100);
     outtext('+');
     moveto(trunc(100*r[2][x])+320,-trunc(50*r[2][y])+100);
     outtext('o');
   end; (* while(t...) *)
(*   closegraph;*)
end.
