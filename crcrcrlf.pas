program crcrcrlf;

var infil:file of char;
    utfil:file of char;
    innamn:string;
    utnamn:string;
    tecken:char;

begin
     write('Namn på infil med CR CR ?');
     readln(innamn);
     assign(infil,innamn);
     reset(infil);
     write('Namn på utfil med CR LF ?');
     readln(utnamn);
     assign(utfil,utnamn);
     rewrite(utfil);
     while not eof(infil) do
           begin
                read(infil,tecken);
                if tecken=chr(13) then
                   begin
                        write(utfil,tecken);
                        read(infil,tecken);
                        if tecken=chr(13) then
                           tecken:=chr(10);
                        write(utfil,tecken);
                   end
                else
                    write(utfil,tecken);
           end;
     close(utfil);
     close(infil);
end.
