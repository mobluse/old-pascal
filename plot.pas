{ *************************************
             P L O T    1.0
     Plotterrutiner fîr Turbo Pascal
        Magnus Olsson 7/10 1987
   ************************************ }


{ ***  Plottkoordinaterna anges som heltal i intervallet
       0..32767. (0,0) Ñr nedre vÑnstra hîrnet. Varje steg motsvarar
       1/40 mm pÜ pappret.

  **** Plottkommandona skrivs till en extern fil. Efter avslutad kîrning
       kan man vÑlja att fÜ kommandona skickade direkt till plottern
       eller att behÜlla dem som en fil pÜ disketten.
       Anledningen att kommandona inte skickas till plottern samtidigt
       som de ges Ñr att det skulle binda upp plottern under hela
       exekveringstiden

  **** Fîljande globala identifierare Ñr avsedda fîr internt bruk
       och skall inte anvÑndas av anropande program:

       pl_string (typ)
       pl_x,pl_y,pl_file (variabler)
       pl_error,pl_errcheck (procedurer)  }




{$I-}

type pl_string    = string [255];
     OutputOption = (plotter,disk);

var pl_x,pl_y : integer;      { Aktuell x- resp. y-koordinat - Ñndra *ej* }
    pl_file   : text;


{ *** Interna procedurer (skall ej anropas utifrÜn) *** }


procedure pl_error (message : pl_string);
{ Skriv ut ett felmeddelande och avbryt exekvering }

