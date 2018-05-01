{ *************************************
             P L O T    1.0
     Plotterrutiner för Turbo Pascal
        Magnus Olsson 7/10 1987
   ************************************ }


{ ***  Plottkoordinaterna anges som heltal i intervallet
       0..32767. (0,0) är nedre vänstra hörnet. Varje steg motsvarar
       1/40 mm på pappret.

  **** Plottkommandona skrivs till en extern fil. Efter avslutad körning
       kan man välja att få kommandona skickade direkt till plottern
       eller att behålla dem som en fil på disketten.
       Anledningen att kommandona inte skickas till plottern samtidigt
       som de ges är att det skulle binda upp plottern under hela
       exekveringstiden

  **** Följande globala identifierare är avsedda för internt bruk
       och skall inte användas av anropande program:

       pl_string (typ)
       pl_x,pl_y,pl_file (variabler)
       pl_error,pl_errcheck (procedurer)  }




{$I-}

type pl_string    = string [255];
     OutputOption = (plotter,disk);

var pl_x,pl_y : integer;      { Aktuell x- resp. y-koordinat - ändra *ej* }
    pl_file   : text;


{ *** Interna procedurer (skall ej anropas utifrån) *** }


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
{ Kontrollera om IO-fel har uppkommit och avbryt i så fall }

begin
    case IOResult of
          0 : ;
          3 : pl_error ('Plottfilen är ej öppen');
        $20 : pl_error ('Otillåtet filnamn för plottfil');
        $F0,
        $F1,
        $F2 : pl_error ('Skrivfel på plottfil, disken förmodligen full');
        $F3 : pl_error ('Skrivfel på plottfil, för många filer öppna');
        else  pl_error ('Skrivfel på plottfil');
    end;
end;



{ ***********************************************************************

          *** Dessa procedurer kan användas från programmet **

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



{ **** Grundläggande kommandon **** }


procedure SelectPen (pen : integer);
{ Välj penna }

begin
    if (pen<0) or (pen>8) then
        pl_error ('Felaktigt pennummer (måste ligga mellan 0 och 8)');
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
{ Välj linjetyp (heldragen, streckad etc. lineType=0 ger heldragen,
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
       else pl_error ('Otillåten linjetyp');
    end;
end; { SetLineType }




procedure PlotLineTo (x,y : integer);
{ Rita en linje från aktuell position till angiven punkt }

begin
    writeln (pl_file,'PD ',x,',',y);
    pl_errcheck;
    pl_x:=x;
    pl_y:=y;
end; { PlotLineTo }



procedure PlotLine (fromX,fromY,toX,toY : integer);
{ Rita en linje från punkten (fromX,fromY) till (toX,toY) }

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
{ Rita en rektangel. (x1,y1) resp (x2,y2) är koordinaterna för
  nedre vänstra resp. övre högra hörnet }

begin
    if (x1<>pl_x) or (y1<>pl_y) then
        MovePen (x1,y1);
    writeln (pl_file,'EA ',x2,',',y2);
    pl_errcheck;
end; { PlotRectangle }



{ **** Procedurer för plottning av text **** }


procedure SetTextDirection (direction : integer);
{ Ange den riktning som PlotText etc. kommer att skriva i.
  direction är vinkeln (i grader) mot positiva x-axeln, räknat moturs }

var angle    : real;

begin
    angle:=pi*direction/180.0; { Omvandla till radianer }
    writeln (pl_file,'DI ',
             round (127.0*cos (angle)),',',round (127.0*sin (angle)));
    pl_errcheck;
end; { SetTextDirection }




procedure SetCharacterSize (width,height : real);
{ Ange storlek i cm för de tecken som skrivs av PlotText etc. }

begin
    if (width<=0) or (height<=0) then
        pl_error ('Felaktig teckenstorlek i SetCharacterSize');
    writeln (pl_file,'SI ',width:0:2,',',height:0:2);
    pl_errcheck;
end;



procedure SetCharacterSlant (angle : integer);
{ Ange lutning (i grader) för utskrivna tecken. Negativ vinkel ger
  lutning åt vänster, positiv åt höger }

var a,t : real;

begin
    if (angle<=-90) or (angle>=90) then
        pl_error ('Felaktig teckenlutning (måste ligga mellan -90 och 90)');
    a:=angle*pi/180.0;
    t:=sin (a)/cos (a);
    writeln (pl_file,'SL ',t:0:2);
    pl_errcheck;
end;


procedure PlotText (txt : pl_string);
{ Skriv en sträng }

var i : byte;

begin
    { Översätt först till 7-bits ASCII }
    for i:=1 to length (txt) do
        case txt [i] of
            'å' : txt [i]:='}';
            'ä' : txt [i]:='{';
            'ö' : txt [i]:='|';
            'Å' : txt [i]:=']';
            'Ä' : txt [i]:='[';
            'Ö' : txt [i]:='\';
            'ü' : txt [i]:='~';
            'Ü' : txt [i]:='^';
            'é' : txt [i]:='`';
            'É' : txt [i]:='@';
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
{ Initiera plottning: Öppna plottfil med angivet namn, sätt x- och
  y-koordinaterna till "omöjliga" värden och ge initieringskommando
  till plottern. }

var i : byte;

begin
    for i:=1 to length (fileName) do
        fileName [i]:=UpCase (fileName [i]);
    if (fileName='COM1') or (fileName='COM2') or (fileName='AUX')
    or (fileName='LST') or (fileName='KBD') or (fileName='CON') then
        pl_error ('Otillåtet namn på plottfil');
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

{ Avsluta plottning: Sätt tillbaka pennan och flytta till nedre
  vänstra hörnet. Om option=plotter: kopiera plottfilen direkt till
  plottern och radera den från disken, annars bara stäng den }

var com2 : text;
    str  : pl_string;
    ch   : char;

begin
    MovePen (0,0);
    SelectPen (0);
    if option=plotter then begin
        writeln;
        writeln ('Slå på plottern och anslut den till datorn');
        writeln ('Tryck därefter på mellanslag (CTRL-C avbryter)');
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
