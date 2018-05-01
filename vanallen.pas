PROGRAM vanAllen;
	USES Crt, Graph;
  	{Lars Gislen, 25 augusti, 1992}
  CONST
  	k = 1;				{Magnetf„ltets styrka}
    dt0 = 0.01;		{Prelimin„rt tidssteg}
  VAR
  	x, y, z : Real;		{L„geskoordinater}
    vx,vy,vz : Real;	{Hastighet}
    i : Integer;	{R„knare}
    a2 : Real;		{Accelerationens ^2}

  PROCEDURE Initialize;
  	VAR
    	gd, gm, errCode : Integer;
    BEGIN
    	x := 1;		y := 0;		z := 0;		{Startl„ge}
      i := 0;
      a2 := 0.1;
      vx := 0.0;	vy := 0.1;	vz := 0.1;	{Starthastighet}
      gd := Detect;
      InitGraph(gd, gm, 'c:\bgi');
      errCode := GraphResult;
      IF errCode<>grOK THEN
      	Halt(1);
      PutPixel(150+Round(x*100), 250-Round(y*100), 15);
      PutPixel(470+Round(x*100), 250-Round(y*100), 15);
      Randomize;
    END;	{Initialize}

  PROCEDURE Step;
  	VAR
    	vxp, vyp, vzp : Real;		{Prelimin„r hastighet}
      dt : Real;							{Variabelt tidssteg}
      ax0, ay0, az0, ax1, ay1, az1 : Real;	{Accelerationer}
      r2, r5 : Real;					{Hj„lpvariabler}
    BEGIN
    	i := i+1;
      dt := dt0/a2;
      r2 := Sqr(x) + Sqr(y) + Sqr(z);
      r5 := Sqr(r2)*Sqrt(r2);
      ax0 := k*(vy*(3*z*z-r2)-3*vz*y*z)/r5;
      ay0 := k*(3*vz*x*z-vx*(3*z*z-r2))/r5;
      az0 := k*z*3*(vx*y-vy*x)/r5;
      x := x + vx*dt + 0.5*ax0*Sqr(dt);	{Uppdatera l„ge}
      y := y + vy*dt + 0.5*ay0*Sqr(dt);
      z := z + vz*dt + 0.5*az0*Sqr(dt);
      vxp := vx + ax0*dt;	{Prelimin„r hastighet}
      vyp := vy + ay0*dt;
      vzp := vz + az0*dt;
      ax1 := k*(vyp*(3*z*z-r2)-3*vzp*y*z)/r5; {Ny acceleration}
      ay1 := k*(3*vz*x*z-vxp*(3*z*z-r2))/r5;
      az1 := k*z*3*(vxp*y-vyp*x)/r5;
      a2 := Sqr(ax1) + Sqr(ay1) + Sqr(az1);   {Accelerationens belopp^2}
      IF a2<0.5 THEN
         a2 := 0.5;
      vx := vx + 0.5*(ax0+ax1)*dt; {Ny hastighet}
      vy := vy + 0.5*(ay0+ay1)*dt;
      vz := vz + 0.5*(az0+az1)*dt;
    END; {Step}

  PROCEDURE Plot;
    BEGIN
      IF (i MOD 10) = 0 THEN
        BEGIN
          PutPixel(150+Round((x+z)*100), 250-Round(y*100), 15);
          PutPixel(470+Round((x+z)*100+8*(x-y)), 250-Round(y*100), 15);
          i := 0;
          IF Random(100)=1 THEN       {Žndra hastighet}
            BEGIN
              vx := vx + 0.0005*(Random-0.5);
              vy := vy + 0.0005*(Random-0.5);
              vz := vz + 0.0005*(Random-0.5);
            END;
        END;
    END; {Plot}

BEGIN
  Initialize;
  REPEAT
    Step;
    Plot;
  UNTIL KeyPressed;
  CloseGraph;
END.  {vanAllen}