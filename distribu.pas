(* Copyright (c) 1990,1993, Mikael Bonnier.
   DISTRIBUTION. A program that demonstrates random functions.
   Programmer: Mikael Bonnier.
   Location: Lund, Sweden.
   Datum: 14th December 1990. MXM. Utvidgat 21st Jan 1993. MXMIII.
   Language: Turbo Pascal 5.0
*)

{$F+,R-,S-} { hispeed on }

program distribution;

uses crt,graph;

type intfunctype=function:integer;

var selected:intfunctype;
    y:array[0..2000] of integer;
    maxx,maxy,mn,m,sd:integer;
    maxcolor:word;
    i:byte;
    slut:boolean;
    boltzstat:integer;
    x1,x2,xx1,xx2:integer;
    level:integer;
    maxpart:longint;
    driver,mode:integer;
    s:string;


function linear:integer;

  begin
    linear:=random(maxx);
  end; (* linear *)


function triangular:integer;

  begin
    triangular:=(random(maxx)+random(maxx)) div 2;
  end; (* triangular *)


function normal1:integer;

  begin
    (* variance=2*m*m *)
    normal1:=mn+round(m*ln(random/random));
  end; (* normal1 *)


function normal2:integer;  (* Box and Muller method *)

  begin
    normal2:=mn+round(sd*sqrt(-2*ln(random))*sin(2*pi*random));
  end; (* normal2 *)


function poisson:integer;

  var t:real;
      counts:integer;

  begin
    t:=0;
    counts:=-1;
    nosound;
    repeat
      t:=t-ln(1-random)/mn;
      inc(counts);
    until t>0.25;
    poisson:=4*counts;
  end; (* poisson *)


function boltzmann:integer;

  var p1,p2,
      sum:integer;

  begin
    if boltzstat=0 then begin
       p1:=random(maxpart);
       repeat
         p2:=random(maxpart);
       until p2<>p1; (* Partikeln kan inte kollidera med sig själv! *)
       x1:=0;
       while p1>=0 do begin
         p1:=p1-y[x1];
         inc(x1);
       end;
       dec(x1);
       x2:=0;
       while p2>=0 do begin
         p2:=p2-y[x2];
         inc(x2);
       end;
       dec(x2);
       sum:=x1+x2;
       xx1:=random(sum+1);
       xx2:=sum-xx1;
     end; (* if boltzstat=0 *)
     case boltzstat of
       0: boltzmann:=-x1-1;
       1: boltzmann:=xx1;
       2: boltzmann:=-x2-1;
       3: boltzmann:=xx2;
     end;
     inc(boltzstat);
     boltzstat:=boltzstat mod 4;
   end; (* boltzmann *)

function initdistr(start, stop:integer; level:longint):longint;

  var x:integer;

  begin
    setcolor(15);
    for x:=0 to start-1 do
      y[x]:=0;
    for x:=start to stop do begin
      y[x]:=level;
      line(x,maxy,x,maxy-y[x])
    end;
    for x:=stop+1 to maxx-1 do
      y[x]:=0;
    initdistr:=(stop-start+1)*level
  end; (* initdistr *)


procedure plotdistr(distr:intfunctype);

  label 10;
  var x:integer;

  begin
    slut:=true;
    repeat
      x:=distr;
      sound(9*x+50);
      if (0<=x) then begin
        inc(y[x]);
        putpixel(x,maxy-y[x],15)
      end
      else begin
        inc(x);
        x:=-x;
        putpixel(x,maxy-y[x],0);
        dec(y[x]);
      end;
      slut:=false;
    until slut or keypressed;
    nosound;
    if keypressed then
      if readkey=chr(27) then
        goto 10;
    settextstyle(smallfont,horizdir,5);
    if getpixel(maxx div 2,maxy-maxy div 13)<>0 then
      setcolor(0)
    else
      setcolor(maxcolor);
    outtextxy(maxx div 6,maxy-maxy div 12,'Press a key to continue with next distribution. ESC to quit.');
    if i=0 then begin
       outtextxy(maxx div 6, maxy-maxy div 24, 'DISTRIBUTION. Copyright (c) 1990,1993 by Mikael Bonnier.');
    end;
    if readkey=chr(27) then begin
10:   chdir(s);
      halt;
    end;
  end; (* plotdistr *)

begin
  getdir(0,s);
  chdir('c:\tp\bgi');
  randomize;
  driver:=detect;
  initgraph(driver,mode,'');
  maxx:=getmaxx+1;
  maxy:=getmaxy+1;
  maxcolor:=getmaxcolor;
  mn:=maxx div 2;
  m:=maxx div 8;
  sd:=maxx div 6;
  i:=0;
  while true do begin
    cleardevice;
    setcolor(i+1);
    settextstyle(triplexfont,horizdir,4);
    case i of
      0: begin
           selected:=linear;
           outtext('The linear distribution.');
           maxpart:=initdistr(0,maxx-1,0);
         end;
      1: begin
           selected:=triangular;
           outtext('The triangular distribution.');
           maxpart:=initdistr(0,maxx-1,0);
         end;
      2: begin
           selected:=normal1;
           outtext('A crude normal distribution.');
           maxpart:=initdistr(0,maxx-1,0);
         end;
      3: begin
           selected:=normal2;
           outtext('The beautiful normal distribution.');
           maxpart:=initdistr(0,maxx-1,0);
         end;
      4: begin
           selected:=poisson;
           outtext('The Poisson distribution.');
           maxpart:=initdistr(0,maxx-1,0);
         end;
      5: begin
           selected:=boltzmann;
           outtext('The Boltzmann distribution.');
           boltzstat:=0;
           maxpart:=initdistr(100,120,maxy-1);
         end;
    end; (* case i *)
    plotdistr(selected); (* halt may be called in this function *)
    inc(i);
    i:=i mod 6;
  end; (* while true *)
end.

End of this program called DISTRIBUTION. /MB