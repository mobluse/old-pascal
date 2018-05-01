program pu3(input,output);

{$I plot}
{$I graph.p }

Const MAXGRAD=10;

Type polynom=Array[0..MAXGRAD] Of Real;

Var grad,indelningar,pxmin,pymin,pxmax,pymax:Integer;
    dpol,pol:polynom;
    xmin,ymin,xmax,ymax:Real;
    tkn:Char;

Procedure readpol(Var n:Integer;Var poly:polynom);

Var i:Integer;

Begin
   Write('Vilken grad skall polynomet vara av: ');
   ReadLn(n);
   Write('Ange den konstanta koefficienten:');
   ReadLn(poly[0]);
   For i:=1 To n Do
     Begin
       Write('Ange ',i,':te grads koefficinten:');
       ReadLn(poly[i]);
     End;
End;

Procedure deriverapol(n:Integer;var dpoly:polynom;poly:polynom);

Var i:Integer;

Begin
  For i:=0 To n-1 Do
    Begin
      dpoly[i]:=(1+i)*poly[i+1];
    End;
End;

Procedure nollapol(Var poly:polynom);

Var i:Integer;

Begin
  For i:=0 To MAXGRAD Do
    Begin
      poly[i]:=0;
    End;
End;

Procedure skrivpol(n:Integer;poly:polynom);

Var i:Integer;

Begin
  For i:=n DownTo 0 Do
    Begin
      Write(poly[i]:6:2,'  ');
    End;
  WriteLn;
End;

Function polv(poly:polynom;x:Real;grad:Integer):Real;

Var
  i:Integer;
  polvf:Real;

Begin
  polvf:=x*poly[grad];
  For i:=grad-1 Downto 1 Do
    Begin
      polvf:=x*(poly[i]+polvf);
    End;
  polvf:=polvf+poly[0];
  polv:=polvf;
End;



Procedure plotpol(poly:polynom;n:Integer);

Var
  i,xp,yp:Integer;
  x,lastx,y,lasty:Real;

Begin
  lasty:=polv(poly,xmin,n);
  lastx:=xmin;
  For i:=1 To indelningar Do
    Begin
      x:=xmin+((xmax-xmin)*i)/indelningar;
      y:=polv(poly,x,n);
      If Not((lasty<ymin) Or (lasty>ymax)) Then
        If Not((y<ymin) Or (y>ymax)) Then
          Begin
            xp:=Round(15000*(lastx-xmin)/(xmax-xmin));
            yp:=Round(10500*(lasty-ymin)/(ymax-ymin));
            movepen(xp,yp);
            xp:=Round(15000*(x-xmin)/(xmax-xmin));
            yp:=Round(10500*(y-ymin)/(ymax-ymin));
            plotlineto(xp,yp);
          End;
      lastx:=x;
      lasty:=y;
    End;
End;

Procedure drawpol(poly:polynom;n:Integer);

Var
  i,xp,yp,fyp,fxp:Integer;
  x,lastx,y,lasty:Real;

Begin
  lasty:=polv(poly,xmin,n);
  lastx:=xmin;
  For i:=1 To indelningar Do
    Begin
      x:=xmin+((xmax-xmin)*i)/indelningar;
      y:=polv(poly,x,n);
      If Not((lasty<ymin) Or (lasty>ymax)) Then
        If Not((y<ymin) Or (y>ymax)) Then
          Begin
            fxp:=Round(640*(lastx-xmin)/(xmax-xmin));
            fyp:=Round(200*(lasty-ymin)/(ymax-ymin));
            xp:=Round(640*(x-xmin)/(xmax-xmin));
            yp:=Round(200*(y-ymin)/(ymax-ymin));
            Draw(fxp,200-fyp,xp,200-yp,1);
          End;
      lastx:=x;
      lasty:=y;
   End;
End;


Procedure ritakoordinatsystem;

Var xp,yp:Integer;

Begin
  selectpen(1);
  If Not((ymax<0) Or (ymin>0)) Then
    Begin
      xp:=Round(15000*(-xmin)/(xmax-xmin));
      plotline(xp,0,xp,10500);
    End;
  If Not((xmax<0) Or (xmin>0)) Then
    Begin
      yp:=Round(10500*(-ymin)/(ymax-ymin));
      plotline(0,yp,15000,yp);
    End;
