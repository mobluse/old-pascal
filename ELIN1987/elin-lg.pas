PROGRAM ElectricLens;

TYPE
  arr=ARRAY[1..40,1..40] OF Real;
VAR
  nx,ny,            {dimension}
  nx1,nx2,nx3,nx4,
  ny1,ny2,ny3,ny4,  {koordinater for elektroder}
  i,j,pt,k,i1,j1,
  x1,y1,x2,y2,
  xp1,yp1,xp2,yp2   :Integer;
  vo,v1,v2,x,y,
  xny,yny,vx,vy,
  n,uo,yo,xbi,fl,
  gl,hb,hk,rq,vp,
  xi,yi,fo,fb       :Real;
  v                 :arr;
  plotter_on        :Boolean;
  rpl,fortsatt      :Char;
  plt               :Text;




{--------------------------------------------------------------}
PROCEDURE fxbox(x1,y1,x2,y2:Integer);
BEGIN
  Draw(x1,y1,x2,y1,1);  Draw(x2,y1,x2,y2,1);
  Draw(x2,y2,x1,y2,1);  Draw(x1,y2,x1,y1,1);
END;

{--------------------------------------------------------------}
PROCEDURE ask(n1,n2,n3:Integer);
BEGIN
  xp1:=Round((n1-1.5)*500/30+50+8);
  xp2:=Round((n2-0.5)*500/30+50-8);
  yp1:=Round(-(n3-1-ny/2)*170/15+100-4);
  yp2:=Round(-(n3-ny/2)*170/15+100+4);
  fxbox(xp1,yp1,xp2,yp2);

  IF plotter_on THEN
    BEGIN
      xp1:=Round(2000+(n1-1.5)*9840/29+80);
      xp2:=Round(2000+(n2-0.5)*9840/29-80);
      yp1:=Round(2000+(n3-1.5)*7120/14+150);
      yp2:=Round(2000+(n3-0.5)*7120/14-150);
      Write(plt,'PU',xp1:6,yp1:6);
      Write(plt,'PD EA',xp2:6,yp2:6);
      Write(plt,'PU',xp1:6,yp1:6);
    END;
END;


{------------------------------------------------------------}
PROCEDURE initiate;
BEGIN
   fl:=1;   gl:=1;

   GotoXY(1,1);
   Write('                                                            ');
   Write('                  ');
   GotoXY(1,1);  Write('Elektronens y-koordinat d† x=0  ');
   Readln(y);    yo:=y;
   IF rq<0 THEN GotoXY(1,1) ELSE Writeln;
   x:=0;

   Write('Den infallande elektronens enengi i eV  ');
   Readln(uo);
   IF rq<0 THEN GotoXY(1,1) ELSE  Writeln;

   Write('Elektronk„llans avst†nd fr†n y-axeln  ');
   Readln(xbi);

   IF rq>0 THEN HiRes;
   xbi:=Abs(xbi);    IF xbi>1e4 THEN fl:=-1;
   n:=5;         vx:=1;      vy:=vx*y/xbi;

   IF rq>0 THEN
     BEGIN
       IF plotter_on THEN
         BEGIN
           Write(plt,'SP 1;');            Write(plt,'PU,2000,2000');
           Write(plt,'PD,EA11840,9120;'); Write(plt,'PU,2000,2000');
         END;
       fxbox(50,15,550,185);
       ask(nx1,nx2,ny1);   ask(nx1,nx2,ny4);
       ask(nx3,nx4,ny2);   ask(nx3,nx4,ny3);
       rq:=-1;
     END;

   x1:=Round(x*500/30+50);       y1:=Round(-y*170/15+100);
   xp1:=Round(2000+x*9840/29);   yp1:=Round(5560+y*7170/14);

   IF plotter_on THEN
     BEGIN
       Write(plt,'SP 2;');              Write(plt,'PU',xp1:6,yp1:6);
       Write(plt,'PD',xp1:6,yp1:6);
     END;
END;

{-----------------------------------------------------------}
PROCEDURE step;
VAR
  xi,yi,a,b,fx,fy  :Real;

