Program koor(Input,Output);

{$I plot}

Begin
  initplot('kalle');
  selectpen(1);
  plotline(0,5000,15000,5000);
  plotline(7500,0,7500,10000);
  exitplot(plotter);
end.
