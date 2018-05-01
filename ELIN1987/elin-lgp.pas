program lab_elektriska_linser;

TYPE
  head=^link;  link=^element;
  element=RECORD
            kind:(headkind,linkkind);
            pre,suc:link;
            x,y:Integer;
          END;

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
  v                 :ARRAY [1..40,1..40] OF Real;
  plotter_on        :Boolean;
  rpl,fortsatt      :Char;
  plt               :Text;
  h                 :ARRAY [1..20] OF head;
  e                 :link;
  number_of_links   :Integer;

{--------------------------------------------------------------}
PROCEDURE newhead(VAR h:head);
BEGIN
  New(h);  New(h^);
  WITH h^^ DO
    BEGIN   kind:=headkind; pre:=h^; suc:=h^; x:=0; y:=0  END;
END;

{--------------------------------------------------------------}
PROCEDURE newlink(VAR e:link);
BEGIN
  New(e);
  WITH e^ DO
    BEGIN kind:=linkkind; pre:=NIL; suc:=NIL END;
END;

{--------------------------------------------------------------}
PROCEDURE precede(e:link; h:head);
BEGIN
  h^^.pre^.suc:=e;  e^.pre:=h^^.pre;  e^.suc:=h^; h^^.pre:=e;
END;

{--------------------------------------------------------------}
PROCEDURE follow(e:link; h:head);
BEGIN
  h^^.suc^.pre:=e;  e^.pre:=h^;  e^.suc:=h^^.suc; h^^.suc:=e;
END;

{--------------------------------------------------------------}
PROCEDURE print;
 BEGIN
   GotoXY(1,1);
   Writeln(i,'  ',j,'  ',i1,'  ',j1,'  ',k);
   Writeln(x1,'  ',y1,'  ',x2,'  ',y2);
   Writeln(x,y,xi,yi);
   Read(i);
END;

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

{-------------------------------------------------------------}
PROCEDURE utett;
BEGIN
  k:=1;
  xi:=i1-1;
  yi:=j1-0.5 -ny/2-(v[i1,j1]-vp)/(v[i1,j1]-v[i1,j1-1]);
END;

{-------------------------------------------------------------}
PROCEDURE uttvo;
BEGIN
  k:=2;
  xi:=i1-1;
  yi:=j1-0.5-ny/2+(v[i1,j1]-vp)/(v[i1,j1]-v[i1,j1+1]);
END;

{-------------------------------------------------------------}
PROCEDURE uttre;
BEGIN
  k:=3;
  xi:=i1-1+(v[i1,j1]-vp)/(v[i1,j1]-v[i1+1,j1]);
  yi:=j1-0.5-ny/2;
END;

{-------------------------------------------------------------}
PROCEDURE utfyr;
BEGIN
  k:=3;
  xi:=i1-1-(v[i1,j1]-vp)/(v[i1,j1]-v[i1-1,j1]);
  yi:=j1-0.5-ny/2;
END;

{-------------------------------------------------------------}
PROCEDURE inett;
BEGIN
  IF v[i1+1,j1]<vp THEN
    uttre
  ELSE
    IF v[i1+1,j1-1]<vp THEN
      BEGIN i1:=i1+1; utett; END
    ELSE BEGIN i1:=i1+1; j1:=j1-1; utfyr; END;
END;

{------------------------------------------------------------}
PROCEDURE intvo;
BEGIN
  IF v[i1-1,j1]<vp THEN
    utfyr
  ELSE
    IF v[i1-1,j1+1]<vp  THEN
      BEGIN i1:=i1-1; uttvo; END
    ELSE
      BEGIN i1:=i1-1; j1:=j1+1; uttre; END;
END;

{------------------------------------------------------------}
PROCEDURE intre;
BEGIN
  IF v[i1,j1+1]<vp THEN
    uttvo
  ELSE
    IF v[i1+1,j1+1]<vp THEN
      BEGIN j1:=j1+1; uttre; END
    ELSE
      BEGIN i1:=i1+1; j1:=j1+1; utett; END;
