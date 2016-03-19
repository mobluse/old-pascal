{ AUTOCORRELATOR SIMULATOR
  Programmer: Mikael Bonnier
  Location: Lund, Sweden
  Datum: 8th July 1990 MXM
  Language: Turbo Pascal 5.5 }

{$N+,E+,R-,S-}

program autocorrelator;

const lower = 0;  { lowest channel, channel zero normally
                    not available on a standard correlator }
      upper = 32; { upmost channel }

      tau = 0.0003125; {s}
      dt = 1E-4; {s}
      TST = 2; {s} { Total Sample Time }
      freq = 50;   {Hz}

type channels = array[lower..upper] of real;

var N : integer;
    G : channels;
    t, endtime : double;
    corrdata : text;
    filename : string;


function Intensity(t1 : real) : real;

    begin
        Intensity:=sqr( cos(2 * pi * freq * t1) );
    end;


begin
     writeln('Autokorrelator simulator.');
     write('Ange filnamn: ');
     readln(filename);
     assign(corrdata, filename);
     rewrite(corrdata);
     randomize;

     t := 1 / freq * random; { random starttime }
     endtime := t + TST;
     for N := lower to upper do
         G[N] := 0;

     repeat
           for N := lower to upper do
               begin
                    G[N] := G[N] + Intensity(t) * Intensity(t - N * tau);
               end;
           t := t + dt;
     until t > endtime;

     for N := lower to upper do
         writeln(corrdata, N, G[N] / TST);

     close(corrdata);
end.