begin
    writeln;
    TextColor (31);       { Blinkande tecken }
    TextBackground (0);
    write (#7,'Fel: ');
    TextColor (15);
    writeln (message);
    writeln ('Exekveringen avbryts.');
    halt;
end;


procedure pl_errcheck;
{ Kontrollera om IO-fel har uppkommit och avbryt i sÜ fall }

begin
    case IOResult of
          0 : ;
          3 : pl_error ('Plottfilen Ñr ej îppen');
        $20 : pl_error ('OtillÜtet filnamn fîr plottfil');
        $F0,
        $F1,
        $F2 : pl_error ('Skrivfel pÜ plottfil, disken fîrmodligen full');
        $F3 : pl_error ('Skrivfel pÜ plottfil, fîr mÜnga filer îppna');
        else  pl_error ('Skrivfel pÜ plottfil');
    end;
end;



{ ***********************************************************************

          *** Dessa procedurer kan anvÑndas frÜn programmet **

  *********************************************************************** }


{ **** Funktioner som returnerar aktuell pennposition **** }

function PenPositionX : integer;

begin
    PenPositionX:=pl_x;
end; { PenPositionX }


function PenPositionY : integer;

begin
    PenPositionY:=pl_y;
end; { PenPositionY }



{ **** GrundlÑggande kommandon **** }


procedure SelectPen (pen : integer);
{ VÑlj penna }

begin
    if (pen<0) or (pen>8) then
        pl_error ('Felaktigt pennummer (mÜste ligga mellan 0 och 8)');
    writeln (pl_file,'SP ',pen);
    pl_errcheck;
end;



procedure MovePen (x,y : integer);
{ Lyft pennan och flytta den till angiven position }

begin
    pl_x:=x;
    pl_y:=y;
    writeln (pl_file,'PU ',x,',',y);
    pl_errcheck;
end; { MovePen }



procedure SetLineType (lineType : integer);
{ VÑlj linjetyp (heldragen, streckad etc. lineType=0 ger heldragen,
  1..6 olika typer av streckning. }

begin
    case lineType of
        0 : begin
                writeln (pl_file,'LT');
                pl_errcheck;
            end;
     1..6 : begin
                writeln (pl_file,'LT ',lineType,',2');
                pl_errcheck;
            end;
       else pl_error ('OtillÜten linjetyp');
    end;
end; { SetLineType }




procedure PlotLineTo (x,y : integer);
{ Rita en linje frÜn aktuell position till angiven punkt }

begin
    writeln (pl_file,'PD ',x,',',y);
    pl_errcheck;
    pl_x:=x;
    pl_y:=y;
end; { PlotLineTo }



procedure PlotLine (fromX,fromY,toX,toY : integer);
{ Rita en linje frÜn punkten (fromX,fromY) till (toX,toY) }

begin
    if (fromX<>pl_x) or (fromY<>pl_y) then
        MovePen (fromX,fromY);
    PlotLineTo (toX,toY);
end; { PlotLine }



procedure PlotCircle (x,y,radius : integer);
{ Rita en cirkel med angiven mittpunkt och radie }

begin
    if (x<>pl_x) or (y<>pl_y) then
        MovePen (x,y);
    writeln (pl_file,'CI ',radius);
    pl_errcheck;
end; { PlotCircle }



procedure PlotRectangle (x1,y1,x2,y2 : integer);
{ Rita en rektangel. (x1,y1) resp (x2,y2) Ñr koordinaterna fîr
  nedre vÑnstra resp. îvre hîgra hîrnet }

begin
    if (x1<>pl_x) or (y1<>pl_y) then
        MovePen (x1,y1);
    writeln (pl_file,'EA ',x2,',',y2);
    pl_errcheck;
end; { PlotRectangle }



{ **** Procedurer fîr plottning av text **** }


procedure SetTextDirection (direction : integer);
{ Ange den riktning som PlotText etc. kommer att skriva i.
  direction Ñr vinkeln (i grader) mot positiva x-axeln, rÑknat moturs }

var angle    : real;

begin
    angle:=pi*direction/180.0; { Omvandla till radianer }
    writeln (pl_file,'DI ',
             round (127.0*cos (angle)),',',round (127.0*sin (angle)));
    pl_errcheck;
end; { SetTextDirection }




procedure SetCharacterSize (width,height : real);
{ Ange storlek i cm fîr de tecken som skrivs av PlotText etc. }

begin
    if (width<=0) or (height<=0) then
        pl_error ('Felaktig teckenstorlek i SetCharacterSize');
    writeln (pl_file,'SI ',width:0:2,',',height:0:2);
    pl_errcheck;
end;



procedure SetCharacterSlant (angle : integer);
{ Ange lutning (i grader) fîr utskrivna tecken. Negativ vinkel ger
  lutning Üt vÑnster, positiv Üt hîger }

var a,t : real;

begin
    if (angle<=-90) or (angle>=90) then
        pl_error ('Felaktig teckenlutning (mÜste ligga mellan -90 och 90)');
    a:=angle*pi/180.0;
    t:=sin (a)/cos (a);
    writeln (pl_file,'SL ',t:0:2);
    pl_errcheck;
end;


procedure PlotText (txt : pl_string);
{ Skriv en strÑng }

var i : byte;

begin
    { ôversÑtt fîrst till 7-bits ASCII }
    for i:=1 to length (txt) do
        case txt [i] of
            'Ü' : txt [i]:='}';
            'Ñ' : txt [i]:='{';
            'î' : txt [i]:='|';
            'è' : txt [i]:=']';
            'é' : txt [i]:='[';
            'ô' : txt [i]:='\';
            'Å' : txt [i]:='~';
            'ö' : txt [i]:='^';
            'Ç' : txt [i]:='`';
            'ê' : txt [i]:='@';
         end;
     writeln (pl_file,'LB ',txt,#3);
     pl_errcheck;
end; { PlotText }



procedure PlotInteger (i,width : integer);
{ Skriv ett heltal. Utskriften formatteras som vid write (i:width). }

begin
    writeln (pl_file,'LB',i:width,#3);
    pl_errcheck;
end; { PlotInteger }



procedure PlotReal (x : real; width : integer);
{ Skriv ett reellt tal i e-format. Utskriften formatteras som vid
  write (x:width) }

begin
    writeln (pl_file,'LB',x:width,#3);
    pl_errcheck;
end; { PlotInteger }



procedure PlotFixReal (x : real; width,decimals : integer);
{ Skriv ett reellt tal med fix decimalpunkt och angivet antal
  decimaler. Format som vid write (x:width:decimals) }

begin
    writeln (pl_file,'LB',x:width:decimals,#3);
    pl_errcheck;
end; { PlotInteger }





{ *** Initierings- och avslutningsprocedurer *** }


procedure InitPlot (fileName : pl_string);
{ Initiera plottning: ôppna plottfil med angivet namn, sÑtt x- och
  y-koordinaterna till "omîjliga" vÑrden och ge initieringskommando
  till plottern. }

var i : byte;

begin
    for i:=1 to length (fileName) do
        fileName [i]:=UpCase (fileName [i]);
    if (fileName='COM1') or (fileName='COM2') or (fileName='AUX')
    or (fileName='LST') or (fileName='KBD') or (fileName='CON') then
        pl_error ('OtillÜtet namn pÜ plottfil');
    pl_x:=-maxint;
    pl_y:=-maxint;
    assign (pl_file,fileName);
    pl_errcheck;
    rewrite (pl_file);
    pl_errcheck;
    writeln (pl_file,'IN'); { Initiera plotter }
    pl_errcheck;
end; { InitPlot }



procedure ExitPlot (option : OutputOption);

{ Avsluta plottning: SÑtt tillbaka pennan och flytta till nedre
  vÑnstra hîrnet. Om option=plotter: kopiera plottfilen direkt till
  plottern och radera den frÜn disken, annars bara stÑng den }

var com2 : text;
    str  : pl_string;
    ch   : char;

begin
    MovePen (0,0);
    SelectPen (0);
    if option=plotter then begin
        writeln;
        writeln ('SlÜ pÜ plottern och anslut den till datorn');
        writeln ('Tryck dÑrefter pÜ mellanslag (CTRL-C avbryter)');
        repeat
            ch:=readkey;
        until ch=' ';
{$I+}
        assign (com2,'COM2');
        rewrite (com2);
        reset (pl_file);
        while not eof (pl_file) do begin
            readln (pl_File,str);
            writeln (com2,str);
        end;
        close (com2);
{$I-}
        erase (pl_file);
        pl_errcheck;
    end;
    close (pl_file);
    pl_errcheck;
end;

{$I+}