BEGIN
  REPEAT
    i:= Trunc(x+1+0.5);   j:= Trunc(y+1+ny/2);
    xi:=x+1-i;           yi:=y+0.5+ny/2-j;

    IF NOT((((i>=nx1) AND (i<=nx2))
                      AND ((j=ny1) OR (j=ny4)))
                      OR  (((i>=nx3) AND (i<=nx4))
                      AND ((j=ny2) OR (j=ny3))))       THEN
       BEGIN
         a:=(v[i+1,j]+v[i-1,j])/2-v[i,j];     b:=(v[i+1,j]-v[i-1,j])/2;
         fx:=a*xi/0.5+b;
         a:=(v[i,j+1]+v[i,j-1])/2-v[i,j];     b:=(v[i,j+1]-v[i,j-1])/2;
         fy:=2*a*yi+b;
         vx:=vx+fx/(2*n*uo);         vy:=vy+fy/(2*n*uo);
         xny:=x+vx/n;               yny:=y+vy/n;
         x2:=Round(xny*500/30+50);   y2:=Round(-yny*170/15+100);
         Draw(x1,y1,x2,y2,1);
         x1:=x2;                         y1:=y2;
         xp2:=Round(2000+xny*9840/29);  yp2:=Round(2000+yny*7120/14);
         IF plotter_on THEN
           Write(plt,'PD,xp2:6,yp2:6');
           x:=xny;      y:=yny;
           xp1:=xp2;  yp1:=yp2;
       END
     ELSE
       xny:=nx+20;
   UNTIL xny>nx-1.5;
END;

{-----------------------------------------------------------}
PROCEDURE printfield;
VAR i,j: Integer;

BEGIN
  Write(Lst,'  ');
  FOR j:=1 TO ny DO
    Write(Lst,j:5);

  Writeln(Lst); Writeln(Lst); Writeln(Lst);

  FOR i:=1 TO nx DO
    BEGIN
      Write(lst,i:2);
      FOR j:=1 TO ny DO
        BEGIN
          pt:=Round(v[i,j]);
          Write(Lst,pt:5);
        END;
      Writeln(lst); Writeln(lst);
    END;

END;

{-------------------------------------------------------------}
PROCEDURE banplot;
VAR
   xbild,yslut      :Real;       qw               :Char;

BEGIN
  rq:=1;  ClrScr;

  REPEAT
    initiate;         rq:=-1;        step;
    IF xny<nx+10 THEN
      BEGIN
        xbild:=-yny*vx/vy+xny;
        yslut:=-(xbild-nx+1)*vy/vx;
        IF Abs(xbild)>1e4 THEN gl:=-1;
        GotoXY(1,1);     Write('x f”r bildpunkt b=',xbild:3:2);
        Write('     y f”r x=N1-1   y2=',yslut:1:2);

        IF fl<0 THEN
          BEGIN
            GotoXY(1,25);
            hb:=xbild+yo*vx/vy;
            Write('x f”r bildhpl  hb=',hb:5:2);
            fb:=xbild-hb;
            Write('      br„nnvidden  fb=',fb:5:2);
          END;

        IF gl<0 THEN
          BEGIN
            GotoXY(1,25);
            hk:=yny/yo*xbi-xbi;
            Write('x f”r objekthpl  ho=',hk:5:2);
            fo:=xbi+hk;
            Write('     br„nnvidden fo=',fo:5:2);
          END;
      END
    ELSE
      BEGIN
        GotoXY(1,1);
        Write('                                                            ');
        Write('                 ');
        GotoXY(1,1);
      END;
    GotoXY(57,1);
    Write('Fler ber„kningar? J/N');
    Readln(qw);
    GotoXY(1,25);
    Write('                                  ');
    Write('                                  ');

    IF plotter_on THEN
      BEGIN
         Write(plt,'PU',xp1:6,yp1:6);
         Write(plt,'sp 0;');
      END;

  UNTIL qw IN ['n','N'];
END;

PROCEDURE connect(offsetX,offsetY: Integer; st,sl,diff:Real; VAR v:arr);
CONST
  scaleX=16.667;   scaleY=11.3333;
  maxNoOfCrossings=1000;     firstPoint=True;
