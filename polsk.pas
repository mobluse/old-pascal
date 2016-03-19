program polsk_not;
(*
	Övning i användandet av (rättvänd) polsk notation.
	Syfte: För att förbättra förståelsen av algebra.
	Idé av Mikael Bonnier (C) 1993.

        Lärarversion.
*)

uses crt;

function add(x, y:real):real; forward;
function sub(x, y:real):real; forward;
function mul(x, y:real):real; forward;
function divi(x, y:real):real; forward;
function uht(x, y:real):real; forward;
function kvrt(x:real):real; forward;
function absb(x:real):real; forward;
function neg(x:real):real; forward;
function fakt(x:real):real; forward;
function godt(varbl:char; a, b:real):real; forward;
procedure lika(x, y:real); forward;


(* Beräkning. Här får du endast använda de ovan deklarerade funktionerna. *)
procedure main;

const
	(* pi: π *)
	pi = 3.14159265358979323846264338327950288;
  (* deg: 1° uttryckt i radianer *)
	deg = 0.01745329252; (* pi/180 *)

var
	u, v, w, x, y, z:real;
	svar1, svar2:real;

begin
	randomize;
	x := godt('x', 0, 10);
	y := godt('y', 0, 10);
	z := godt('z', 0, 10);

	writeln('* associativa lagen för addition: (x+y)+z = x+(y+z) *');
	svar1 := add(add(x,y), z);
	writeln;
	svar2 := add(x, add(y,z));
	lika(svar1, svar2);

	writeln('* kommutativa lagen för addition: x+y = y+x *');
	svar1 := add(x,y);
	writeln;
	svar2 := add(y,x);
	lika(svar1, svar2);

	writeln('* associativa lagen för multiplikation: (xy)z = x(yz) *');
	svar1 := mul(mul(x,y), z);
	writeln;
	svar2 := mul(x, mul(y,z));
	lika(svar1, svar2);

	writeln('* kommutativa lagen för multiplikation: xy = yx *');
	svar1 := mul(x,y);
	writeln;
	svar2 := mul(y,x);
	lika(svar1, svar2);

	writeln('* distributiva lagen, multiplikation över addition: x(y+z) = xy+xz *');
	svar1 := mul(x, add(y,z));
	writeln;
	svar2 := add(mul(x,y), mul(x,z));
	lika(svar1, svar2);

	writeln('* Pythagoras sats: z^2 = x^2 + y^2 *');
	svar1 := uht(z,2);
	writeln;
	svar2 := add(uht(x,2), uht(y,2));
	lika(svar1, svar2);

	writeln('* fakulteten av x: x! *');
	svar1 := fakt(x);

	writeln('* kvadratroten ur x: √x *');
	svar1 := kvrt(x);

  writeln('* absolutbeloppet av x: |x| *');
  svar1 := absb(x);

  writeln('* minus av x: -x *');
  svar1 := neg(x);
end; (* main *)


(* Addition: x + y *)
function add(x, y:real):real;

var t:real;

begin
	t := x + y;
	add := t;
	writeln('add(', x:12:6, ', ', y:12:6,') = ', t:12:6);
end; (* add() *)


(* Subtraktion: x - y *)
function sub(x, y:real):real;

var t:real;

begin
	t := x - y;
	sub := t;
	writeln('sub(', x:12:6, ', ', y:12:6,') = ', t:12:6);
end; (* sub() *)


(* Multiplikation: x·y *)
function mul(x, y:real):real;

var t:real;

begin
	t := x*y;
	mul := t;
	writeln('mul(', x:12:6, ', ', y:12:6,') = ', t:12:6);
end; (* mul() *)


(* Division: x/y *)
function divi(x, y:real):real;

var t:real;

begin
	t := x/y;
	divi := t;
	writeln('divi(', x:12:6, ', ', y:12:6,') = ', t:12:6);
end; (* divi() *)


(* Upphöjt till: x^y *)
function uht(x, y:real):real;

var t:real;

begin
	t := exp(ln(x)*y);
	uht := t;
	writeln('uht(', x:12:6, ', ', y:12:6,') = ', t:12:6);
end; (* uht() *)


(* kvadratroten: √x *)
function kvrt(x:real):real;

var t:real;

begin
	t := sqrt(x);
	kvrt := t;
	writeln('kvrt(', x:12:6, ') = ', t:12:6);
end; (* kvrt() *)


(* absolutbeloppet: |x| *)
function absb(x:real):real;

var t:real;

begin
  t := abs(x);
  absb := t;
  writeln('absb(', x:12:6, ') = ', t:12:6);
end; (* absb() *)


(* negationen: -x *)
function neg(x:real):real;

var t:real;

begin
  t := -x;
  neg := t;
  writeln('neg(', x:12:6, ') = ', t:12:6);
end; (* neg() *)


(* Fakultet: x! *)
function fakt(x:real):real;

var t:real;

	function fakt1(x:real):real;
	begin
		if x = 0 then
			fakt1 := 1
		else
			fakt1 := x*fakt1(x-1);
		write('.')
	end; (* fakt1() *)

begin
  x := trunc(x);
	t := fakt1(x);
	fakt := t;
	writeln;
	writeln('fakt(', x:12:6, ') = ', t:12:6);
end; (* fakt() *)


(* Ger ett godtyckligt tal x så att a ≤ x < b, dvs x ε [a,b) *)
function godt(varbl:char; a, b:real):real;

var t:real;

begin
	t := (b - a)*random+a; (* random tillhör intervallet [0,1) *)
	godt := t;
	writeln(varbl, ' := ', t:12:6);
end; (* godt() *)


procedure lika(x, y:real);

var ch:char;

begin
	write(x:12:6, ' = ', y:12:6);
	(* Om talen skiljer sig åt med mindre än en miljondel
		 så betraktas de som lika *)
	if abs(x-y) < 1E-6 then
		writeln(' SANT.')
	else
		writeln(' FALSKT.');
	ch := readkey;
	writeln;
end; (* lika() *)


begin
	main;
end. (* program polsk_not *)