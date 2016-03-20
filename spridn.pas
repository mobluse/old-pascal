{ Copyright 1989 by Mikael Bonnier }
program spridn(output,filus);

const pi=3.141592654;
      m=0.93827170;
      dxi=0.02;

var filus:file of real;
    xi,sigma:real;

function V(r:real):real;
begin
   V:=-0.063/(1+exp((r-20.5)/2.53));
end;


function A(xi:real):real;

const k=0.3;

begin
   A:=2*k*sin(xi/2);
end;


function igrand(r,xi:real):real;
begin
   igrand:=sin(A(xi)*r)*r*V(r);
end;


function integral(a,b,xi:real):real;

const dr=0.5;

var r,intgr:real;

begin
   r:=a+dr;
   intgr:=0;
   while r<=b do
     begin
       intgr:=intgr+igrand(r,xi)*dr;
       r:=r+dr;
     end;
   integral:=intgr;
end;


function f(xi:real):real;
begin
  f:=(4*pi*m/A(xi))*integral(0,60,xi);
end;

begin {spridn}
   assign(filus,'spridn.dat');
   rewrite(filus);
   xi:=dxi;
   while xi<=pi do
     begin
       sigma:=sqr(f(xi));
       writeln(output,xi,sigma);
       write(filus,xi,sigma);
       xi:=xi+dxi;
     end;
   close(filus);
end.
