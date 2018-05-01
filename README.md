# Old Pascal
These are some old [Pascal](https://en.wikipedia.org/wiki/Pascal_%28programming_language%29)-programs I wrote in Vax Pascal or Turbo Pascal between 1987 and 1992. You can run some of them in an [DOS-emulator that is a Java applet: JPC](http://www.df.lth.se.orbin.se/~mikaelb/jpc/pascal.html).

I converted them from [CP437](https://en.wikipedia.org/wiki/Code_page_437) to UTF8 using `iconv`. There is one
program, pu7.pas, that used [ISO646-SE](https://en.wikipedia.org/wiki/ISO/IEC_646), but that was converted
manually since it also uses square brackets for arrays.

I removed ^Z (end of file character) and changed CRLF to LF using
`sed -i -e 's/^Z//' -e 's/^M$//' filename.pas`, where ^Z is entered by typing Ctrl+V Ctrl+Z in Bash, and ^M, Ctrl+V Ctrl+M.

An alternative is to use `dos2unix`:  
`iconv -f CP437 -t UTF8 filename.pas | sed 's/^Z//' | dos2unix`

Now you can compile to `bubsigma`, `crcrcrlf`, `field`, `polsk`, `polsk2`, and `spridn` using `fpc`
(Free Pascal Compiler version 2.6.4 for Raspbian on Raspberry Pi). `pu7` uses different file procedures. 
The other programs uses unit Graph which I can't use yet in Raspbian Linux with X.
