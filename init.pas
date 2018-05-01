{ ***  INIT.PAS - initieringssekvens för elevprogram ***
       Magnus Olsson 8/10 1987

  ***  Denna fil skall inkluderas först i programmet men efter
       eventuell prgramrubrik

  Nedanstående direktiv kopplar input rill stdio för kompatibilitet
  med standardpascal, samt slår på testning för CTRL-C och felaktiga
  indexgränser under exekvering }

{$G256,U+,R+}