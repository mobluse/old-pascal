
PROGRAM elektriskalinser;

CONST nx=30    (*celler i x-led*);
      ny=15    (*celler i y-led*);
      nx1=7    (*se figur*);
      nx2=13   (*se figur*);
      nx3=17;
      nx4=27;
      ny1=5;
      ny2=4;
      ny3=12;
      ny4=11;
      u0=0     (*rand och start potential*);
      u1=40    (*positiv plattpotential*);
      u2=-40   (*negativ plattpotential*);

VAR   i,j      :integer;
      s,delta,maxfel:real;
      u,v      :array[1..nx,1..ny] of real;
      eslask:text;

BEGIN Assign(eslask,'slask.txt');
      Rewrite(eslask);
      Writeln(eslask,nx,' ',ny,' ',nx1,' ',nx2,' ',nx3,' ',nx4);
      Writeln(eslask,ny1,' ',ny2,' ',ny3,' ',ny4);
      Writeln(eslask,u0,' ',u1,' ',u2);

      (*startv„rden*);
      FOR i:=1 TO nx DO
      FOR j:=1 TO ny DO
      BEGIN u[i,j]:=0;   v[i,j]:=0;  END;

      (*randv„rden*);
      FOR i:=nx1 TO nx2 DO
      BEGIN u[i,ny1]:=u1;
            u[i,ny4]:=u1;
      END;
      FOR i:=nx3 TO nx4 DO
      BEGIN u[i,ny2]:=u2;
            u[i,ny3]:=u2;
      END;
      s:=1;
      maxfel:=1;
      REPEAT FOR i:=2 TO nx-1 DO
             FOR j:=2 TO ny-1 DO
             IF ((((j=ny1) OR (j=ny4)) AND ((i>=nx1) AND (i<=nx2))) OR
                (((j=ny2) OR (j=ny3)) AND ((i>=nx3) and (i<=nx4))))
                THEN v[i,j]:=u[i,j]
                ELSE v[i,j]:=(u[i+1,j]+u[i-1,j]+u[i,j+1]+u[i,j-1])/4;
             delta:=0;
             FOR i:=1 TO nx DO
             FOR j:=1 TO ny DO
             BEGIN delta:=delta+abs(u[i,j]-v[i,j]);
                   u[i,j]:=v[i,j];
             END;
             Writeln('ANTAL IT=',s:4:0,'       u(5,6)=',u[5,6]:2:4,'  delta=',delta:3:4);
             s:=s+1;
      UNTIL delta<0.1;
      FOR i:=1 TO nx DO
      FOR j:=1 TO ny DO
      Writeln(eslask,u[i,j]);
      close(eslask);
END.

