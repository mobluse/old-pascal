{ AUTOCORRELATOR simulator
  Programmer: Mikael Bonnier.
  Location: Lund, Sweden.
  Datum: 8th July 1990. MCMXC.
  Language: Turbo Pascal 5.5 }

{$N+,R-,S-}

program autocorrelator;

uses crt,graph;

const channels=32;
      dtau=0.0003125;{s}
      dt=1e-4;       {s}
      TST=2;         {s}
      longfreq=50;   {Hz}

type corchs=array[1..channels] of real;

var i:byte;
    G:corchs;
    t,endtime:double;
    shrink,mincnt,maxcnt:real;
    corrdata:text;
    filename:string;
    maxx,maxy:integer;
    maxcolor:word;
    driver,mode:integer;



function Intensity(t1:real):real;

    begin
        Intensity:=sqr(cos(2*pi*longfreq*t1));
    end;




procedure minmax(var G1:corchs;var min1,max1:real);

          var j:byte;

          begin
               min1:=G1[1];
               max1:=G1[1];
               for j:=2 to channels do
                   begin
                        if G1[j]<min1 then min1:=G1[j];
                        if G1[j]>max1 then max1:=G1[j];
                   end;
          end;



procedure frame;
          begin
               moveto(0,0);
               lineto(0,maxy);
               lineto(maxx div 2,maxy);
               lineto(maxx div 2,0);
               lineto(0,0);
          end;




begin
     writeln('Autokorrelator simulator.');
     write('Ange filnamn: ');
     readln(filename);
     assign(corrdata,filename);
     rewrite(corrdata);
     randomize;
     t:=1/longfreq*random;
     endtime:=TST+t;
     driver:=detect;
     initgraph(driver,mode,'');
     maxx:=getmaxx;
     maxy:=getmaxy;
     frame;
     for i:=1 to channels do
         G[i]:=0;
     repeat
           for i:=1 to channels do
               begin
                    G[i]:=G[i]+Intensity(t)*Intensity(t-i*dtau);
                   {putpixel(i*(maxx div (2*channels)),maxy-round(G[i]) mod maxy+1,0);
                    putpixel(i*(maxx div (2*channels)),maxy-round(G[i]) mod maxy,1);
                    writeln(i,'  ',G[i]);}
               end;
           t:=t+dt;
     until t>endtime;
     minmax(G,mincnt,maxcnt);
     shrink:=maxy/(maxcnt-mincnt);
     cleardevice;
     frame;
     for i:=1 to channels do
         begin
              writeln(corrdata,i,G[i]/TST);
              putpixel(i*(maxx div (2*channels)),maxy-round(shrink*(G[i]-mincnt)),1);
         end;
     close(corrdata);
end.