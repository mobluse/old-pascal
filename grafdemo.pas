{.72}
PROGRAM GrafDemo;

(* Anspråkslöst demo av grafiken i TURBO PASCAL ver 3.0  *)
(* (c) 1985 DATABITEN                                    *)

(*$I GRAPH.P *)

VAR
   x,y: INTEGER;
   ch:CHAR;
   ansikte: ARRAY[0..5000] OF BYTE;

BEGIN
   GraphColorMode;
   Palette(0);

   TurtleWindow(160,100,200,150);              (* Aktuellt fönster *)
   FillScreen(1);
   GotoXY(1,24); Write('Tryck valfri tangent');

   ShowTurtle;                                  (* Turtlen vandrar runt *)
   REPEAT
      TurnLeft(60);
      Forwd(Random(30));
   UNTIL KeyPressed;

   HideTurtle;                                 (* Invertera fönstret *)
   ColorTable(3,2,1,0);
   FillScreen(-1);
   Read(kbd,ch);

   Circle(100,60,35,1);                        (* Rita cirkel *)
   Read(kbd,ch);
   FillShape(120,70,3,1);                      (* Fyll cirkel *)

   SetHeading(220);                            (* Rita mun *)
   Arc(115,80,90,17,2);

   Circle(112,50,2,2);                         (* Rita höger öga *)
   FillShape(112,50,2,2);
   Circle(88,50,2,2);                          (* Rita vänster öga *)
   FillShape(88,50,2,2);

   Draw(100,50,105,70,2);                      (* Rita näsa *)
   Draw(105,70,100,70,2);


   GetPic(ansikte,65,25,135,95);               (* Spara ansikte *)
   Read(kbd,ch);

   REPEAT                                      (* Variera färg på ansikte *)
      ColorTable(Random(4),Random(4),Random(4),Random(4));
      PutPic(ansikte,60,95);
   UNTIL KeyPressed;
   Read(kbd,ch);

   Delay(500);                                  (* Ansiktet rör sig *)
   x:= 60; y:= 95;
   REPEAT
     PutPic(ansikte,x,y);
     y:= y + Random(13) - 6;
     x:= x + Random(13) - 6;
   UNTIL KeyPressed;

   TextMode;
END (* GrafDemo *).
