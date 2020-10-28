Unit Taquincalc;
{This unit contains procedures which do not interact with the player}
interface

uses taquinoutils, TaquinIHM, crt {color}, keyboard {read a key}, dos {time}, sysutils;

procedure check(lvl:integer; g:tab; var victory:boolean);
procedure grid(lvl:integer; var g:tab);
procedure scramble(lvl:integer; var col,lin:integer;var g:tab);
procedure stopwatch(t:longint; var min,sec,cent:integer; var t2:longint);
procedure rules(var lvl:integer);
procedure game(lvl:integer; var nbrmove:integer; var t2:longint; var quit:boolean);

implementation



procedure check(lvl:integer; g:tab; var victory:boolean);

var col,lin:integer;

begin
victory:=true;
if g[lvl,lvl]=0 then g[lvl,lvl]:=lvl*lvl;
for col:=1 to lvl do
	for lin:=1 to lvl do
		if g[col,lin]<>col+lvl*(lin-1) then victory:=false;
end;



procedure grid(lvl:integer; var g:tab);

var col,lin:integer;

begin
for col:=1 to lvl do
	for lin:=1 to lvl do g[col,lin]:=col+lvl*(lin-1);
g[lvl,lvl]:=0;
end;



procedure scramble(lvl:integer; var col,lin:integer;var g:tab);

var i,x,abs,ord,s:integer;

begin
col:=lvl;
lin:=lvl;
x:=0;
s:=10*(6+(lvl-3)*(lvl-3)+9*(lvl-2));
randomize;

for i:=1 to s do
	begin
	repeat
		abs:=random(3)-1;
		if abs=0 then ord:=random(3)-1;
		{condition to stay in the grid, to move in a case on a side not the previous one}
	until ((col+abs>0) and (col+abs<lvl+1) and (lin+ord>0) and (lin+ord<lvl+1)
	and ((abs<>0) or (ord<>0)) and ((abs=0) or (ord=0)) and (g[col+abs,lin+ord]<>x));
	g[col,lin]:=g[col+abs,lin+ord];
	g[col+abs,lin+ord]:=0;
	x:=g[col,lin];
	col:=col+abs;
	lin:=lin+ord;
	end;
end;



procedure stopwatch(t:longint; var min,sec,cent:integer; var t2:longint);

var t1:longint;
	h,m,s,c:word;

begin
gettime (h,m,s,c);
t1:=(h*36000+m*6000+s*100+c);
t2:=t1-t;
min:=t2 div 6000;
sec:=(t2-min*6000) div 100;
cent:=t2-min*6000-sec*100;
end;



procedure rules (var lvl:integer);

const l=4;

var g:tab;
	pos,c:integer;
	K:TKeyEvent;

begin
clrscr;
{display a right filled grid 4x4}
grid(l,g);
display(l,g);
writeln('');
writeln('You want this.');
writeln(' ');
writeln('First, choose a level between ',minlvl,' and ',maxlvl,'. The level actually corresponds to the dimension of the grid. Indeed, the level 4 corresponds to a 4x4 grid.');
writeln('Then, validate using the spacebar.');
writeln(' ');
writeln('Starting from a grid filled with randomly placed numbers, move the numbers using the empty cell to find the right order. To do so, use the arrows and the number will fill the empty cell following the direction selected.');
writeln('When you managed to solve the puzzle, enter your pseudo (dont call you "user", otherwise the score wont be saved). The three best scores are saved, they are available in the section "Consult scores".');
writeln('');
writeln('Menu [ ]');
writeln('Exit [ ]');
writeln('');
writeln('Press SPACEBAR to select.');
pos:=wherey;
gotoxy(7,pos-4);
InitKeyBoard();

repeat
	K:=GetKeyEvent();
	K:=TranslateKeyEvent(K);
	if ((KeyEventToString(K) = 'Up') and (wherey>pos-4)) then GotoXY(7,wherey-1);
	if ((KeyEventToString(K) = 'Down') and (wherey<pos-3))then GotoXY(7,wherey+1);
	c:=wherey;
until (KeyEventToString(K) = ' ');

DoneKeyBoard();
if (c=pos-4) then lvl:=1;
if (c=pos-3) then lvl:=0;
end;



procedure game(lvl:integer; var nbrmove:integer; var t2:longint; var quit:boolean);

var col,lin:integer;
	min,sec,cent:integer;
	t:longint;
	g:tab;
	victory:boolean;
	h,m,s,c:word;

begin
clrscr;
nbrmove:=0;
quit:=false;
grid(lvl,g);
scramble(lvl,col,lin,g);
display(lvl,g);
writeln(' ');
writeln('0,00,00');
writeln('Number of move : 0');
writeln(' ');
writeln('PRESS SPACEBAR to quit');
move(lvl,col,lin,g,quit);
gettime (h,m,s,c);
t:=(h*36000+m*6000+s*100+c);
nbrmove:=nbrmove+1;

if quit=false then {to make it possible to quit the game before the first move}
repeat {for each move}
	{for the stopwatch and the number of move}
	stopwatch(t,min,sec,cent,t2);
	display(lvl,g);
	writeln(' ');
	write(min,',');
	if sec<10 then write('0',sec,',') else write(sec,',');
	if cent<10 then write('0',cent) else write(cent);
	writeln('');
	if nbrmove<2 then writeln('Number of move : ', nbrmove)
		else writeln('Number of moves : ', nbrmove);
	writeln(' ');
	writeln('PRESS SPACEBAR to quit');
	move(lvl,col,lin,g,quit);
	check(lvl,g,victory);
	nbrmove:=nbrmove+1;
until victory=true or quit=true;

if victory=true then
	begin
	{to stop the time}
	stopwatch(t,min,sec,cent,t2);
	{to display the final grid ans the scores}
	display(lvl,g);
	writeln('');
	textcolor(green);
	write(min,',');
	if sec<10 then write('0',sec,',') else write(sec,',');
	if cent<10 then write('0',cent) else write(cent);
	textcolor(white);
	writeln('');
	if nbrmove<2 then writeln('Number of move : ', nbrmove)
		else writeln('Number of moves : ', nbrmove);
	Writeln('Puzzle solved !');
	writeln('');
	end;
end;

begin;
end.