End;

Procedure drawkoordinatsystem;

Var xp,yp:Integer;

Begin
  If Not((ymax<0) Or (ymin>0)) Then
    Begin
      yp:=Round(200*(-ymin)/(ymax-ymin));
      draw(0,200-yp,640,200-yp,1);
    End;
  If Not((xmax<0) Or (xmin>0)) Then
    Begin
      xp:=Round(640*(-xmin)/(xmax-xmin));
      draw(xp,0,xp,200,1);
    End;
End;

Procedure options;

Begin
  ClrScr;
  WriteLn('V„rden inom [] „r default');
  WriteLn;
  Write('Indelningar vid plottning [',indelningar,']:');
  ReadLn(indelningar);
  WriteLn;
  WriteLn('Koordinater vid plottning');
  Write('Nedre v„nstra h”rnet [',xmin:8:2,' ',ymin:8:2,']:');
  ReadLn(xmin,ymin);
  Write('™vre h”gra h”rnet [',xmax:8:2,' ',ymax:8:2,']:');
  ReadLn(xmax,ymax);
  WriteLn;
  WriteLn('Koordinater p† plottern');
  Write('Nedre v„nstra h”rnet [',pxmin:8,' ',pymin:8,']:');
  ReadLn(pxmin,pymin);
  Write('™vre h”gra h”rnet [',pxmax:8,' ',pymax:8,']:');
  ReadLn(pxmax,pymax);
  ClrScr;
End;

Procedure kors(x,y:Integer);

Begin
  Draw(x-3,y,x+3,y,1);
  Draw(x,y-3,x,y+3,1);
End;

Procedure koordinater(Var x,y:Integer);

var picture:array[1..15] of Integer;
    tkn:char;
    d:Integer;


Begin
  x:=320;
  y:=100;
  d:=1;

  GetPic(picture,x-3,y-3,x+3,y+3);
  kors(x,y);

  Repeat
    Read(Kbd,tkn);

    If (tkn='4')And(x-d>2) Then
    Begin
      PutPic(picture,x-3,y+3);
      x:=x-d;
      GetPic(picture,x-3,y-3,x+3,y+3);
      kors(x,y);
    End;

    If (tkn='6')And(x+d<637) Then
    Begin
      PutPic(picture,x-3,y+3);
      x:=x+d;
      GetPic(picture,x-3,y-3,x+3,y+3);
      kors(x,y);
    End;

    If (tkn='2')And(y+d<197) Then
    Begin
      PutPic(picture,x-3,y+3);
      y:=y+d;
      GetPic(picture,x-3,y-3,x+3,y+3);
      kors(x,y);
    End;

    If (tkn='8')And(y-d>2) Then
    Begin
      PutPic(picture,x-3,y+3);
      y:=y-d;
      GetPic(picture,x-3,y-3,x+3,y+3);
      kors(x,y);
    End;

    If tkn='+' Then
      If d<64 Then d:=d*2;

    If tkn='-' Then
      If d>1 then d:=d Div 2;

  Until Ord(tkn)=13;

  PutPic(picture,x-3,y+3);

End;


Procedure p;

Begin
  TextMode;
  initplot('PLTFIL.PLT');
  selectpen(1);
  setwindow(pxmin,pymin,pxmax,pymax);
  ritakoordinatsystem;
  selectpen(2);
  plotpol(pol,grad);
  selectpen(3);
  plotpol(dpol,grad-1);
  exitplot(plotter);
  HiRes;
End;

Procedure r;

Begin
  TextMode;
  nollapol(pol);
  nollapol(dpol);
  readpol(grad,pol);
  deriverapol(grad,dpol,pol);
  HiRes;
End;



Procedure z;

Var x,y:Integer;
    rxmin,rymin,rxmax,rymax:Real;

Begin

  koordinater(x,y);
  rxmin:=xmin+(xmax-xmin)*(x/640.0);
  rymin:=ymin+(ymax-ymin)*((200-y)/200.0);
  kors(x,y);
  koordinater(x,y);
  rxmax:=xmin+(xmax-xmin)*(x/640.0);
  rymax:=ymin+(ymax-ymin)*((200-y)/200.0);
  xmin:=rxmin;
  ymin:=rymin;
  xmax:=rxmax;
  ymax:=rymax;
  HiRes;