END;

{------------------------------------------------------------}
PROCEDURE infyr;
BEGIN
  IF v[i1,j1-1]<vp THEN
    utett
  ELSE
    IF v[i1-1,j1-1]<vp THEN
      BEGIN j1:=j1-1; utfyr; END
    ELSE
      BEGIN i1:=i1-1; j1:=j1-1; uttvo; END;
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

{--------------------------------------------------------------}
PROCEDURE suclink(x1,y1,x2,y2:Integer; VAR linked:Boolean);
VAR k:Integer;

BEGIN
  linked:=FALSE;   k:=0;
  REPEAT
    k:=k+1;
    WITH h[k]^^.suc^ DO
      IF (x=x1) AND (y=y1) THEN
        BEGIN
          newlink(e); e^.x:=x2; e^.y:=y2;
          follow(e,h[k]);  linked:=TRUE
        END;
  UNTIL (k=number_of_links) OR linked;
END;

{--------------------------------------------------------------}
PROCEDURE prelink(x1,y1,x2,y2:Integer; VAR linked:Boolean);
VAR k:Integer;

BEGIN
  linked:=FALSE;   k:=0;
  REPEAT
  k:=k+1;
    WITH h[k]^^.pre^ DO
      IF (x=x1) AND (y=y1) THEN
        BEGIN
          newlink(e); e^.x:=x2; e^.y:=y2;
          precede(e,h[k]);  linked:=TRUE
        END;
  UNTIL (k=number_of_links) OR linked;
END;

{----------------------------------------------------------------}
PROCEDURE internal_link(x1,y1,x2,y2:Integer);
BEGIN
  number_of_links:=number_of_links+1;
  newhead(h[number_of_links]);
  newlink(e);  e^.x:=x1; e^.y:=y1; follow(e,h[number_of_links]);
  newlink(e);  e^.x:=x2; e^.y:=y2; follow(e,h[number_of_links]);
END;

{----------------------------------------------------------------}
PROCEDURE ekvilink(x1,y1,x2,y2:Integer);
VAR linked:Boolean;

BEGIN
  suclink(x1,y1,x2,y2,linked);
  IF NOT linked THEN suclink(x2,y2,x1,y1,linked);
  IF NOT linked THEN prelink(x1,y1,x2,y2,linked);
  IF NOT linked THEN prelink(x2,y2,x1,y1,linked);
  IF NOT linked THEN internal_link(x1,y1,x2,y2);
END;

{---------------------------------------------------------------}
PROCEDURE merge(i,j:Integer; VAR linked:Boolean);
BEGIN
  h[i]^^.suc^.pre:=h[j]^^.pre;
  h[j]^^.pre^.suc:=h[i]^^.suc;
  h[j]^^.suc^.pre:=h[i]^;
  h[i]^^.suc:=h[j]^^.suc;
  h[j]^^.suc:=h[j]^; h[j]^^.pre:=h[j]^; linked:=TRUE;
END;

{---------------------------------------------------------------}
PROCEDURE reverse(h:head);
VAR e,slask:link;

BEGIN
  slask:=h^^.suc; h^^.suc:=h^^.pre; h^^.pre:=slask;
  e:=h^^.pre;
  REPEAT
    slask:=e^.suc;  e^.suc:=e^.pre; e^.pre:=slask;
    e:=e^.pre;
  UNTIL e^.kind=headkind;
END;

{---------------------------------------------------------------}
PROCEDURE crosslink;
VAR i,j:Integer;  linked:Boolean;

BEGIN
  i:=0;
  IF number_of_links>1 THEN
    REPEAT
      linked:=FALSE;
      i:=i+1;
      FOR j:=i+1 TO number_of_links DO
        BEGIN
          IF h[i]^^.suc=h[j]^^.pre THEN merge(i,j,linked);
          IF h[i]^^.pre=h[j]^^.suc THEN merge(j,i,linked);
          IF h[i]^^.suc=h[j]^^.suc THEN
            BEGIN reverse(h[j]); merge(i,j,linked) END;
          IF h[i]^^.pre=h[j]^^.pre THEN
            BEGIN reverse(h[i]); merge(i,j,linked) END;
        END;
      IF linked THEN i:=i-1;
    UNTIL (i=number_of_links-1);