TYPE
  typeOfCrossing = (horizontal,vertical);
  CrossesWhere   = (top,left,bottom,right,nowhere);
VAR
  u              :ARRAY[1..28,1..13] OF Real;
  crossX, crossY :ARRAY[1..maxNoOfCrossings] OF Integer;
  crossType      :ARRAY[1..maxNoOfCrossings] OF CrossesWhere;
  crossActive    :ARRAY[1..maxNoOfCrossings] OF Boolean;
  uLevel         :Real;
  numberOfCrosses,i,j, n,m, oldXPl, oldYPl  :Integer;

PROCEDURE generateArray;
VAR  i,j: Integer;
BEGIN
  FOR i:=1 TO m DO
    FOR j:=1 TO n DO
      u[i,j] := 100*Sin(0.5*i)*Sin(0.5*j);
END;

FUNCTION inInterval(x1,y1,x2,y2:Integer): Boolean;
VAR  slask: Boolean;
BEGIN
  slask := False;
  IF (x1 IN [1..m]) AND
     (x2 IN [1..m]) AND
     (y1 IN [1..n]) AND
     (y2 IN [1..n]) AND
     (((uLevel<=u[x1,y1]) AND (uLevel>=u[x2,y2])) OR
      ((uLevel<=u[x2,y2]) AND (uLevel>=u[x1,y1])))      THEN
                slask := True;
  inInterval := slask;
END;

PROCEDURE SearchArray;
VAR i,j,count:Integer;
BEGIN
  count := 0;
  FOR i:=1 TO m-1 DO
    IF inInterval(i,1,i+1,1) THEN
      BEGIN
        count:=count+1;
        crossX[count]:=i;   crossY[count]:=1; crossType[count]:=top;
      END;
  FOR i:=1 TO m-1 DO
    IF inInterval(i,n,i+1,n) THEN
      BEGIN
        count:=count+1;
        crossX[count]:=i;   crossY[count]:=n; crossType[count]:=bottom;
      END;
  FOR j:=1 TO n-1 DO
    IF inInterval(1,j,1,j+1) THEN
      BEGIN
        count:=count+1;
        crossX[count]:=1;   crossY[count]:=j; crossType[count]:=left;
      END;
  FOR j:=1 TO n-1 DO
    IF inInterval(m,j,m,j+1) THEN
      BEGIN
        count:=count+1;
        crossX[count]:=m;   crossY[count]:=j; crossType[count]:=right;
      END;
  FOR i:=2 TO m-1 DO
    FOR j:=1 TO n-1 DO
      IF inInterval(i,j,i,j+1) THEN
      BEGIN
        count:=count+1;
        crossX[count]:=i;   crossY[count]:=j; crossType[count]:=left;
      END;
  FOR i:=1 TO m-1 DO
    FOR j:=2 TO n-1 DO
      IF inInterval(i,j,i+1,j) THEN
      BEGIN
        count:=count+1;
        crossX[count]:=i;   crossY[count]:=j; crossType[count]:=bottom;
      END;
  numberOfCrosses := count;
  FOR i:=1 TO numberOfCrosses DO crossActive[i] := True;
END;

FUNCTION cross(x,y: Integer;   a: typeOfCrossing;
               VAR place: Integer)                : Boolean;
LABEL  1000;
VAR i: Integer; slask: Boolean;
BEGIN
  slask := False;
  FOR i:=1 TO numberOfCrosses DO
    IF (x=crossX[i]) AND (y=crossY[i]) AND
       (Ord(a)=Ord(crossType[i]) MOD 2) AND crossActive[i] THEN
      BEGIN  slask:=True;  place:=i; GOTO 1000  END;
1000:
  cross := slask;
END;

FUNCTION empty(VAR place: Integer) : Boolean;
LABEL 1000;
VAR  i: Integer; slask: Boolean;
BEGIN
  slask:=True; place:=0;
  FOR i:=1 TO numberOfCrosses DO
    IF crossActive[i] THEN BEGIN slask:=False; place:=i; GOTO 1000 END;
1000:
  empty := slask;
END;

