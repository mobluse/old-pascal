{$R-}    {Range checking off}
{$B+}    {Boolean complete evaluation on}
{$S+}    {Stack checking on}
{$I+}    {I/O checking on}
{$N-}    {No numeric coprocessor}
{$M 65500,16384,655360} {Turbo 3 default stack and heap}

program LABELLINSPAS;
{ $U+,C+}
{!^ 1. Directives A,B,C,D,F,G,P,U,W,X are obsolete or changed in meaning}

Uses
  Crt,
  Printer,
  Graph3;

VAR nx,ny,      (*dimension*)
    nx1,nx2,nx3,nx4,
    ny1,ny2,ny3,ny4,  (*koordinater for elektroder*)
    i,j,pt,k,i1,j1,
    x1,y1,x2,y2,
    xp1,yp1,xp2,yp2   :INTEGER;
    vo,v1,v2,x,y,
    xny,yny,vx,vy,
    n,uo,yo,xbi,fl,
    gl,hb,hk,rq,vp,
    xi,yi,fo,fb       :REAL;
    v                 :ARRAY[1..40,1..40] of REAL;
    styr,rpl,fortsatt,
    sluv              :CHAR;
    eslask,plt        :TEXT;

PROCEDURE print;
          BEGIN GotoXY(1,1);
                Writeln(i,'  ',j,'  ',i1,'  ',j1,'  ',k);
                Writeln(x1,'  ',y1,'  ',x2,'  ',y2);
                Writeln(x,y,xi,yi);
                Read(i);
          END;

PROCEDURE fxbox(x1,y1,x2,y2:INTEGER);
          BEGIN
                Draw(x1,y1,x2,y1,1);
                Draw(x2,y1,x2,y2,1);
                Draw(x2,y2,x1,y2,1);
                Draw(x1,y2,x1,y1,1);
          END;

PROCEDURE ask(n1,n2,n3:INTEGER);
          BEGIN xp1:=Round((n1-1.5)*500/30+50+8);
                xp2:=Round((n2-0.5)*500/30+50-8);
                yp1:=Round(-(n3-1-ny/2)*170/15+100-4);
                yp2:=Round(-(n3-ny/2)*170/15+100+4);
                fxbox(xp1,yp1,xp2,yp2);
                IF (rpl='J') THEN
                BEGIN
                     xp1:=Round(2000+(n1-1.5)*9840/29+80);
                     xp2:=Round(2000+(n2-0.5)*9840/29-80);
                     yp1:=Round(2000+(n3-1.5)*7120/14+150);
                     yp2:=Round(2000+(n3-0.5)*7120/14-150);
                     Write(plt,'PU',xp1:6,yp1:6);
                     Write(plt,'PD,EA',xp2:6,yp2:6);
                     Write(plt,'PU',xp1:6,yp1:6);
                END;
         END;

PROCEDURE utett;
          BEGIN k:=1;
                xi:=i1-1;
                yi:=j1-0.5 -ny/2-(v[i1,j1]-vp)/(v[i1,j1]-v[i1,j1-1]);
          END;

PROCEDURE uttvo;
          BEGIN k:=2;
                xi:=i1-1;
                yi:=j1-0.5-ny/2+(v[i1,j1]-vp)/(v[i1,j1]-v[i1,j1+1]);
          END;

PROCEDURE uttre;
          BEGIN k:=3;
                xi:=i1-1+(v[i1,j1]-vp)/(v[i1,j1]-v[i1+1,j1]);
                yi:=j1-0.5-ny/2;
          END;

PROCEDURE utfyr;
          BEGIN k:=3;
                xi:=i1-1-(v[i1,j1]-vp)/(v[i1,j1]-v[i1-1,j1]);
                yi:=j1-0.5-ny/2;

          END;

PROCEDURE inett;
          BEGIN IF v[i1+1,j1]<vp
                   THEN uttre
                   ELSE IF v[i1+1,j1-1]<vp
                        THEN BEGIN i1:=i1+1; utett; END
                        ELSE BEGIN i1:=i1+1; j1:=j1-1; utfyr; END;
          END;

PROCEDURE intvo;
          BEGIN IF v[i1-1,j1]<vp
                   THEN utfyr
                   ELSE IF v[i1-1,j1+1]<vp
                           THEN BEGIN i1:=i1-1; uttvo; END
                           ELSE BEGIN i1:=i1-1; j1:=j1+1; uttre; END;
          END;

PROCEDURE intre;
          BEGIN IF v[i1,j1+1]<vp
                   THEN uttvo
                   ELSE IF v[i1+1,j1+1]<vp
                           THEN BEGIN j1:=j1+1; uttre; END
                           ELSE BEGIN i1:=i1+1; j1:=j1+1; utett; END;
          END;