END;

{----------------------------------------------------------------}
PROCEDURE plot_it;
VAR i,xsave,ysave:Integer; lsuc:link; first:Boolean;

BEGIN
  FOR i:=1 TO number_of_links DO
    BEGIN
      lsuc:=h[i]^^.suc; first:=TRUE;
      WHILE lsuc^.kind=linkkind DO
        BEGIN
          IF first THEN
            BEGIN Write(plt,'PU',lsuc^.x:6,lsuc^.y:6); first:=FALSE END
          ELSE
            Write(plt,'PD',lsuc^.x:6,lsuc^.y:6);
            lsuc:=lsuc^.suc;  Dispose(lsuc^.pre);
        END;
      Dispose(h[i]^); Dispose(h[i]);  h[i]:=NIL; Write(plt,'PU;');
    END;
  number_of_links:=0;
END;

{---------------------------------------------------------------}
PROCEDURE ekviplot;
VAR
  st,sl,vst,v3     :Real;

BEGIN
  ClrScr;
  GotoXY(1,1);    Write('Differens mellan ekvipotentiallinjer  ');
  Read(v3);
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
    BEGIN st:=v1-v3;    sl:=v2+v3-0.01;    END
  ELSE
    BEGIN st:=-(v1-v3); sl:=-(v2+v3-0.01); END;
  vp:=st;
  REPEAT
    IF plotter_on THEN
      IF vp>0.2 THEN
        Write(plt,'SP 2;')
      ELSE
        IF vp>-0.2 THEN
          Write(plt,'SP 3;')
        ELSE Write(plt,'SP 4;');
    FOR j:=2 TO ny-1 DO
      FOR i:=2 TO nx   DO
        IF ((v[i,j]-vp)*(v[i-1,j]-vp))<0 THEN
          BEGIN
            i1:=i; j1:=j;
            x:=i-1-(v[i,j]-vp)/(v[i,j]-v[i-1,j]);   y:=j-0.5-ny/2;
            IF (v[i,j]-vp)>0 THEN
              infyr
            ELSE
              BEGIN i1:=i1-1;   intre    END;

            REPEAT
              IF ((y<6.9) AND (y>-6.9)) THEN
                BEGIN
                  IF plotter_on THEN
                    BEGIN
                      xp1:=Round(2000+x*9840/29);  yp1:=Round(5560+y*7120/14);
                      xp2:=Round(2000+xi*9840/29); yp2:=Round(5560+yi*7120/14);
                      ekvilink(xp1,yp1,xp2,yp2);
                    END;
                  x1:=Round(x*500/30+50);  y1:=Round(-y*170/15+100);
                  x2:=Round(xi*500/30+50); y2:=Round(-yi*170/15+100);
                  Draw(x1,y1,x2,y2,1);
                  x:=xi;     y:=yi;
                  CASE k OF
                    1:inett;   2:intvo;
                  END;
                END
              ELSE k:=3;
            UNTIL  k=3;

            IF plotter_on THEN
              BEGIN
                xp1:=Round(2000+x*9840/29);  yp1:=Round(5560+y*7120/14);
                xp2:=Round(2000+xi*9840/29); yp2:=Round(5560+yi*7120/14);
                ekvilink(xp1,yp1,xp2,yp2);
              END;
            x1:=Round(x*500/30+50);   y1:=Round(-y*170/15+100);
            x2:=Round(xi*500/30+50);  y2:=Round(-yi*170/15+100);
            Draw(x1,y1,x2,y2,1);
            x:=xi;  y:=yi;
          END;
    IF plotter_on THEN BEGIN crosslink;  plot_it  END;
    vp:=vp-v3;
  UNTIL vp<=sl;
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