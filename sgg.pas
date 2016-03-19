program SGG(input,output);

{ Simulated Galaxy-Galaxy Collision, SGG version 1.1.
  Program written by Mikael Bonnier.
  Copyright 1989,1990.
  TurboPascal 5.0, Req CGA.
  The file CGA.BGI must be in current directory. }

   {$N+,R-,S-} { uses 8087 if available }

   uses graph,crt;

   const a=11;
         maxnr=1716; { maxrings=49 if maxnr=1715 }

   type vector=array[1..3] of real;

   var pos,vel:array[1..maxnr] of vector; { maxnr stars,
                                            3 dimensions x,y,z }
       jmax:integer; { number of stars }
       rings:integer;
       m1,m2:real;
       pos1,pos2,vel1,vel2:vector;
       theta,phi:real;

   procedure xyz_xy(point:vector; var xo,yo:integer); { 3D -> 2D }
      const s=2000;
            maxy=199;
   begin
      xo:=trunc((s*point[1])/(s+point[2]))+160;
      yo:=trunc((s*point[3])/(s+point[2]))+100;
      yo:=maxy-yo;
   end;


   procedure getparameters;

      var rrings:real;

   begin
      assign(input,'');
      reset(input);
     {textmode(co80);}
      clrscr;
      textcolor(red+blink);
      writeln('Tides between close-encountering Galaxies.');
      textcolor(blue);
      writeln;
      writeln('Galaxy number 1 is bestared, number 2 is a naked nuclus.');
      textcolor(lightmagenta);
      write('m1: ');
      readln(m1);
      write('rings: ');
      readln(rrings);
      while rrings*(2*a+rrings-1)/2 >= maxnr do
        begin
          write('To many rings. Input rings: ');
          readln(rrings);
        end;
      rings:=round(rrings);
      textcolor(blue);
      writeln('In the plane y=0 distance units is equal to pixel units, -160<x<160,-100<z<100.');
      textcolor(lightmagenta);
      write('pos1 (x y z): ');
      readln(pos1[1],pos1[2],pos1[3]);
      textcolor(blue);
      writeln('Speed is given in distance units per unit-time.');
      writeln('Two frames is 1 time unit apart.');
      textcolor(lightmagenta);
      write('vel1 (vx vy vz): ');
      readln(vel1[1],vel1[2],vel1[3]);
      write('Θ (in °): ');
      readln(theta);
      theta:=theta*pi/180;
      write('Φ (in °): ');
      readln(phi);
      phi:=phi*pi/180;
      write('m2: ');
      readln(m2);
      write('pos2 (x y z): ');
      readln(pos2[1],pos2[2],pos2[3]);
      write('vel2 (vx vy vz): ');
      readln(vel2[1],vel2[2],vel2[3]);
      textcolor(lightgray);
      writeln('If key pressed, program exits.');
      write('Calculating initial positions');
   end; { getparameters }


   procedure graphinit;

      var graphdriver,graphmode,err:integer;

   begin
      graphdriver:=CGA;
      graphmode:=CGAC3;
      initgraph(graphdriver,graphmode,'');
      if graphresult<0 then halt(1);
      cleardevice;
   end;


   procedure setstars;

      const dr=3;

      var r,Alpha,dAlpha,v,startangle,omega,rho:real;
          n,i,j:integer;

   begin
      randomize;
      j:=0;
      for n:=a to (a+rings-1) do
        begin
          write('.');
          dAlpha:=2*pi/n;
          r:=n*dr;
          v:=sqrt(m1/r);
          startangle:=2*pi*random;
          for i:=1 to n do
            begin
              Alpha:=i*dAlpha+startangle; { make galaxy look
                                                 unorganized }
              j:=j+1;
              pos[j,1]:=r*cos(Alpha);
              pos[j,2]:=r*sin(Alpha);
              pos[j,3]:=0;
              vel[j,1]:=v*(-sin(Alpha));
              vel[j,2]:=v*cos(Alpha);
              vel[j,3]:=0;
            end;
        end;
      jmax:=j; { jmax equals number of stars }
      writeln;
      write('Making the theta- and phi-transformations..');
      for j:=1 to jmax do
        begin
          { theta-transformation }
          pos[j,3]:=pos[j,1]*(-sin(theta));
          { pos[j,2]:=pos[j,2]; }
          pos[j,1]:=pos[j,1]*cos(theta);
          vel[j,3]:=vel[j,1]*(-sin(theta));
          { vel[j,2]:=vel[j,2]; }
          vel[j,1]:=vel[j,1]*cos(theta);
          { phi-transformation }
          if pos[j,1]=0 then
             if pos[j,2]>0 then
                omega:=pi/2
             else
                omega:=-pi/2
          else
             begin
               omega:=arctan(pos[j,2]/pos[j,1]);
               if pos[j,1]<0 then omega:=omega+pi;
             end;
          rho:=sqrt(sqr(pos[j,1])+sqr(pos[j,2]));
          pos[j,1]:=rho*cos(omega+phi);
          pos[j,2]:=rho*sin(omega+phi);
          { pos[j,3]:=pos[j,3]; }
          if vel[j,1]=0 then
             if vel[j,2]>0 then
                omega:=pi/2
             else
                omega:=-pi/2
          else
             begin
               omega:=arctan(vel[j,2]/vel[j,1]);
               if vel[j,1]<0 then omega:=omega+pi;
             end;
          rho:=sqrt(sqr(vel[j,1])+sqr(vel[j,2]));
          vel[j,1]:=rho*cos(omega+phi);
          vel[j,2]:=rho*sin(omega+phi);
          { vel[j,3]:=vel[j,3]; }
        end;
        for j:=1 to jmax do
           for i:=1 to 3 do
              begin
                vel[j,i]:=vel[j,i]+vel1[i];
                pos[j,i]:=pos[j,i]+pos1[i];
              end;
   end; { setstars }


   procedure display;

      var temppos:vector;
          radi,ydump,x,y:integer;
          j:integer;

   begin
      cleardevice;
      temppos[1]:=15;
      temppos[2]:=pos2[2];
      temppos[3]:=0;
      xyz_xy(temppos,radi,ydump);
      radi:=radi-160;
      xyz_xy(pos2,x,y);
      setcolor(2);
      circle(x,y,radi);
      temppos[2]:=pos1[2];
      xyz_xy(temppos,radi,ydump);
      radi:=radi-160;
      xyz_xy(pos1,x,y);
      setcolor(1);
      circle(x,y,radi);
      for j:=1 to jmax do
        begin
          xyz_xy(pos[j],x,y);
          putpixel(x,y,1);
        end;
      write(chr(7)); { beep }
   end; { display }


   function absvec(point:vector):real;
   begin
      absvec:=sqrt(sqr(point[1])+sqr(point[2])+sqr(point[3]));
   end;


   procedure moveobjects;

      const dt=0.1;

      var r1,r2,acc:vector;
          absr1,absr2:real;
          i,j,x,times:integer;
   begin
     times:=round(1/dt);
     for x:=1 to times do
       begin
         if keypressed then exit;
         for i:=1 to 3 do
         r1[i]:=pos2[i]-pos1[i];
         absr1:=absvec(r1);
         for i:=1 to 3 do
           begin
             acc[i]:=m2*r1[i]/(sqr(absr1)*absr1);
             vel1[i]:=vel1[i]+acc[i]*dt;
             pos1[i]:=pos1[i]+vel1[i]*dt;
             acc[i]:=-m1*r1[i]/(sqr(absr1)*absr1);
             vel2[i]:=vel2[i]+acc[i]*dt;
             pos2[i]:=pos2[i]+vel2[i]*dt;
           end;
         for j:=1 to jmax do
           begin
             for i:=1 to 3 do
               begin
                 r1[i]:=pos1[i]-pos[j,i];
                 r2[i]:=pos2[i]-pos[j,i];
               end;
             absr1:=absvec(r1);
             absr2:=absvec(r2);
             for i:=1 to 3 do
              begin
               acc[i]:=m1*r1[i]/(sqr(absr1)*absr1)
                      +m2*r2[i]/(sqr(absr2)*absr2);
               vel[j,i]:=vel[j,i]+acc[i]*dt;
               pos[j,i]:=pos[j,i]+vel[j,i]*dt;
              end;
           end;
       end; { x-loop}
   end; { moveobjects }


begin { SGG main }
   getparameters;
   setstars;
   graphinit;
   repeat
     display;
     moveobjects;
   until keypressed;
   textmode(co80);
end.