PROCEDURE infyr;
          BEGIN IF v[i1,j1-1]<vp
                   THEN utett
                   ELSE IF v[i1-1,j1-1]<vp
                           THEN BEGIN j1:=j1-1; utfyr; END
                           ELSE BEGIN i1:=i1-1; j1:=j1-1; uttvo; END;
          END;



PROCEDURE initiate;
         BEGIN
               fl:=1;   gl:=1;
               GotoXY(1,1);
               Write('                                                            ');
               Write('                  ');
               GotoXY(1,1);
               Write('Giv Y-koordinaten f”r x=0  ');
               Read(y);
               yo:=y;
               IF rq<0 THEN GotoXY(1,1) ELSE Writeln;
               x:=0;
               Write('Giv den infallande elektronens enengi i eV  ');
               Read(uo);
               IF rq<0 THEN GotoXY(1,1) ELSE  Writeln;
               Write('      Giv elektronk„llans avst†nd fr†n y-axeln  ');
               Read(xbi);
               IF rq<0 THEN GotoXY(1,1) ELSE  Writeln;
               Write('       Utskrift av data p† plotter?   J/N          ');
               Read(sluv);  Writeln;
               IF sluv='j' THEN sluv:='J';
               IF rq>0 THEN HiRes;
               xbi:=Abs(xbi);
               IF xbi>1e4 THEN fl:=-1;
               n:=5;
               vx:=1;
               vy:=vx*y/xbi;
               IF rq>0 THEN
           BEGIN
               IF ((rpl='J') AND (sluv='J')) THEN
               BEGIN
                    Write(plt,'SP 1;');
                    Write(plt,'PU5200,1000;');
                    Write(plt,'LBPOTENTIALFALT I EN ELEKTRISK LINS',Char(3));
                    Write(plt,'PU2000,600;');
                    Write(plt,'LBV1=', v1:4:2, Char(3));
                    Write(plt,'PU5200,600;');
                    Write(plt,'LBV2=', v2:4:2, Char(3));
                    Write(plt,'PU2000,2000;');
                    Write(plt,'PD,EA11840,9120;');
                    Write(plt,'PU200,200;');
                    Write(plt,'LBINFALLANDE ELEKTRONENS ENERGI=', UO:6:2,
                               Char(3),'LBeV',Char(3));
                    Write(plt,'PU5200,200;');
                    Write(plt,'LBKALLANS AVSTAND FRAN LINSEN=', xbi:10:2,Char(3));
                    Write(plt,'PU,10000,200;');
                    Write(plt,'LBY(x=0) = ', yo:4:2,Char(3));
               END;
               fxbox(50,15,550,185);
               ask(nx1,nx2,ny1);
               ask(nx1,nx2,ny4);
               ask(nx3,nx4,ny2);
               ask(nx3,nx4,ny3);
               rq:=-1;
           END;
               x1:=Round(x*500/30+50);
               y1:=Round(-y*170/15+100);
               xp1:=Round(2000+x*9840/29);
               yp1:=Round(5560+y*7170/14);
               IF (rpl='J') OR (rpl='j') THEN
               BEGIN Write(plt,'SP 2;');
                     Write(plt,'PU',xp1:6,yp1:6);
                     Write(plt,'PD',xp1:6,yp1:6);
               END;
         END;

PROCEDURE step;
          var xi,yi,a,b,fx,fy  :REAL;
          BEGIN
              REPEAT
                    i:= trunc(x+1+0.5);
                    j:=trunc(y+1+ny/2);
                    xi:=x+1-i;
                    yi:=y+0.5+ny/2-j;
                    IF NOT((((i>=nx1) AND (i<=nx2))
                       AND ((j=ny1) OR (j=ny4))) OR
                        (((i>=nx3) AND (i<=nx4))
                        AND ((j=ny2) OR (j=ny3)))) THEN
                        BEGIN a:=(v[i+1,j]+v[i-1,j])/2-v[i,j];
                              b:=(v[i+1,j]-v[i-1,j])/2;
                              fx:=a*xi/0.5+b;
                              a:=(v[i,j+1]+v[i,j-1])/2-v[i,j];
                              b:=(v[i,j+1]-v[i,j-1])/2;
                              fy:=2*a*yi+b;
                              vx:=vx+fx/(2*n*uo);
                              vy:=vy+fy/(2*n*uo);
                              xny:=x+vx/n;
                              yny:=y+vy/n;
                              x2:=Round(xny*500/30+50);
                              y2:=Round(-yny*170/15+100);
                              Draw(x1,y1,x2,y2,1);
                              x1:=x2;
                              y1:=y2;
                              xp2:=Round(2000+xny*9840/29);
                              yp2:=Round(5560+yny*7120/14);
                              IF (rpl='j') or (rpl='J') THEN
                              Write(plt,'PD',xp2:6,yp2:6);
                              x:=xny;
                              y:=yny;
                              xp1:=xp2;
                              yp1:=yp2;
                         END
                         ELSE xny:=nx+20;
              UNTIL xny>nx-1.5;
          END;


