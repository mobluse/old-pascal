PROGRAM Nubbe;
uses graph,crt;


{ *******************************************
  ***                                     ***
  ***        NUBBE version 7.1            ***
  ***                                     ***
  ***     Ett program fîr lîsning av      ***
  *** den radiella Schrîdingerekvationen. ***
  ***  (Enligt Silverberg: Kvantmekanik)  ***
  ***  Datorlaboration pÜ Fysik 3 ht -89  ***
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
      maxTries = 7;      { Stîrsta antal fîrsîk som visas samtidigt }

      { Konstanten title Ñr den text som skrivs som rubrik pÜ plotten }
      title    = 'VÑteatomen';


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
{ Detta Ñr den potentiella energin som funktion av avstÜndet frÜn origo }

BEGIN
    V:=-2.0/r;
END; { V }



{ Fîljande fyra funktioner anvÑnds fîr att rÑkna om koordinater till
  skÑrmens respektive plotterns koordinatsystem }

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
{ LÑs in vÑrden pÜ diverse parametrar }

BEGIN
    REPEAT
        Write ('Ange rîrelsemÑngdsmomentets kvanttal (l >= 0): ');
        ReadLn (L);
    UNTIL l>=0;

    Write ('Ange styrkan hos LS-kopplingen: ');
    ReadLn (ls);

    Write ('Ange rmax (îvre grÑnsen fîr integrationsintervallet): ');
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
{ Lîs SE med angivna parametrar och energivÑrde E.
  Den berÑknade vÜgfunktionen lagras i G.
  Max och min av vÜgfunktionen returneras i Gmax och Gmin, medan
  returvÑrdet Ñr G(0), normerat sÜ Gmax-Gmin = 2000. }

VAR i    : Integer;
    r,Gr : Real;

BEGIN
    GotoXY (1,25);
    Write (#174:27,' Tystnad - geniet arbetar ',#175,'':25);
    Gmax:=-1e10; Gmin:=1e10;

    { BerÑkna startvÑrde fîr stort r }
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
{ Denna procedur plottar vÜgfunktionen G pÜ skÑrmen och skriver ut resultaten
  av de senaste fîrsîken om writeTries = TRUE }

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
        { Skriv ut resultat av tidigare fîrsîk }
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
{ Plotta vÜgfunktionen pÜ plottern }

VAR rScale,
    y0,i   : Integer;
    name   : String [80];
    E      : Real;

BEGIN
    TextMode (BW80);
    Write ('Skriv ditt namn (fîr mÑrkning av plotten): ');
    ReadLn (name);

    InitPlot ('nubbe.dat');

    { BerÑkna skalfaktor i r-led }
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
    PlotText ('EnerginivÜ(er):');
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
    PlotText ('NollvÑrde = ');
    PlotInteger (tries [try mod maxTries].G0,1);

    ExitPlot (plotter);
END;



PROCEDURE NewEnergy (VAR choice : Char; VAR energy : Real);
{ Denna procedur frÜgar efter înskat nytt energivÑrde. Om
  man svarar med ett negativt tal returneras detta i energy, och
  choice sÑtts till 'E'.

  Om man svarar med 'A', 'P' eller 'S' sÜ returneras denna bokstav
  i choice. I annat fall frÜgar datorn om. }


VAR str : String [80];
    pos : Integer;
    OK  : Boolean;

BEGIN
    REPEAT
        GotoXY (1,25);
        Write ('Ny energi (< 0)? P = Plotter, S = Skrivare, A = Avsluta');
        Write (' ':22);
        GotoXY (57,25);
        Read (str);           { LÑs in en teckenstrÑng }
        Val (str,energy,pos); { Fîrsîk tolka denna som ett reellt tal }
        IF pos=0 THEN BEGIN
            { TeckenstrÑngen gick att tolka som ett tal }
            choice:='E';
            OK:=E<0;  { Det inmatade talet mÜste vara negativt }
        END
        ELSE IF Length (str)=0 THEN
            { StrÑngen var tom }
            OK:=False
        ELSE BEGIN
            { Testa om strÑngen bîrjar pÜ 'P', 'S' eller 'A' }
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
    WriteLn ('…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª':52);
    WriteLn ('∫                    ∫':52);
    WriteLn ('∫      N U B B E     ∫':52);
    WriteLn ('∫     version 7.1    ∫':52);
    WriteLn ('∫                    ∫':52);
    WriteLn ('∫ Numerisk BerÑkning ∫':52);
    WriteLn ('∫ och Behandling av  ∫':52);
    WriteLn ('∫     EgenvÑrden     ∫':52);
    WriteLn ('∫                    ∫':52);
    WriteLn ('∫  av Magnus Olsson  ∫':52);
    WriteLn ('∫       ht -89       ∫':52);
    WriteLn ('∫                    ∫':52);
    WriteLn ('»ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº':52);
    WriteLn; WriteLn;
    TextColor (15);

    Input (n,l,E,rmax,ls);  { LÑs in parametrar och startvÑrde fîr E }
    l2:=l*(l+1);
    try:=0;

    REPEAT
       { Lîs radiella SE med aktuella parametrar, och lagra resultatet och E }
       tries [try mod maxTries].E:=E;
       tries [try mod maxTries].G0:=Solve (G,n,L2,E,rmax/n,Gmax,Gmin);

       { Plotta kurvan }
       PlotOnScreen (G,n,try,rmax/n,tries,TRUE);

       { LÑs in ny energi, eller ett kommando }
       NewEnergy (choice,E);

       IF choice='S' THEN BEGIN
           E:=tries [try mod maxTries].E;
           PlotOnScreen (G,n,try,rmax/n,tries,FALSE);
           GotoXY (30,1); Write (title);
           GotoXY (50,1); Write ('L = ',L);
           GotoXY (50,2); Write ('LS = ',ls:1:5);
           GotoXY (50,3); Write ('rmax = ',rmax:1:0);
           GotoXY (50,5); Write ('EnerginivÜ(er):');
           GotoXY (52,6); Write ('j = ',2*L+1,'/2: ',E-L*ls:1:6);
           IF L>0 THEN BEGIN
               GotoXY (52,7); Write ('j = ',2*L-1,'/2: ',E+(L+1)*ls:1:6);
           END;
           GotoXY (1,25);
           Write ('Tryck pÜ PrtScr fîr skÑrmdump ',
                  'och pÜ return fîr att avsluta!');
           ReadLn;
       END
       ELSE IF choice='P' THEN
           PlotOnPlotter (G,n,try,tries,ls)
       ELSE { ny energi }
           try:=try+1;

    UNTIL choice<>'E';

    { èterstÑll skÑrmen till textmod }
    TextMode (BW80);
END.
