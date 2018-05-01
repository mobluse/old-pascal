{$R-}    {Range checking off}
{$B+}    {Boolean complete evaluation on}
{$S+}    {Stack checking on}
{$I+}    {I/O checking on}
{$N-}    {No numeric coprocessor}
{$M 65500,16384,655360} {Turbo 3 default stack and heap}

PROGRAM Bub;



CONST
      M1=938.0;     (* proton massan *)
      M2=140.0;     (* pi-meson massan *)
      pi=3.14159;

VAR
      R,R1,R2,R3,R4,R5 :Real;
      S0,S1,S2,S3,S4 :Real;
      P,P1,P2,F7,F8,M,T :Real;
      V,V1,V2,V3,V4 :Real;
      OK,Stop :Boolean;
      Bild :Integer;


FUNCTION FNF(Z :Real):Real;
 BEGIN
  Fnf:=F7+Z*(F8-F7)/31.5;         (* form 3 *)
 END;

FUNCTION FNZ(S :Real):Real;
 BEGIN
  Fnz:=31.5*F7*S/(F7*S+F8*(S0-S));       (* form 8b *)
 END;


FUNCTION Imp(R:Real):Real;
 CONST a0 = 4.9553;           (* Ger protonens begynnels-impuls *)
       a1 = 0.28559;          (* om stopp-sträckan är given     *)
       a2 = -0.0036692;       (* diagram sid. 2 i komp.         *)
       a3 = -0.00045705;
       a4 = 0.00017606;
 VAR p:Real;
  BEGIN
   R:=Ln(R);
   IF ((R < -4.3) OR (R > 9.3)) THEN
    OK:=FALSE;
   p:=a0+a1*R+a2*R*R+a3*R*R*R+a4*R*R*R*R;
   Imp:=Exp(p);
  END;


FUNCTION Range(P:Real):Real;
 CONST a0 = -8.3848;          (* Ger protonens stopp-sträcka     *)
       a1 = -2.1907;          (* om begynnelse-impulsen är given *)
       a2 = 1.1504;           (* diagram sid. 2 i komp.          *)
       a3 = -0.071070;
       a4 = -0.00057844;
 VAR r:Real;
  BEGIN
   P:=Ln(P);
   IF ((P < 3.7) OR (P > 8.3)) THEN
    OK:=FALSE;
   r:=a0+a1*P+a2*P*P+a3*P*P*P+a4*P*P*P*P;
   Range:=Exp(r);
  END;



