PROGRAM FIELD(INPUT,OUTPUT);

CONST
     NX1=5;
     NX2=13;
     NX3=17;
     NX4=25;

     NY1=5;
     NY2=6;
     NY3=10;
     NY4=11;

     NX=30;
     NY=15;

     P=-40.0;
     DV=0.001;

VAR U,V:ARRAY [1..NX,1..NY] OF REAL;
    T:ARRAY [1..NX,1..NY] OF BOOLEAN;
    VG:REAL;


PROCEDURE INIT;

VAR I,J:INTEGER;

BEGIN
  FOR I:=1 TO NX do
    FOR J:=1 TO NY DO
    BEGIN
      U[I,J]:=0;
      T[I,J]:=FALSE;
    END;
  FOR I:=NX1 TO NX2 DO
  BEGIN
    U[I,NY4]:=P;
    U[I,NY1]:=P;
    T[I,NY4]:=TRUE;
    T[I,NY1]:=TRUE;
  END;
  FOR I:=NX3 TO NX4 DO
  BEGIN
    U[I,NY2]:=-P;
    U[I,NY3]:=-P;
    T[I,NY3]:=TRUE;
    T[I,NY2]:=TRUE;
  END;
  FOR I:=1 TO NX DO
  BEGIN
    T[I,1]:=TRUE;
    T[I,NY]:=TRUE;
  END;
  FOR J:=1 TO NY DO
  BEGIN
    T[1,J]:=TRUE;
    T[NY,J]:=TRUE;
  END;
  V:=U;
END;



FUNCTION RAND(X,Y:INTEGER):BOOLEAN;

BEGIN
  RAND:=T[X,Y];
END;



FUNCTION NEWVALUE(X,Y:INTEGER):REAL;

BEGIN
  IF RAND(X,Y) THEN
    NEWVALUE:=U[X,Y]
  ELSE
    NEWVALUE:=(U[X+1,Y]+U[X-1,Y]+U[X,Y+1]+U[X,Y-1])/4;
END;



PROCEDURE ITERATE;

VAR I,J:INTEGER;

BEGIN
  FOR I:=1 TO NX DO
    FOR J:=1 TO NY DO
      V[I,J]:=NEWVALUE(I,J);
  U:=V;
END;


PROCEDURE WRITEFILE;

VAR I,J:INTEGER;
    ESLASK:TEXT;

BEGIN
  ASSIGN(ESLASK,'SLASK.TXT');
  REWRITE(ESLASK);
  WRITELN(ESLASK,NX,' ',NY,' ',NX1,' ',NX2,' ',NX3,' ',NX4);
  WRITELN(ESLASK,NY1,' ',NY2,' ',NY3,' ',NY4);
  WRITELN(ESLASK,0,' ',P,' ',-P);
  FOR I:=1 TO NX DO
    FOR J:=1 TO NY DO
      WRITELN(ESLASK,U[I,J]);
  CLOSE(ESLASK);
END;




BEGIN
  INIT;
  REPEAT
    VG:=U[7,6];
    ITERATE;
    WRITELN(U[7,6]);
  UNTIL ABS(VG-U[7,6])<DV;
  WRITEFILE;
END.