PROCEDURE SearchNext(VAR x,y: Integer;
                     VAR inWall: CrossesWhere;
                     VAR place: Integer);
 VAR i,xut,yut: Integer; ut: CrossesWhere;
BEGIN
  ut := nowhere;
  CASE inWall OF
    left   :IF cross(x,y,horizontal,place) THEN
              BEGIN xut:=x; yut:=y; ut:=bottom END
            ELSE
              IF cross(x+1,y,vertical,place) THEN
                BEGIN xut:=x+1; yut:=y; ut:=left END
              ELSE
                IF cross(x,y+1,horizontal,place) THEN
                  BEGIN xut:=x; yut:=y+1; ut:=top END;
    bottom :IF cross(x,y-1,vertical,place) THEN
              BEGIN xut:=x; yut:=y-1; ut:=right END
            ELSE
              IF cross(x,y-1,horizontal,place) THEN
                BEGIN xut:=x; yut:=y-1; ut:=bottom END
              ELSE
                IF cross(x+1,y-1,vertical,place) THEN
                  BEGIN xut:=x+1; yut:=y-1; ut:=left END;
    right  :IF cross(x-1,y,vertical,place) THEN
              BEGIN xut:=x-1; yut:=y; ut:=right END
            ELSE
              IF cross(x-1,y,horizontal,place) THEN
                BEGIN xut:=x-1; yut:=y; ut:=bottom END
              ELSE
                IF cross(x-1,y+1,horizontal,place) THEN
                  BEGIN xut:=x-1; yut:=y+1; ut:=top END;
    top    :IF cross(x,y,vertical,place) THEN
              BEGIN xut:=x; yut:=y; ut:=right END
            ELSE
              IF cross(x,y+1,horizontal,place) THEN
                BEGIN xut:=x; yut:=y+1; ut:=top END
              ELSE
                IF cross(x+1,y,vertical,place) THEN
                  BEGIN xut:=x+1; yut:=y; ut:=left END;
  END; {CASE}
  x := xut;  y := yut;  inWall := ut;
END;

PROCEDURE plotPoints(x,y: Integer;  firstPoint: Boolean; inw: CrossesWhere);
VAR xplot,yplot:Integer;
BEGIN
  IF inw<>nowhere THEN
    BEGIN
      CASE inw OF
        right, left: BEGIN
                       xplot:=Round(x*scaleX);
                       IF Abs(u[x,y]-u[x,y+1])>1e-6 THEN
                         yplot:=Round((y+(uLevel-u[x,y])/
                                         (u[x,y+1]-u[x,y]))*scaleY)
                       ELSE
                         yplot:=Round((2*y+1)/2*scaleY)
                     END;
        top, bottom: BEGIN
                       yplot:=Round(y*scaleY);
                       IF Abs(u[x,y]-u[x+1,y])>1e-6 THEN
                         xplot:=Round((x+(uLevel-u[x,y])/
                                         (u[x+1,y]-u[x,y]))*scaleX)
                       ELSE
                         xplot:=Round((2*x+1)/2*scaleX)
                     END;
      END; {CASE}
      IF firstPoint THEN
        BEGIN oldXPl:=xplot+offsetX; oldYPl:=-yplot+offsetY END
      ELSE
        BEGIN
          Draw(oldXPl,oldYPl,xplot+offsetX,-yplot+offsetY,1);
          oldXPl:=xplot+offsetX; oldYPl:=-yplot+offsetY
        END;
    END;
END;

PROCEDURE LinkArray;
VAR
  x, y, xstart, ystart, count, place  : Integer;
  inw, inwstart                       : CrossesWhere;
BEGIN
  WHILE NOT empty(place) DO
    BEGIN
      count := place;
      x:=crossX[count]; y:=crossY[count];  inw:=crossType[count];
      xstart:=x;  ystart:=y; inwstart:=inw;

      plotPoints(x,y,firstPoint,inw);

      REPEAT
        SearchNext(x,y,inw,place);     crossActive[place]:=False;
        plotPoints(x,y,NOT firstPoint,inw);
      UNTIL (inw=nowhere) OR
            ((x=xstart) AND (y=ystart) AND (inwstart=inw));
      crossActive[count] := False;
    END;