PROCEDURE printfield;
          BEGIN
                Write(Lst,Chr(27),'3',Chr(36));
                Write(lst,'     ');
                FOR j:=1 TO ny DO
                BEGIN IF j<9.5 THEN  Write(lst,' ');
                      Write(lst,' ',j,'  ');
                END;
                Writeln(lst);
                Writeln(lst,' ');
                Writeln(lst);
                FOR i:=1 TO nx DO
                BEGIN IF i<9.5 THEN  Write(lst,' ');
                      Write(lst,i,'   ');
                      FOR j:=1 TO ny DO
                      BEGIN
                           pt:=Round(v[i,j]);
                           IF Abs(pt)<9.5 THEN Write(lst,' ');
                           IF pt>=0 THEN Write(lst,' ');
                           Write(lst,pt,'  ');
                      END;
                      Writeln(lst);
                      Writeln(lst);
                END;
           END;

PROCEDURE banplot;
          VAR xbild,yslut      :REAL;
              qw               :CHAR;
              BEGIN  rq:=1;
                   ClrScr;
                   REPEAT
                         initiate;

                         rq:=-1;
                         step;
                         IF xny<nx+10 THEN
                         BEGIN
                              xbild:=-yny*vx/vy+xny;
                              yslut:=-(xbild-nx+1)*vy/vx;
                              IF Abs(xbild)>1e4 THEN gl:=-1;
                              GotoXY(1,1);
                              Write('x f”r bildpunkt b=',xbild:3:2);
                              Write('     y f”r x=N1-1   y2=',yslut:1:2);
                              IF fl<0 THEN
                              BEGIN GotoXY(1,25);
                                    hb:=xbild+yo*vx/vy;
                                    Write('x f”r bildhpl  hb=',hb:5:2);
                                    fb:=xbild-hb;
                                    Write('      br„nnvidden  fb=',fb:5:2);
                              END;
                              IF gl<0 THEN
                              BEGIN GotoXY(1,25);
                                    hk:=yny/yo*xbi-xbi;
                                    Write('x f”r objekthpl  ho=',hk:5:2);
                                    fo:=xbi+hk;
                                    Write('     br„nnvidden fo=',fo:5:2);

                              END;
                         END
                         ELSE
                         BEGIN GotoXY(1,1);

                               Write('                                                            ');
                               Write('                 ');
                               GotoXY(1,1);
                         END;
                         GoToXY(57,1);
                         Write('Fler ber„kningar? J/N');
                         Read(qw);
                         GoToXY(1,25);
                         Write('                                  ');
                         Write('                                  ');
                         IF rpl='J' THEN
                         BEGIN Write(plt,'PU',xp1:6,yp1:6);
                               Write(plt,'sp 0;');
                         END;
                   UNTIL (qw='n') OR (qw='N');
               END;