PROCEDURE Inread;
 VAR ch:Char;
 BEGIN
  Write('SKAL FAKTORER: övre och nedre ? ');
  ReadLn(F8,F7);
  Write('AVSTÅNDET S0 ? ');
  ReadLn(S0);
  Write('Bild nr. ? ');
  ReadLn(Bild);
  Write('STANNADE PIMESONEN  (J/N) ? ');
  ReadLn(ch);
  Stop:=FALSE;
  IF ((ch = 'J') OR (ch = 'j')) THEN
   Stop:=TRUE;

    (*   INPUT VY 2: PROJ ÖPPNINGSVINKEL, PROJ LÄNGD LAMBDA,   *)
    (*   PROJ LÄNGD PROTON, PROJ LÄNGD PI, PI'S KRÖKNINGS-     *)
    (*   RADIE (OM PI EJ STANNAR), PROJ LÄNGD ÖVER VILKEN      *)
    (*   RADIEN BESTÄMTS (OM PI EJ STANNAR)                    *)

  IF Stop THEN
   BEGIN
    Write('VY 2  V,R1,R2,R3 ? ');
    ReadLn(V,R1,R2,R3);
   END
  ELSE
   BEGIN
    Write('VY 2  V,R1,R2,R3,R4,R5 ? ');
    ReadLn(V,R1,R2,R3,R4,R5);
   END;

    (*   INPUT S-VÄRDEN: LAMBDA PROD, LAMBDA SÖNDERFALL,   *)
    (*   PROTON STOPPUNKT, PIMESON PUNKT                   *)

  Write('VY 1&3  S1,S2,S3,S4 ? ');
  ReadLn(S1,S2,S3,S4);
 END;     (* ---Inread--- *)


PROCEDURE Calcula;
VAR com,F1,F2,F3 :Real;
 BEGIN
       (* Z-KOORDINATER  FORMEL 8B *)
  S1:=FNZ(S1);
  S2:=FNZ(S2);
  S3:=FNZ(S3);
  S4:=FNZ(S4);

       (* BERÄKNING AV ELEVATIONSVINKLAR FORMEL 9 *)
  F1:=FNF(0.5*(S2+S3));
  V1:=ArcTan((S3-S2)/(F1*R2));
  F2:=FNF(0.5*(S2+S4));
  V2:=ArcTan((S4-S2)/(F2*R3));
  F3:=FNF(0.5*(S1+S2));
  V4:=ArcTan((S2-S1)/(F3*R1));

       (* PROTONENS RÄCKVIDD OCH RÖRELSEMÄNGD *)
  R2:=R2*F1/Cos(V1);
  P1:=Imp(R2);

       (* PIMESONENS RÖRELSEMÄNGD       *)
       (* notera mass-skalnings formeln *)
  R3:=R3*F2/Cos(V2);
  IF Stop THEN
    P2:=(M2/M1)*Imp(R3*M1/M2)
  ELSE
   BEGIN
    P:=4.6*F2*R4/COS(V2);                 (* Formel 10 *)
    R:=(M2/M1)*Range(P*M1/M2);
    R:=R + 0.5*R5 * FNF((3*S2+S4)/4.0) / COS(V2);
    P2:=(M2/M1)*Imp(R*M1/M2);
   END;

    (* FORMEL 7 *)
  com:=COS(V*pi/180.0)*COS(V1)*COS(V2)+SIN(V1)*SIN(V2);

    (* FORMEL 6 *)
  M:=2*(SQRT(M1*M1+P1*P1)*SQRT(M2*M2+P2*P2)-P1*P2*com);
  M:=SQRT(M1*M1+M2*M2+M);

  P:=SQRT(P1*P1+P2*P2+2*P1*P2*com);  (* form 4 *)

  V3:=(P1*SIN(V1)+P2*SIN(V2))/P;     (* form 15 *)

  R:=F3*R1/SQRT(1.0-V3*V3);          (* form 16 *)
  V3:=ArcTan(V3/Sqrt(1.0-V3*V3));
  T:=R*M/(P*3.0E+10);                (* form 14 *)
 END;     (* ---Calcula--- *)


PROCEDURE Outwrite;
 BEGIN
  WriteLn;
  WriteLn;
  WriteLn('Bild nr. ',Bild);
  WriteLn('VERKLIGA LÄNGDER (CM) ');
  WriteLn('    PROTON : ',R2:8:2);
  WriteLn('    PI     : ',R3:8:2);
  WriteLn('    LAMBDA : ',R:8:2);
  WriteLn;
  WriteLn('ELEVATIONSVINKLAR (GRADER) ');
  WriteLn('    PROTON : ',180*V1/pi:8:0);
  WriteLn('    PI     : ',180*V2/pi:8:0);
  WriteLn('    LAMBDA : ',180*V3/pi:8:0,180*V4/pi:8:0);
  WriteLn('(från impuls bevaring och data resp.) ');
  WriteLn;
  WriteLn('RÖRELSEMÄNGDER (MEV/C) ');
  WriteLn('    PROTON : ',P1:8:0);
  WriteLn('    PI     : ',P2:8:0);
  WriteLn('    LAMBDA : ',P:8:0);
  WriteLn;
  WriteLn('***********************************');
  WriteLn('LAMBDA  MASSA (MEV/c2) = ',M:8:0);
  WriteLn('          LIVSTID (ps) = ',1.0E12*T:8:0);
  WriteLn('***********************************');
 END;     (* ---OutWrite--- *)



BEGIN     (* ---MAIN-PROGRAM--- *)
  Inread;
  OK:=TRUE;
  Calcula;
  IF OK THEN
   Outwrite
  ELSE
   WriteLn('Utanför diagrammet på sid 2 i komp.');
 END.
