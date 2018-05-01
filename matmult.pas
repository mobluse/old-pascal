Program matrismult(Input,Outut);

Const
  MAXELEMENT=20;

Type
  matris=Array[1..MAXELEMENT,1..MAXELEMENT] of Real;

Var
  ma,mb,mc:matris;
  nelm:Integer;
  tkn:Char;

Procedure nolla_mat(Var m:matris;n:Integer);

Var
  rad,kol:Integer;

Begin
  For rad:=1 To n Do
    Begin
      For kol:=1 To n Do
        Begin
          m[rad,kol]:=0;
        End;
    End;
End;  {nolla_mat}

Procedure las_in_mat(Var m:matris;n:Integer);

Var
  rad,kol:Integer;

Begin
  For rad:=1 To n Do
    Begin
      For Kol:=1 To n Do
        Begin
          Write('Element[',rad,',',kol,']:');
          ReadLn(m[rad,kol]);
        End;
    End;
End;  {las_in_mat}

Procedure matmult(Var m:matris;a,b:matris;n:Integer);

Var
  rad,kol,count:Integer;

Begin
  For rad:=1 To n Do
    Begin
      For kol:=1 To n Do
        Begin
          m[rad,kol]:=0;
          For count:=1 To n Do
            Begin
              m[rad,kol]:=m[rad,kol]+a[rad,count]*b[count,kol];
            End;
        End;
    End;
End;  {las_in_matmult}

Procedure skriv_ut_mat(m:matris;n:Integer);

Var
  rad,kol:Integer;

Begin
  For rad:=1 To n Do
    Begin
      For kol:=1 To n Do
        Begin
          Write(m[rad,kol]:8:2,' ');
        End;
      WriteLn;
    End;
End;  {skriv_ut_mat}

{**************************************************************************
               H„r b”rjar huvudprogrammet
**************************************************************************}


Begin
  Repeat
    ClrScr;
    Write('Hur m†nga rader/kolonner skall behandlas :');
    ReadLn(nelm);

    nolla_mat(ma,nelm);
    nolla_mat(mb,nelm);

    WriteLn('Inl„sning av den f”rsta matrisen.');
    las_in_mat(ma,nelm);

    WriteLn('Inl„sning av den andra matrisen.');
    las_in_mat(mb,nelm);

    matmult(mc,ma,mb,nelm);

    ClrScr;

    WriteLn('Den f”rsta matrisen:');
    skriv_ut_mat(ma,nelm);

    WriteLn('Den andra matrisen:');
    skriv_ut_mat(mb,nelm);

    Writeln('Resultatet av multiplikation med de tv† inmatade matriserna ovan.');
    skriv_ut_mat(mc,nelm);

    WriteLn('Vill du g”ra det en g†ng till tryck "J"');
    Read(Kbd,tkn);
  Until Not((tkn='J')or(tkn='j'));
End.
     {slut p† huvudprogrammet}