PROCEDURE ekviplot;
          VAR st,sl,vst,v3     :REAL;
          BEGIN ClrScr;
                GotoXY(1,1);
                Write('Giv differens mellan ekvipotentiallinjer  ');
                Read(v3);
                HiRes;
                IF (rpl='J') THEN
               BEGIN
                    Write(plt,'SP 1;');
                    Write(plt,'PU5200,1000;');
                    Write(plt,'LBPOTENTIALFALT I EN ELEKTRISK LINS',Char(3));
                    Write(plt,'PU2000,600;');
                    Write(plt,'LBV1=', v1:4:2, Char(3));
                    Write(plt,'PU5200,600;');
                    Write(plt,'LBV2=', v2:4:2, Char(3));
                    Write(plt,'PU8400,600;');
                    Write(plt,'LBDV=', v3:4:2,Char(3));
                    Write(plt,'PU2000,2000;');
                    Write(plt,'PD,EA11840,9120;');
                    write(plt,'PU2000,2000;');
               END;
               fxbox(50,15,550,185);
               ask(nx1,nx2,ny1);
               ask(nx1,nx2,ny4);
               ask(nx3,nx4,ny2);
               ask(nx3,nx4,ny3);
               IF v2<v1
                  THEN BEGIN st:=v1-v3;    sl:=v2+v3-0.01;    END
                  ELSE BEGIN st:=-(v1-v3); sl:=-(v2+v3-0.01); END;
                  vp:=st;
                  REPEAT
                     IF rpl='J' THEN
                        IF vp>0.2
                        THEN Write(plt,'SP 2;')
                        ELSE IF vp>-0.2
                                THEN Write(plt,'SP 3;')
                                ELSE Write(plt,'SP 4;');
                     FOR j:=2 TO ny-1 DO
                     FOR i:=2 TO nx   DO
                     IF ((v[i,j]-vp)*(v[i-1,j]-vp))<0
                        THEN BEGIN i1:=i;
                                   j1:=j;
                                   IF (v[i,j]-vp)>0
                                      THEN BEGIN x:=i-1-(v[i,j]-vp)/(v[i,j]-v[i-1,j]);
                                                 y:=j-0.5-ny/2;
                                                 infyr;
                                           END
                                      ELSE BEGIN i1:=i1-1;
                                                 x:=i-2+(v[i-1,j]-vp)/(v[i-1,j]-v[i,j]);
                                                 y:=j-0.5-ny/2;
                                                 intre;
                                            END;
                                    REPEAT
                                       IF ((y<6.9) AND (y>-6.9)) THEN
                                       BEGIN
                                          IF rpl='J' THEN
                                          BEGIN xp1:=Round(2000+x*9840/29);
                                                yp1:=Round(5560+y*7120/14);
                                                xp2:=Round(2000+xi*9840/29);
                                                yp2:=Round(5560+yi*7120/14);
                                                Write(plt,'PU',xp1:6,yp1:6);
                                                Write(plt,'PD',xp2:6,yp2:6);
                                                Write(plt,'PU',xp2:6,yp2:6);
                                          END;
                                          x1:=Round(x*500/30+50);
                                          y1:=Round(-y*170/15+100);
                                          x2:=Round(xi*500/30+50);
                                          y2:=Round(-yi*170/15+100);
                                          Draw(x1,y1,x2,y2,1);
                                          x:=xi;
                                          y:=yi;
                                          IF k=1 THEN inett;
                                          IF k=2 THEN intvo;
                                       END
                                       ELSE k:=3;
                                    UNTIL  k=3;
                                    IF rpl='J' THEN
                                          BEGIN xp1:=Round(2000+x*9840/29);
                                                yp1:=Round(5560+y*7120/14);
                                                xp2:=Round(2000+xi*9840/29);
                                                yp2:=Round(5560+yi*7120/14);
                                                Write(plt,'PU',xp1:6,yp1:6);
                                                Write(plt,'PD',xp2:6,yp2:6);
                                                Write(plt,'PU',xp2:6,yp2:6);
                                          END;
                                          x1:=Round(x*500/30+50);
                                          y1:=Round(-y*170/15+100);
                                          x2:=Round(xi*500/30+50);
                                          y2:=Round(-yi*170/15+100);
                                          Draw(x1,y1,x2,y2,1);
                                          x:=xi;
                                          y:=yi;
                             END;
                             vp:=vp-v3;
                  UNTIL vp<=sl;
                  GotoXY(1,1);
                  IF rpl='J' THEN Write(plt,'SP 0;');
                  Write('F”r fortsatt ber„kning sl† godtycklig tangent');
                  Read(fortsatt);
          END;

BEGIN
      ClrScr;
      Assign(eslask,'slask.txt');
      Reset(eslask);
      Read(eslask,nx,ny,nx1,nx2,nx3,nx4);
      Read(eslask,ny1,ny2,ny3,ny4);
      Read(eslask,vo,v1,v2);
      FOR i:=1 TO nx DO
      FOR j:=1 TO ny DO
      BEGIN
      Read(eslask,v[i,j]);
      END;
      close(eslask);
      Writeln('Žr Rolandplottern inkopplad?  J/N');
      Read(rpl);  Writeln;
      IF rpl='j' THEN rpl:='J';
      IF rpl='J' THEN
      BEGIN Assign(plt,'COM2');
            Rewrite(plt);
            Write(plt,'IN;');
      END;



      REPEAT
             ClrScr;
             Writeln('print potential                       :S');
             Writeln('plot ekvipotentiallinjer pos)         :P');
             Writeln('plot partikelbanor                    :B');
             Writeln('exit                                  :E');
             Read(styr);
             Writeln;
             IF (styr='s') OR (styr='S') THEN printfield;
             IF (styr='B') OR (styr='b') THEN banplot;
             IF (styr='P') OR (styr='p') THEN ekviplot;

      UNTIL  (styr='E') OR (styr='e');
      IF rpl='J' THEN
      Close(plt);

END.