End;

Procedure k;

var picture:array[1..15] of Integer;
    tkn:char;
    x,y,d:Integer;
    ry,rx:Real;

Begin
  x:=320;
  y:=100;
  d:=1;

  GetPic(picture,x-3,y-3,x+3,y+3);
  kors(x,y);

  Repeat
    Read(Kbd,tkn);

    If (tkn='4')And(x-d>2) Then
    Begin
      PutPic(picture,x-3,y+3);
      x:=x-d;
      GetPic(picture,x-3,y-3,x+3,y+3);
      kors(x,y);
    End;

    If (tkn='6')And(x+d<637) Then
    Begin
      PutPic(picture,x-3,y+3);
      x:=x+d;
      GetPic(picture,x-3,y-3,x+3,y+3);
      kors(x,y);
    End;

    If (tkn='2')And(y+d<197) Then
    Begin
      PutPic(picture,x-3,y+3);
      y:=y+d;
      GetPic(picture,x-3,y-3,x+3,y+3);
      kors(x,y);
    End;

    If (tkn='8')And(y-d>2) Then
    Begin
      PutPic(picture,x-3,y+3);
      y:=y-d;
      GetPic(picture,x-3,y-3,x+3,y+3);
      kors(x,y);
    End;

    If tkn='+' Then
      If d<64 Then d:=d*2;

    If tkn='-' Then
      If d>1 then d:=d Div 2;


    If tkn=' ' Then
    Begin
     rx:=xmin+(xmax-xmin)*(x/640.0);
     ry:=ymin+(ymax-ymin)*((200-y)/200.0);
     GoToXY(1,1);
     Writeln('X:',rx:8:2);
     GoToXY(11,1);
     Writeln('Y:',ry:8:2);
   End;

  Until Ord(tkn)=13;

  PutPic(picture,x-3,y+3);

  HiRes;

End;

Procedure n;

var
  x,y:Integer;
  sx,lx,mx:Real;

Begin
  Repeat
    koordinater(x,y);
    sx:=xmin+(xmax-xmin)*(x/640.0);
    koordinater(x,y);
    lx:=xmin+(xmax-xmin)*(x/640.0);
    If sx<lx Then
    Begin
      mx:=lx;
      lx:=sx;
      sx:=mx;
    End;
    If polv(pol,lx,grad)*polv(pol,sx,grad)>0 Then
    Begin
      Sound(500);
      Delay(500);
      NoSound;
    End;
  Until polv(pol,lx,grad)*polv(pol,sx,grad)<0;

  Repeat
    mx:=(lx+sx)/2;
    If polv(pol,lx,grad)*polv(pol,mx,grad)<0 Then
      sx:=mx
    Else
      lx:=mx;
  Until Abs(polv(pol,mx,grad))<1e-6;

  GoToXY(1,1);
  Write('Nollst„lle f”r X=',mx:8:3);
  Repeat Until KeyPressed;
  HiRes;
End;


Procedure o;

Begin
  TextMode;
  options;
  HiRes;
End;

{*****************************************************************************
******************** Huvudprogramet ******************************************
*****************************************************************************}


Begin
   indelningar:=100;
   xmin:=-1; ymin:=-1;
   xmax:=1; ymax:=1;
   pxmin:=0; pymin:=0;
   pxmax:=15000; pymax:=10500;


   ClrScr;
   nollapol(pol);
   nollapol(dpol);
   readpol(grad,pol);
   deriverapol(grad,dpol,pol);
   skrivpol(grad-1,dpol);

   HiRes;
   Repeat
     drawkoordinatsystem;
     drawpol(pol,grad);
     drawpol(dpol,grad-1);
     Read(Kbd,tkn);
     tkn:=UpCase(tkn);
       Case tkn Of
         'O':o;
         'R':r;
         'P':p;
         'Z':z;
         'K':k;
         'N':n;
       End;
   Until (tkn='S');
   TextMode;

End.
