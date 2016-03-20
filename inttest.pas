PROGRAM interrupttest;

USES Dos,Crt,Graph;

VAR regs           :Registers;
    grdriver,
    grmode         :Integer;

BEGIN

  DetectGraph(grdriver,grmode);
  InitGraph(grdriver,grmode,'c:\bgi');

  Line(0,0,GetMaxX,GetMaxY);
  Rectangle(50,50,100,100);

  FillChar(regs,SizeOf(regs),0);
  regs.AX:=$0;
  Intr($33,regs);

  FillChar(regs,SizeOf(regs),0);
  regs.AX:=$1;
  Intr($33,regs);

  REPEAT
  UNTIL KeyPressed;

  CloseGraph;

END.