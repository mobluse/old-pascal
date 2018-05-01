(**************************************************************************
Filnamn                : HELP.PAS
Ver                    : 1.0
Copyright              : 1985 DATABITEN
Klass                  : Utilities
PASCAL version         : TURBO 3.x MS-DOS/PC-DOS, CP/M-86, Concurrent
Includefiler           :
External-filer         : diverse
Kod-storlek            :
Beskrivning            : Se HELP.DOC
****************************************************************************)

PROGRAM Help;

CONST
   _sizeExt = 10000;

TYPE
   ExtState  =

     (extOK,
      extFileMissing,
      extReadError,
      extOutOfMemory,
      extTypeError);

PROCEDURE Ext;

CONST
   extBuff: RECORD CASE BOOLEAN OF
               FALSE: (dummy: BYTE);
               TRUE:  (buff:  ARRAY(.1.._sizeExt.) OF BYTE);
            END = (dummy:$0);
BEGIN
   Halt;
END (* Ext *);

TYPE
   _FileName = STRING(.64.);

PROCEDURE LoadExt(    extName:_FileName;
                  VAR status:ExtState);

   VAR extFile:FILE;

   PROCEDURE TransferExt;

   CONST  recLen   = 128;
          pushBP   = $55;
          movBPSP  = $EC8B;

   TYPE
      FirstRec = BOOLEAN;
   VAR
      recBuf: RECORD CASE FirstRec OF
                 TRUE: (header:RECORD
                                  programInit:ARRAY(.1..30.) OF BYTE;
                                  programOfs:INTEGER;
                                  jumpMain:ARRAY(.1..3.) OF BYTE;
                                  subPushBP1:BYTE;
                                  subMovBPSP:INTEGER;
                                  subPushBP2:BYTE;
                                  subCode: ARRAY(.1..89.) OF BYTE;
                               END);
                 FALSE:(code:  ARRAY (.1..recLen.) OF BYTE);
              END;
      headerRec: BOOLEAN;
      dest, n: INTEGER;

   BEGIN
      headerRec:= TRUE;
      dest:= Ofs(Ext);
      WHILE  (NOT Eof(extFile)) AND (status=extOK) DO BEGIN
         BlockRead(extFile,recBuf,1);
         IF IoResult <> 0 THEN BEGIN
            status:= extReadError END
         ELSE BEGIN
            IF headerRec THEN BEGIN
                WITH recBuf.header DO BEGIN
                   IF (programOfs <>(dest - 3)) OR
                      (subPushBP1 <> pushBP)  OR
                      (subMovBPSP <> movBPSP) OR
                      (subPushBP2 <> pushBP)  THEN BEGIN
                      status:= extTypeError END
                   ELSE BEGIN
                      n:= 4 + SizeOf(subCode);
                      Move(subPushBP1,mem(.Cseg:dest.),n);
                      headerRec:= FALSE;
                   END
                END (* WITH *);END
            ELSE BEGIN (* headerRec = FALSE *)
               n:= recLen;
               Move(recBuf,mem(.Cseg:dest.),n);
            END (* IF *);
            dest:= dest + n;
         END (* IF *);
      END (* WHILE *);
   END (* TransferExt *);

BEGIN  (* LoadExt *)

  (*$I-*)
  status:= extOK;
  Assign(extFile,extName);
  Reset(extFile);
  IF IOresult <> 0 THEN BEGIN
     status:= extFileMissing END
  ELSE IF 128.0*FileSize(extFile) > _sizeExt THEN BEGIN
     status:= extOutOfMemory;
     Close(extFile) END
  ELSE BEGIN
     TransferExt;
     (*$I+*)
     Close(extFile);
  END;
END (* LoadExt*);

CONST line =

'--------------------------------------------------------------------------------';


PROCEDURE GetHelp; EXTERNAL Ext(.0.);

TYPE
   menuItem = RECORD
                mess:STRING(.30.);
                fn:STRING(.20.);
              END;

CONST
   max = 15;
CONST
   menu: ARRAY(.0..max.) OF menuItem =
            ((mess:'Avsluta';fn:''),
             (mess:'Kopiera filer';fn:'COPYFILE.CHN'),
             (mess:'Radera filer';fn:'ERAFILES.CHN'),
             (mess:'Byt namn p† fil';fn:'RENFILE.CHN'),
             (mess:'Ledigt utrymme p† disken';fn:'DISKFREE.CHN'),
             (mess:'Korsreferenser';fn:'XREF.CHN'),
             (mess:'';fn:''),
             (mess:'';fn:''),
             (mess:'';fn:''),
             (mess:'';fn:''),
             (mess:'';fn:''),
             (mess:'';fn:''),
             (mess:'';fn:''),
             (mess:'';fn:''),
             (mess:'';fn:''),
             (mess:'';fn:''));

VAR
   status: ExtState;
   item,maxItem:INTEGER;

PROCEDURE DispItems;
VAR i:INTEGER;
BEGIN
  i:= 0;
  WHILE menu(.i.).mess <> '' DO BEGIN
    GotoXY(25,6 + i);
    Write(i:2,'  ',menu(.i.).mess);
    i:= Succ(i);
  END (* WHILE *);
  maxItem:= i - 1;
END (* DispItems*);

PROCEDURE DispErrMess(status:ExtState);
CONST bel = #7;
VAR ch: CHAR;
BEGIN
   Write(bel);
   GotoXY(1,24);ClrEol;
   CASE status OF
     extFileMissing   : Write('Hj„lpprogram saknas.');
     extReadError     : Write('L„sfel vid laddning av hj„lpprogram.');
     extOutOfMemory   : Write('Hj„lpprogrammet ryms inte.');
     extTypeError     : Write('Fel typ eller version av hj„lpprogrammet.');
   END;
   Write(' Tryck <RET>: ');
   REPEAT UNTIL KeyPressed;
   Read(ch);
END (* DispErrMess *);


BEGIN (* huvudprogram *)
  REPEAT
     ClrScr;
     Write('*** HELP ***                        (c) 1985 DATABITEN':80);
     WriteLn(line);
     DispItems;
     GotoXY(1,21);WriteLn(line);
     (*$I-*)
     REPEAT
        GotoXY(1,22);Write('V„lj: ');
        ClrEol; BufLen:= 2; ReadLn(item);
     UNTIL (IoResult = 0) AND (0 <= item) AND (item <= maxItem);
     (*$I+*)
     IF item > 0 THEN BEGIN
        LoadExt(menu(.item.).fn,status);
        IF status = extOK THEN
          GetHelp
        ELSE DispErrMess(status);
     END (* IF *);
   UNTIL (item = 0);
END (* Help *).