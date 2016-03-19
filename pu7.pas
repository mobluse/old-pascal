{ Copyright 1988 by Mikael Bonnier }
{ Vax-Pascal }
program bank(input,uppdatfil,kundregfil,kontoregfil,output,utfil);

   type konrtyp=1..maxint; 
        streng=packed array [1..20] of char;
        kontodatatyp=record
                        kontonr:konrtyp;
                        slag:1..3;
                        saldo:double;
                     end;
        kontopektyp=^kontotyp;
        kontotyp=record
                    data:kontodatatyp;
                    next:kontopektyp;
                 end;
        persdatatyp=array [1..6] of streng;
        perspektyp=^perstyp;
        perstyp=record
                   data:persdatatyp;
                   konto:kontopektyp;
                   next:perspektyp;
                end;

   var perspek:perspektyp;
       nextkontonr:konrtyp;
       kontoregfil,kundregfil,uppdatfil,utfil:text;
       heltslut:boolean;


   procedure meny;

      var instreng:streng;

   begin
      writeln;
      write('Tryck Return f|r forts{ttning!');
      readln(instreng);
      writeln(chr(12),'--- Huvudmeny ---');
      writeln;
      writeln('1. Huvudmeny');
      writeln('2. Nytt konto');
      writeln('3. Ta bort konto');
      writeln('4. Uppdatera konto');
      writeln('5. Utskrift');
      writeln('0. Avsluta');
      writeln;
      writeln('-----------------');
      writeln;
   end;

   procedure sokpersrek(persnr:streng;var pp,ppfore:perspektyp;
                        var fst:boolean);

   begin
      if pp<>nil then
        begin
           if pp^.data[1]=persnr then
              if pp=perspek then
                 fst:=true
              else
                 fst:=false
           else
              begin
                 ppfore:=pp;
                 pp:=pp^.next;
                 sokpersrek(persnr,pp,ppfore,fst);
              end;
           end;
   end; (* sokpersrek *)


   procedure fortsatt(var nxtknr:konrtyp;var slut:boolean);


      function intal:integer;
   
      var intalet:integer;

      begin
         write('val>');
         readln(intalet);
         intal:=intalet;
      end;

      procedure fel;
      begin
         writeln(chr(7),'Fel! Svara med 1,2,3,4,5,6,7 eller 8.');
      end;


      procedure sokpers(var persnumm:streng;var pp,ppfore:perspektyp;
                        var frst,tf:boolean);

      begin
         readln(persnumm);
         pp:=perspek;
         sokpersrek(persnumm,pp,ppfore,frst);
         if pp=nil then
            if tf then
               writeln(utfil,'Person ',persnumm,'finns ej i registret.')
            else            
               writeln('Person ',persnumm,'finns ej i registret.');
      end;

      procedure kontoslag(var pp:perspektyp;var nxtknr:konrtyp);

         var k:kontopektyp;
             intalet:integer;
             
      begin
         new(k);
         k^.next:=pp^.konto;
         pp^.konto:=k;
         pp^.konto^.data.kontonr:=nxtknr;
         nxtknr:=nxtknr+1;
         writeln;
         writeln('--- Kontoslag ---');
         writeln;
         writeln('1. Allemansspar');
         writeln('2. L|nekonto');
         writeln('3. Miljonkonto');
         writeln;
         writeln('-----------------');
         writeln;
         repeat
            write('konto');
            intalet:=intal;
            if not (intalet in [1..3]) then
               writeln(chr(7),'Fel! Svara med 1,2 eller 3.');
         until intalet in [1..3];
         pp^.konto^.data.slag:=intalet;
         pp^.konto^.data.saldo:=0;
         writeln;
         writeln('Kontot fick kontonr:',pp^.konto^.data.kontonr);
         writeln;
      end; (* kontoslag *)

      procedure nytt(var nxtkn:konrtyp);

         var persnummer:streng;
             persp,perspfore,p:perspektyp;
             first,tillfil:boolean;

      begin
         writeln(chr(12),'--- Nytt konto ---',chr(10));
         write('Personnummer: ');
         tillfil:=false;
         sokpers(persnummer,persp,perspfore,first,tillfil);
         if persp=nil then
            begin
               new(p);
               p^.next:=perspek;
               perspek:=p;
               persp:=perspek;
               with perspek^ do
               begin
                  data[1]:=persnummer;
                  writeln;
                  write('    Efternamn:');
                  readln(data[2]);
                  write('      F|rnamn:');
                  readln(data[3]);
                  write('   Gatuadress:');
                  readln(data[4]);
                  write('   Postadress:');
                  readln(data[5]);
                  write('Telefonnummer:');
                  readln(data[6]);
                  konto:=nil;
               end;
            end;
         kontoslag(persp,nxtkn);
         meny;
      end; (* nytt *)

      procedure sokkontorek(pp:perspektyp;knr:konrtyp;
                            var kp,kpfore:kontopektyp;var fstkonto:boolean);

      begin
         if kp<>nil then
            if kp^.data.kontonr=knr then
               if kp=pp^.konto then
                  fstkonto:=true
               else
                  fstkonto:=false
            else
               begin
                  kpfore:=kp;
                  kp:=kp^.next;
                  sokkontorek(pp,knr,kp,kpfore,fstkonto);
               end;
      end;

      procedure sokkonto(ppek:perspektyp;kontonr:konrtyp;
                         var kpek,kpekfore:kontopektyp;var frstkonto:boolean);
      begin
         kpek:=ppek^.konto;
         sokkontorek(ppek,kontonr,kpek,kpekfore,frstkonto);
      end;

      procedure tabort;
      
         var persnummer:streng;
             persp,perspfore:perspektyp;
             kontop,kontopfore:kontopektyp;
             kontonummer:konrtyp;
             first,firstkonto,tillfil:boolean;

      begin
         writeln('--- Ta bort konto ---');
         write('Personnummer: ');
         tillfil:=false;
         sokpers(persnummer,persp,perspfore,first,tillfil);
         if persp<>nil then
            begin
               write('Vilket kontonr:');
               readln(kontonummer);
               sokkonto(persp,kontonummer,kontop,kontopfore,firstkonto);
               if kontop=nil then
                  writeln('Personen ',persnummer,'har ej kontonr:',kontonummer)
               else
                  begin
                     if firstkonto then
                        persp^.konto:=kontop^.next
                     else
                        kontopfore^.next:=kontop^.next;
                     dispose(kontop);
                     if persp^.konto=nil then
                        begin
                           if first then
                              perspek:=persp^.next
                           else
                              perspfore^.next:=persp^.next;
                           dispose(persp);
                        end;
                  end;
            end;
         writeln;
         meny;
      end; (* tabort *)

      procedure letakontorek(var pepek:perspektyp;kontonum:konrtyp;
                             var kopek:kontopektyp);

         var kopekfore:kontopektyp;
             firstko:boolean;

      begin
         if pepek<>nil then
            begin
               sokkonto(pepek,kontonum,kopek,kopekfore,firstko);
               if kopek=nil then
                  begin
                     pepek:=pepek^.next;
                     letakontorek(pepek,kontonum,kopek);
                  end;
            end;
      end;

      procedure letakonto(var ppek:perspektyp;kontonumm:konrtyp;
                          var kpek:kontopektyp);

      begin
         ppek:=perspek;
         letakontorek(ppek,kontonumm,kpek);
         if kpek=nil then
            writeln('Kontonr:',kontonumm,' finns ej i registret');
      end;


      procedure utriktning(var tf:boolean);

         var svar:char;
             filnamn:streng;

      begin
         write('Utskrift till fil:(j/n)');
         readln(svar);
         writeln;
         tf:=svar in ['J','j'];
         if tf then
            begin
               write('Filnamn: ');
               readln(filnamn);
               open(utfil,filnamn,history:=new);
               rewrite(utfil);
            end;
      end; (* utriktning *)       


      procedure uppdatera;

         var tillfil,franfil:boolean;
             belopp:double;
             svar:char;
             filnamn,instreng:streng;
             persp:perspektyp;
             kontonummer:konrtyp;
             kontop:kontopektyp;

         function filslut(franfil:boolean):boolean;
         begin
            if franfil then
               filslut:=uppdatfil^='*'
            else
               filslut:=input^='*';
         end;

      begin
         writeln(chr(12),'--- Uppdatera ---',chr(10));
         writeln('Skriv p} formen:  kontonr belopp <CR>');
         writeln('                     .      .    <CR>');
         writeln('                     .      .    <CR>');
         writeln('                  * <CR>              (Slut p} uppdatering)');
         writeln;
         write('Uppdatera fr}n fil:(j/n)');
         readln(svar);
         franfil:=svar in ['J','j'];
         if franfil then
            begin
               open(utfil,'',history:=new);
               rewrite(utfil);
               writeln(utfil,'*');
               close(utfil);
               write('Filnamn: ');
               readln(filnamn);
               open(uppdatfil,filnamn,history:=readonly);
               reset(uppdatfil);
            end;
         writeln('Uppdaterade konton med negativt saldo kan skrivas till ');
         writeln('fil ist{llet f|r till sk{rm.');
         utriktning(tillfil); 
         writeln;
         while not filslut(franfil) do
         begin
            if franfil then read(uppdatfil,kontonummer) else read(kontonummer);
            letakonto(persp,kontonummer,kontop);
            if franfil then readln(uppdatfil,belopp) else readln(belopp);
            if kontop<>nil then
               begin
                  kontop^.data.saldo:=kontop^.data.saldo+belopp;
                  if kontop^.data.saldo<0 then
                     if tillfil then
                        writeln(utfil,'Kontonr:',kontonummer,' blev negativt.  Innehavare:',persp^.data[1])
                     else
                        writeln('Kontonr:',kontonummer,' blev negativt.  Innehavare:',persp^.data[1]);
               end;
         end;
         if franfil then
            close (uppdatfil)
         else
            readln(instreng);
         if tillfil then
            close(utfil);
         meny;
      end; (* uppdatera *)

      procedure utskrift;
      begin
         writeln(chr(12),'--- Utskrift ---');
         writeln;
         writeln('1. Huvudmeny');
         writeln('6. Vilka konton har person }}mmdd-xxxx');
         writeln('7. Vem har konto xx');
         writeln('8. Alla kunder och deras konton');
         writeln;
         writeln('----------------');
         writeln;
      end;

      procedure skrivkonto(var fil:text;kp:kontopektyp);
      begin
         with kp^.data do
         begin
            writeln(fil);
            writeln(fil,'  Kontonr:',kontonr);
            write(fil,'Kontoslag: ');
            case slag of
               1:writeln(fil,'Allemansspar');
               2:writeln(fil,'L|nekonto');
               3:writeln(fil,'Miljonkonto');
            end;
            writeln(fil,'    Saldo:',saldo:15:2);
         end;
      end; (* skrivkonto *)

      procedure skrivkontonrek(var kpek:kontopektyp;tifi:boolean);
      begin
         if kpek<>nil then
            begin
               if tifi then skrivkonto(utfil,kpek) else skrivkonto(output,kpek);
               kpek:=kpek^.next;
               skrivkontonrek(kpek,tifi);
            end;
      end;

      procedure vilkakonton;

         var persnummer:streng;
             persp,perspfore:perspektyp;
             kontop:kontopektyp;
             first,tillfil:boolean;

      begin
         writeln(chr(12),'--- Persons alla konton ---',chr(10));
         utriktning(tillfil);
         write('Personnummer: ');
         sokpers(persnummer,persp,perspfore,first,tillfil);
         if persp<>nil then
            begin
               kontop:=persp^.konto;
               skrivkontonrek(kontop,tillfil);
            end;
         if tillfil then
            close(utfil);
         meny;
      end;


      procedure vemhar;

         var i:1..6;
             tillfil:boolean;
             persp:perspektyp;
             kontop:kontopektyp;
             kontonummer:konrtyp;

      begin
         writeln(chr(12),'--- Vem har konto xx ---',chr(10));
         write('Kontonr: ');
         readln(kontonummer);
         utriktning(tillfil);
         letakonto(persp,kontonummer,kontop);
         if kontop<>nil then
            begin
               for i:=1 to 6 do
               if tillfil then
                  writeln(utfil,persp^.data[i])
               else
                  writeln(persp^.data[i]);
               if tillfil then skrivkonto(utfil,kontop) else skrivkonto(output,kontop);
            end;
         if tillfil then 
            close(utfil);
         meny;
      end;


      procedure allarek(var pp:perspektyp;tilfi:boolean);

         var i:1..6;
             kontop:kontopektyp;

      begin
         if pp<>nil then
            begin
               if tilfi then writeln(utfil,chr(10)) else writeln(chr(10));
               for i:=1 to 6 do
               if tilfi then
                  writeln(utfil,pp^.data[i])
               else
                  writeln(pp^.data[i]);
               kontop:=pp^.konto;
               skrivkontonrek(kontop,tilfi);
               pp:=pp^.next;
               allarek(pp,tilfi);
            end;
      end;

      procedure alla;

         var persp:perspektyp;
             tillfil:boolean;

      begin
         writeln('--- Alla konton i banken ---',chr(10));
         utriktning(tillfil);  
         persp:=perspek;
         allarek(persp,tillfil);
         if tillfil then
            close(utfil);
         meny;
      end;

   begin
      slut:=false;
      case intal of
         1:meny;
         2:nytt(nxtknr);
         3:tabort;
         4:uppdatera;
         5:utskrift;
         6:vilkakonton;
         7:vemhar;
         8:alla;
         0:slut:=true;
         otherwise fel;
      end;
   end; (* fortsatt *)


   procedure utkontorek(var pepek:perspektyp);

      var kontop:kontopektyp;
   
      procedure utkonto(pp:perspektyp;kp:kontopektyp);
      begin
         writeln(kontoregfil,pp^.data[1]);
         with kp^ do
         begin
            writeln(kontoregfil,data.kontonr);
            writeln(kontoregfil,data.slag);
            writeln(kontoregfil,data.saldo);
         end;
      end;
   
      procedure diskontonrek(var ppek:perspektyp;var kpek:kontopektyp);

         var k:kontopektyp;

      begin
         if kpek<>nil then
            begin
               utkonto(ppek,kpek);
               k:=kpek;
               kpek:=kpek^.next;
               dispose(k);
               diskontonrek(ppek,kpek);
            end;
      end;

   begin
      if pepek<>nil then
         begin
            kontop:=pepek^.konto;
            diskontonrek(pepek,kontop);
            pepek:=pepek^.next;
            utkontorek(pepek);
         end;
   end; (* utkontorek *)

   procedure utkontofil;

      var persp:perspektyp;

   begin
      open(kontoregfil,'kontoreg.txt',history:=new);
      rewrite(kontoregfil);
      persp:=perspek;
      utkontorek(persp);
      writeln(kontoregfil,'*');
      close(kontoregfil);
   end;


   procedure utkundrek(var pp:perspektyp);

      var i:1..6;
          p:perspektyp;

   begin
      if pp<>nil then
         begin
            for i:=1 to 6 do
            writeln(kundregfil,pp^.data[i]);
            p:=pp;
            pp:=pp^.next;
            dispose(p);
            utkundrek(pp);
         end;
   end;

   procedure utkundfil;

      var persp:perspektyp;

   begin
      open(kundregfil,'kundreg.txt',history:=new);
      rewrite(kundregfil);
      persp:=perspek;
      utkundrek(persp);
      writeln(kundregfil,'*');
      close(kundregfil);
   end;


   procedure inkundfil;

      var i:1..6;
          p:perspektyp;

   begin
      perspek:=nil;
      open(kundregfil,'kundreg.txt',history:=readonly);
      reset(kundregfil);
      while kundregfil^<>'*' do
      begin
         new(p);
         p^.next:=perspek;
         perspek:=p;
         for i:=1 to 6 do
         readln(kundregfil,perspek^.data[i]);
         perspek^.konto:=nil;
      end;
      close(kundregfil);
   end; (* inkundfil *)

   procedure inkontofil(var nxtknr:konrtyp);

      var persp,perspfore:perspektyp;
          k:kontopektyp;
          first:boolean;
          persnummer:streng;

   begin
      nxtknr:=1;
      open(kontoregfil,'kontoreg.txt',history:=readonly);
      reset(kontoregfil);
      while kontoregfil^<>'*' do
      begin
         new(k);
         readln(kontoregfil,persnummer);
         persp:=perspek;
         sokpersrek(persnummer,persp,perspfore,first);
         k^.next:=persp^.konto;
         persp^.konto:=k;
         with persp^.konto^ do
         begin
            readln(kontoregfil,data.kontonr);
            readln(kontoregfil,data.slag);
            readln(kontoregfil,data.saldo);
            if data.kontonr>=nxtknr then
               nxtknr:=data.kontonr+1;
         end;
      end;
      close(kontoregfil);
   end; (* inkontofil *)


   procedure init;

   var datum:packed array [1..11] of char;

   begin
      date(datum);
      writeln(chr(12),'V{lkommen till Mikael Bonnier',chr(39),'s bankprogram!');
      writeln('Idag {r det den ',datum,'.',chr(10));
      meny;
   end;


begin
   inkundfil;
   inkontofil(nextkontonr);
   init;
   repeat
      fortsatt(nextkontonr,heltslut)
   until heltslut;
   utkontofil;
   utkundfil;
end. (* bank *)



