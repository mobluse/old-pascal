PROGRAM Nubbe;
uses graph,crt;


{ *******************************************
  ***                                     ***
  ***        NUBBE version 7.1            ***
  ***                                     ***
  ***     Ett program för lösning av      ***
  *** den radiella Schrödingerekvationen. ***
  ***  (Enligt Silverberg: Kvantmekanik)  ***
  ***  Datorlaboration på Fysik 3 ht -89  ***
  ***                                     ***
  ***                                     ***
  ***       Magnus Olsson  890907         ***
  ***       Teoretisk fysik, Lund         ***
  ***                                     ***
  ******************************************* }


{$I plot}
{$V-}

CONST maxSteps = 1000;   { Maximalt antal steg }
      rmin     = 0.0;
      bottom   = 190;
      maxTries = 7;      { Största antal försök som visas samtidigt }

      { Konstanten title är den text som skrivs som rubrik på plotten }
      title    = 'Väteatomen';


TYPE WaveFunction = ARRAY [0..maxSteps] OF Real;
     TryRecord    = RECORD
                        G0 : Integer;
                        E  : Real;
                    END;
     TryVector    = ARRAY [0..maxTries] OF TryRecord;


VAR L,L2,n,try : integer;
    E,rmax,ls,
    Gmax,Gmin,
    G0         : real;
    G          : WaveFunction;
    tries      : TryVector;
    choice     : Char;



FUNCTION V (r : Real) : Real;
{ Detta är den potentiella energin som funktion av avståndet från origo }

BEGIN
    V:=-2.0/r;
END; { V }



{ Följande fyra funktioner används för att räkna om koordinater till
  skärmens respektive plotterns koordinatsystem }

FUNCTION RCoord (r : Real) : Integer;

BEGIN
    RCoord:=Round (639 * (r - rmin) / (rmax - rmin));
END;


FUNCTION GCoord (G : Real) : Integer;

BEGIN
    GCoord:=bottom - Round (bottom * ((G - Gmin) / (Gmax - Gmin)));
END;


FUNCTION PlotRCoord (r : Real; rScale : Integer) : Integer;

BEGIN
    PlotRCoord:=Round (rScale * r) + 1000;
END;


FUNCTION PlotGCoord (G : Real) : Integer;

BEGIN
    PlotGCoord:=Round (8000.0 * (G - Gmin) / (Gmax - Gmin)) + 1000;
END;







PROCEDURE Input (VAR steps,L : Integer; VAR E,rmax,ls : Real);
{ Läs in värden på diverse parametrar }

BEGIN
    REPEAT
        Write ('Ange rörelsemängdsmomentets kvanttal (l >= 0): ');
        ReadLn (L);
    UNTIL l>=0;

    Write ('Ange styrkan hos LS-kopplingen: ');
    ReadLn (ls);

    Write ('Ange rmax (övre gränsen för integrationsintervallet): ');
    ReadLn (rmax);

    REPEAT
        Write ('Ange antal steg (3-',maxSteps-1,'): ');
        ReadLn (steps);
    UNTIL (steps < maxSteps) AND (steps >= 3);

    REPEAT
        Write ('Ange energi (E < 0): ');
        ReadLn (E);
    UNTIL E<0;
END; { Input }



FUNCTION Solve (VAR G : WaveFunction; n,L2 : Integer; E,dr : Real;
                VAR Gmax,Gmin : Real) : Integer;
{ Lös SE med angivna parametrar och energivärde E.
  Den beräknade vågfunktionen lagras i G.
  Max och min av vågfunktionen returneras i Gmax och Gmin, medan
  returvärdet är G(0), normerat så Gmax-Gmin = 2000. }

VAR i    : Integer;
    r,Gr : Real;