END;

BEGIN
  m:=nx-2; n:=ny-2;
  FOR i:=1 TO m DO
    FOR j:=1 TO n DO
      u[i,j]:=v[i+1,j+1];
  uLevel:=st;

  REPEAT
    SearchArray;  LinkArray;
    uLevel:=uLevel+diff;
  UNTIL uLevel>=sl;
END;


{---------------------------------------------------------------}
PROCEDURE ekviplot;
VAR
  st,sl,vst,difference     :Real;

BEGIN
  ClrScr;
  GotoXY(1,1);    Write('Differens mellan ekvipotentiallinjer  ');
  Read(difference);    difference:=Abs(difference);
  HiRes;
  IF plotter_on THEN
     BEGIN
       Write(plt,'SP 1;');             Write(plt,'PU,2000,2000');
       Write(plt,'PD,EA11840,9120;');  Write(plt,'PU,2000,2000');
     END;
  fxbox(50,15,550,185);
  ask(nx1,nx2,ny1);   ask(nx1,nx2,ny4);
  ask(nx3,nx4,ny2);   ask(nx3,nx4,ny3);
  IF v2<v1 THEN
    BEGIN st:=v2+difference;    sl:=v1-difference;    END
  ELSE
    BEGIN st:=v1+difference; sl:=v2-difference; END;
  connect(50,179,st,sl,difference,v);

{     IF vp>0.2 THEN
        Write(plt,'SP 2;')
      ELSE
        IF vp>-0.2 THEN
          Write(plt,'SP 3;')
        ELSE Write(plt,'SP 4;');

                  IF plotter_on THEN
                    BEGIN
                      xp1:=Round(2000+x*9840/29);  yp1:=Round(5560+y*7120/14);
                         }
  GotoXY(1,1);
  IF plotter_on THEN Write(plt,'SP 0;');
  Write('F”r fortsatt ber„kning sl† godtycklig tangent');
  Read(Kbd,fortsatt);

END;

{--------------------------------------------------------------}
PROCEDURE read_data;

VAR
  i,j   : Integer;
  eslask: Text;

BEGIN
  Assign(eslask,'slask.txt');   Reset(eslask);
  Read(eslask,nx,ny,nx1,nx2,nx3,nx4);
  Read(eslask,ny1,ny2,ny3,ny4);
  Read(eslask,vo,v1,v2);
  FOR i:=1 TO nx DO
    FOR j:=1 TO ny DO
      BEGIN
        Read(eslask,v[i,j]);
      END;
  Close(eslask);
END;

{---------------------------------------------------------------}
PROCEDURE meny;

VAR          c,janej:Char;

BEGIN

  REPEAT
    Clrscr; Hires;
    fxbox(10,5,629,194);    {ram}
    Gotoxy(30,10); Write('1. Utskrift av potential');
    Gotoxy(30,12); Write('2. Rita ekvipotentiallinjer');
    Gotoxy(30,14); Write('3. Rita partikelbanor');
    Gotoxy(30,16); Write('4. Sluta');
    Gotoxy(30,18); Write('Ange Ditt val: ');

    REPEAT
      Read(Kbd,c);
    UNTIL c IN ['1','2','3','4'];
    Write(c);

    CASE c OF
      '1':printfield;
      '2':ekviplot;
      '3':banplot;
      '4':BEGIN
            Gotoxy(30,19); Write('S„kert? (J/N):');
            Readln(janej);
          END;
    END;  {case}
  UNTIL janej IN ['j','J']

END;

{*****************************************************************}
{*                   H U V U D P R O G R A M                     *}
{*****************************************************************}
BEGIN

  ClrScr;  plotter_on:=FALSE;

  Write('L„ser data fr†n skiva. ');  read_data; Writeln('Klar!');

  Writeln('Žr Rolandplottern inkopplad?  J/N');    Readln(rpl);

  IF rpl IN ['j','J'] THEN
    BEGIN
      Assign(plt,'com2');  Rewrite(plt);
      Write(plt,'IN;'); plotter_on:=TRUE;
    END;

  meny;

  IF plotter_on THEN Close(plt);

END.
