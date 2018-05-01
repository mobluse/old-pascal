Program gissa_tal(input,output);

{$I init}

Const
  MAXTAL=100;

Var
  gissatal,slumptal:Integer;
  tkn:Char;

Begin

  Repeat
    Randomize;
    ClrScr;
    slumptal:=1+Random(MAXTAL);

    WriteLn('Gissa ett tal mellan 1 och ',MAXTAL,'.');

    Repeat
      Write('Gissa ett tal: ');
      ReadLn(gissatal);
      If gissatal<slumptal then
        WriteLn(gissatal,' var f”r litet.');
      If gissatal>slumptal then
        WriteLn(gissatal,' var f”r stort.');
    Until gissatal=slumptal;
    WriteLn('R„tt gissat, talet var ',slumptal);
    WriteLn('Vill du g”ra om det tryck "J"');
    Read(Kbd,tkn);

  Until not((tkn='j')or(tkn='J'));

End.