BEGIN
    GotoXY (1,25);
    Write (#174:27,' Tystnad - geniet arbetar ',#175,'':25);
    Gmax:=-1e10; Gmin:=1e10;

    { Beräkna startvärde för stort r }
    G [n]:=1;
    G [n-1]:=Exp (Sqrt (-E)*dr);

    FOR i:=n-1 DOWNTO 1 DO BEGIN
        r:=i*dr;
        Gr:=(2 + dr*dr * ((V (r) - E) + L2 / (r*r))) * G [i] - G [i+1];
        G [i-1]:=Gr;
        IF Gr > Gmax THEN Gmax:=Gr;
        IF Gr < Gmin THEN Gmin:=Gr;
    END;

    Solve:=Round (2000.0 * G [0] / (Gmax - Gmin));  { Normerat G(0) }
END;




PROCEDURE PlotOnScreen (VAR G : WaveFunction; n,try : Integer; dr : Real;
                        VAR tries : TryVector; writeTries : Boolean);
{ Denna procedur plottar vågfunktionen G på skärmen och skriver ut resultaten
  av de senaste försöken om writeTries = TRUE }

VAR i,driver,mode  : Integer;
    ch : Char;
    s:string;

BEGIN
    driver:=cga; mode:=cgahi;
    initgraph(driver,mode,'');
    line (0,GCoord (0),639,GCoord (0));
    line (0,0,0,bottom);
    FOR i:=n DOWNTO 1 DO
        line (RCoord (i * dr),GCoord (G [i]),
              RCoord ((i-1) * dr),GCoord (G [i-1]));
    IF writeTries THEN BEGIN
        { Skriv ut resultat av tidigare försök }
        outtextxy (440,8,'Energi');
        outtextxy (552,8,'G(0)');
        IF try < maxTries THEN
            FOR i:=0 TO try DO BEGIN
                WITH tries [i] DO
                    str(e:14:10,s);
                    outtextxy(440,16+8*i,s);
                    str(g0:6,s);
                    outtext(s);
            END
        ELSE
            FOR i:=try-maxTries+1 TO try DO BEGIN
                GotoXY (55,1+i-try+maxTries);
                WITH tries [i mod maxTries] DO
                     begin
                          str(e:14:10,s);
                          outtext(s);
                          str(g0:6,s);
                          outtext(s);
                     end
            END
    END
END; { PlotOnScreen }



PROCEDURE PlotOnPlotter (VAR G : WaveFunction; n,try : Integer;
                         VAR tries : TryVector; ls : Real);
{ Plotta vågfunktionen på plottern }

VAR rScale,
    y0,i   : Integer;
    name   : String [80];
    E      : Real;

BEGIN
    TextMode (BW80);
    Write ('Skriv ditt namn (för märkning av plotten): ');
    ReadLn (name);

    InitPlot ('nubbe.dat');

    { Beräkna skalfaktor i r-led }
    rScale:=Round (12000.0/n);

    { Rita axlar }
    y0:=PlotGCoord (0.0);
    SelectPen (1);
    PlotLine (1000,1000,1000,9000);
    PlotLine (PlotRCoord (n,rScale),y0,1000,y0);


    { Rita kurvan }
    SelectPen (2);
    MovePen (PlotRCoord (n,rScale),PlotGCoord (G [n]));

    FOR i:=n-1 DOWNTO 0 DO
         PlotLineTo (PlotRCoord (i,rScale),PlotGCoord (G [i]));

    { Skriv text }
    SelectPen (1);

    MovePen (13200,y0); PlotText ('r');
    MovePen (920,9200); PlotText ('G = r*R');
    MovePen (11000,9800); PlotText (name);
    MovePen (11000,9000); PlotText (title);

    MovePen (11000,8600);
    PlotText ('L = ');
    PlotInteger (L,1);
    PlotText ('    LS = ');
    PlotFixReal (ls,1,5);

    MovePen (11000,8200);
    PlotText ('Integrationsintervall: 0 - ');
    PlotFixReal (rMax,1,1);

    MovePen (11000,7800);
    PlotText ('Antal steg = ');
    PlotInteger (n,1);

    MovePen (11000,7400);
    PlotText ('Energinivå(er):');
    E:=tries [try mod maxTries].E;
    MovePen (12500,7050);
    PlotText ('j = '); PlotInteger (2*L+1,1); PlotText ('/2: ');
    PlotFixReal (E-L*ls,1,6);

    IF L>0 THEN BEGIN
        MovePen (12500,6700);
        PlotText ('j = '); PlotInteger (2*L-1,1); PlotText ('/2: ');
        PlotFixReal (E+(L+1)*ls,1,6);
    END;

    MovePen (11000,6300);
    PlotText ('Nollvärde = ');
    PlotInteger (tries [try mod maxTries].G0,1);

    ExitPlot (plotter);
END;



PROCEDURE NewEnergy (VAR choice : Char; VAR energy : Real);
{ Denna procedur frågar efter önskat nytt energivärde. Om
  man svarar med ett negativt tal returneras detta i energy, och
  choice sätts till 'E'.

  Om man svarar med 'A', 'P' eller 'S' så returneras denna bokstav
  i choice. I annat fall frågar datorn om. }


VAR str : String [80];
    pos : Integer;
    OK  : Boolean;

BEGIN
    REPEAT
        GotoXY (1,25);
        Write ('Ny energi (< 0)? P = Plotter, S = Skrivare, A = Avsluta');
        Write (' ':22);
        GotoXY (57,25);
        Read (str);           { Läs in en teckensträng }
        Val (str,energy,pos); { Försök tolka denna som ett reellt tal }
        IF pos=0 THEN BEGIN
            { Teckensträngen gick att tolka som ett tal }
            choice:='E';
            OK:=E<0;  { Det inmatade talet måste vara negativt }
        END
        ELSE IF Length (str)=0 THEN
            { Strängen var tom }
            OK:=False
        ELSE BEGIN
            { Testa om strängen börjar på 'P', 'S' eller 'A' }
            choice:=UpCase (str [1]);
            OK:=choice in ['P','S','A'];
        END;
        IF NOT OK THEN BEGIN
            { Fel; pip till }
            Sound (1000);
            Delay (100);
            NoSound;
        END;
    UNTIL OK;
END; { NewEnergy }



BEGIN
    ClrScr;
    TextColor (14);
    WriteLn ('╔════════════════════╗':52);
    WriteLn ('║                    ║':52);
    WriteLn ('║      N U B B E     ║':52);
    WriteLn ('║     version 7.1    ║':52);
    WriteLn ('║                    ║':52);
    WriteLn ('║ Numerisk Beräkning ║':52);
    WriteLn ('║ och Behandling av  ║':52);
    WriteLn ('║     Egenvärden     ║':52);
    WriteLn ('║                    ║':52);
    WriteLn ('║  av Magnus Olsson  ║':52);
    WriteLn ('║       ht -89       ║':52);
    WriteLn ('║                    ║':52);
    WriteLn ('╚════════════════════╝':52);
    WriteLn; WriteLn;
    TextColor (15);

    Input (n,l,E,rmax,ls);  { Läs in parametrar och startvärde för E }
    l2:=l*(l+1);
    try:=0;

    REPEAT
       { Lös radiella SE med aktuella parametrar, och lagra resultatet och E }
       tries [try mod maxTries].E:=E;
       tries [try mod maxTries].G0:=Solve (G,n,L2,E,rmax/n,Gmax,Gmin);

       { Plotta kurvan }
       PlotOnScreen (G,n,try,rmax/n,tries,TRUE);

       { Läs in ny energi, eller ett kommando }
       NewEnergy (choice,E);

       IF choice='S' THEN BEGIN
           E:=tries [try mod maxTries].E;
           PlotOnScreen (G,n,try,rmax/n,tries,FALSE);
           GotoXY (30,1); Write (title);
           GotoXY (50,1); Write ('L = ',L);
           GotoXY (50,2); Write ('LS = ',ls:1:5);
           GotoXY (50,3); Write ('rmax = ',rmax:1:0);
           GotoXY (50,5); Write ('Energinivå(er):');
           GotoXY (52,6); Write ('j = ',2*L+1,'/2: ',E-L*ls:1:6);
           IF L>0 THEN BEGIN
               GotoXY (52,7); Write ('j = ',2*L-1,'/2: ',E+(L+1)*ls:1:6);
           END;
           GotoXY (1,25);
           Write ('Tryck på PrtScr för skärmdump ',
                  'och på return för att avsluta!');
           ReadLn;
       END
       ELSE IF choice='P' THEN
           PlotOnPlotter (G,n,try,tries,ls)
       ELSE { ny energi }
           try:=try+1;

    UNTIL choice<>'E';

    { Återställ skärmen till textmod }
    TextMode (BW80);
END.
