program kalle(input,output);

var a:real;

begin
  a:=-2;
  while a<2 do
  begin
    writeln(a,arctan(a));
    a:=a+0.2;
  end;
end.
