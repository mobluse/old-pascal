program field(input, output, f);
(* Copyright (C) 1989  Mikael Bonnier, Lund, Sweden *)

const u0=0;

var f: text;
    nx, nx1, nx2, nx3, nx4: integer;
    ny, ny1, ny2, ny3, ny4: integer;
    i, j: integer;
    u1, u2: real;
    u, v: array[1..50, 1..15] of real;
    iter, iterationer: integer;

begin
   writeln('skriv in u1, u2:');
   readln(u1, u2);
   writeln('skriv in nx, ny:');
   readln(nx, ny);
   writeln('skriv in nx1, nx2, nx3, nx4:');
   readln(nx1, nx2, nx3, nx4);
   writeln('skriv in ny1, ny2, ny3, ny4:');
   readln(ny1, ny2, ny3, ny4);
   writeln('antal iterationer:');
   readln(iterationer);
   writeln('Nu börjar fältberäkningen!');
   for i:=1 to nx do
      for j:=1 to ny do
         u[i, j]:=u0;
   for i:=nx1 to nx2 do
      begin
         u[i, ny4]:=u1;
         u[i, ny1]:=u1;
      end;
   for i:=nx3 to nx4 do
      begin
         u[i, ny3]:=u2;
         u[i, ny2]:=u2;
      end;
   v:=u;
   for iter:=1 to iterationer do
      begin
         for i:=2 to nx-1 do
            for j:=2 to ny-1 do
               if not( ( ((j=ny4) or (j=ny1)) and (i in [nx1..nx2]) ) or
                       ( ((j=ny3) or (j=ny2)) and (i in [nx3..nx4]) ) ) then
                  v[i, j]:=( u[i+1, j] + u[i-1, j] + u[i, j+1] + u[i, j-1] )/4;
         u:=v;
      end;
   writeln('fältet sparas i filen: field_e.tmp');
   assign(f, 'field_e.tmp');
   rewrite(f);
   writeln(f, nx, ' ', ny, ' ', nx1, ' ', nx2, ' ', nx3, ' ', nx4);
   writeln(f, ny1, ' ', ny2, ' ', ny3, ' ', ny4);
   writeln(f, u0, ' ', u1, ' ', u2);
   for i:=1 to nx do
      for j:=1 to ny do
         writeln(f, u[i, j]);
   close(f);
end.
