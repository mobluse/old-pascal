program cgatest; { Mikael Bonnier 1989 }

   uses graph,crt;

   var graphdriver,graphmode,err:integer;

begin
   graphdriver:=CGA;
   graphmode:=CGAHi;
   initgraph(graphdriver,graphmode,'');
   if graphresult < 0 then halt(1);
   outtextxy(100,100,'hejsan!');
   lineto(0,50);
   linerel(0,10);
   linerel(10,0);
   linerel(0,-10);
   linerel(-10,0);
   repeat until keypressed;
   cleardevice;
   circle(320,100,10);
   readln;
   closegraph;
end.
