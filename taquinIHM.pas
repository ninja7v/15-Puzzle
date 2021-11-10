Unit TaquinIHM;
{This unit focus on display and movements}
interface

uses taquinoutils, crt {color}, keyboard {read a key}, dos {time}, sysutils;

procedure EnregistrementDesScores(lvl,nbrmove:integer; t2:longint); 
procedure AffichageDesScores(var lvl:integer);
procedure chooselevel(var lvl:integer);
procedure display(lvl:integer; g:tab);
procedure move(lvl:integer; var col,lin:integer; var g:tab; var quit:boolean);
procedure menu(var gogame,goscore,gorules:boolean;var lvl:integer);

Implementation



procedure EnregistrementDesScores(lvl,nbrmove:integer; t2:longint); 

var tabscore:score;
	pseudo:string;
	i,j:integer;
	classement:file of score;

begin
if not(FileExists('fichierscoresftngame')) then
	Begin {creation of file}
	assign(classement, 'fichierscoresftngame');
	rewrite(classement);
	for i:=1 to MAXSS do {initiation of file}
		for j:=minlvl to maxlvl do
		begin
		tabscore.scoretime[j,i]:=1000000;
		tabscore.scoremove[j,i]:=10000;
		tabscore.nametime[j,i]:='user';
		tabscore.namemove[j,i]:='user';
		end;
	write(classement,tabscore);		
	close(classement);
	end;

assign(classement, 'fichierscoresftngame');
reset(classement);
read(classement, tabscore);

if (t2<tabscore.scoretime[lvl,MAXSS]) or (nbrmove<tabscore.scoremove[lvl,MAXSS]) then
	begin
	rewrite(classement);
	if t2<tabscore.scoretime[lvl,MAXSS]then {for the time}
		begin
		write('Good time ! pseudo : ');
		Readln(pseudo);
		i:=MAXSS;
		repeat
			if t2<tabscore.scoretime[lvl,i-1] then
				begin
				tabscore.scoretime[lvl,i]:=tabscore.scoretime[lvl,i-1];
				tabscore.nametime[lvl,i]:=tabscore.nametime[lvl,i-1];
				i:=i-1;
				end;
		until (t2>tabscore.scoretime[lvl,i-1]) or (i=1);
		tabscore.scoretime[lvl,i]:=t2;
		tabscore.nametime[lvl,i]:=pseudo;
		end;

	if nbrmove<tabscore.scoremove[lvl,MAXSS] then {for the number of moves}
		begin
		write('Good efficiency ! Pseudo : ');
		Readln(pseudo);
		i:=MAXSS;
		repeat
			if nbrmove<tabscore.scoremove[lvl,i-1] then
				begin
				tabscore.scoremove[lvl,i]:=tabscore.scoremove[lvl,i-1];
				tabscore.namemove[lvl,i]:=tabscore.namemove[lvl,i-1];
				i:=i-1;
				end;
		until (nbrmove>=tabscore.scoremove[lvl,i-1]) or (i=1);
		tabscore.scoremove[lvl,i]:=nbrmove;
		tabscore.namemove[lvl,i]:=pseudo;
		end;
		
	write(classement, tabscore);
	end;
close(classement);
End;



procedure AffichageDesScores(var lvl:integer);

var classement:file of score;
	i,j,l,c,pos,min,sec,cent,n:integer;
	K:TKeyEvent;
	tabscore:score;
	
Begin
clrscr;

if not(FileExists('fichierscoresftngame')) then writeln('No score saved yet.')
	else
	begin	
	assign(classement, 'fichierscoresftngame');
	reset(classement);
	Read(classement, tabscore);
	l:=2;
	InitKeyBoard();
	writeln('level [',l,']');
	writeln('Menu  [ ]');
	writeln('Exit  [ ]');
	writeln('');
	writeln('Press SPACEBAR to select.');
	pos:=wherey;
	gotoxy(8,pos-5);
	
	repeat
		K:=GetKeyEvent();
		K:=TranslateKeyEvent(K);
		if (KeyEventToString(K) = 'Up') and (wherey>pos-5) then	GotoXY(8,wherey-1);
		if (KeyEventToString(K) = 'Down') and (wherey<pos-3) then GotoXY(8,wherey+1);
		if (wherey=pos-5) and (KeyEventToString(K) = 'Left') or (KeyEventToString(K) = 'Right') then
			begin
			clrscr;
			if (KeyEventToString(K) = 'Left') and (l>2) then l:=l-1;
			if (KeyEventToString(K) = 'Right') and (l<10) then l:=l+1;
			writeln('level [',l,']');
			writeln('Menu  [ ]');
			writeln('Exit  [ ]');
			writeln('');
{
			if (tabscore.nametime[l,1]='user') and (KeyEventToString(K) = ' ') then
				begin
				gotoxy(1,7);
				writeln('No score saved yet.');
				end;
}
			writeln('Press SPACEBAR to select.');
			pos:=wherey;
			gotoxy(8,pos-5);
			end;
	until (KeyEventToString(K) = ' ') and ((tabscore.nametime[l,1]<>'user') or (wherey=pos-4) or (wherey=pos-3));
	c:=wherey;
	DoneKeyBoard();
	if c=pos-4 then lvl:=1;
	if c=pos-3 then lvl:=0;	
	if (c=pos-5) and (tabscore.nametime[l,1]<>'user') then
	begin
	clrscr;
	
	begin
	for i:=1 to MAXSS do
		begin
		if tabscore.nametime[l,i]<>'user' then
			begin
			min:=tabscore.scoretime[l,i] div 6000;
			sec:=(tabscore.scoretime[l,i]-min*6000) div 100;
			cent:=tabscore.scoretime[l,i]-sec*100;
			if cent<10 then write(i,'- ',tabscore.nametime[l,i],' : ',min,',',sec,',0',cent,' sec / ')
				else write(i,'- ',tabscore.nametime[l,i],' : ',min,',',sec,',',cent,' sec / ');
			end;
		end;
		
	writeln('');
	for i:=1 to MAXSS do
		if tabscore.namemove[l,i]<>'user' then
			write(i,'- ',tabscore.namemove[l,i],' : ',tabscore.scoremove[l,i],' moves / ');
	writeln('');
	close(classement);
	end;
	writeln('');
	writeln('Menu        [ ]');
	if FileExists('fichierscoresftngame') then writeln('Reset score [ ]');
	writeln('Exit        [ ]');
	writeln('');
	writeln('Press SPACEBAR to select.');
	pos:=wherey;
	if FileExists('fichierscoresftngame') then gotoxy(14,wherey-5) else gotoxy(14,wherey-4);
	InitKeyBoard();
	if FileExists('fichierscoresftngame') then n:=1 else n:=0;
	
	repeat
		K:=GetKeyEvent();
		K:=TranslateKeyEvent(K);
		if (KeyEventToString(K) = 'Up') and (wherey>pos-4-n) then GotoXY(14,wherey-1);
		if (KeyEventToString(K) = 'Down') and (wherey<pos-3) then GotoXY(14,wherey+1);
		c:=wherey;
	until KeyEventToString(K) = ' ';
	
	DoneKeyBoard();
	if (c=pos-4) and (FileExists('fichierscoresftngame')) then
		begin
		assign(classement, 'fichierscoresftngame');
		rewrite(classement);
		for i:=1 to MAXSS do
			for j:=minlvl to maxlvl do
				begin
				tabscore.scoretime[j,i]:=1000000;
				tabscore.scoremove[j,i]:=10000;
				tabscore.nametime[j,i]:='user';
				tabscore.namemove[j,i]:='user';
				end;
		write(classement,tabscore);
		close(classement);
		lvl:=1;
		end;
	if c=pos-3 then lvl:=0;
	if c=pos-5 then lvl:=1;
	end;
	close(classement);
end;
End;



procedure chooselevel(var lvl:integer);

var pos,c:integer;
	K:TKeyEvent;

begin
lvl:=2;
InitKeyBoard();
writeln('level [',lvl,']');
writeln('Menu  [ ]');
writeln('Exit  [ ]');
writeln('');
writeln('Press SPACEBAR to select.');
pos:=wherey;
gotoxy(8,pos-5);

repeat
K:=GetKeyEvent();
K:=TranslateKeyEvent(K);
if (KeyEventToString(K) = 'Up') and (wherey>pos-5) then	GotoXY(8,wherey-1);
if (KeyEventToString(K) = 'Down') and (wherey<pos-3) then GotoXY(8,wherey+1);
if (wherey=pos-5) and (KeyEventToString(K) = 'Left') or (KeyEventToString(K) = 'Right') then
	begin
		clrscr;
		if (KeyEventToString(K) = 'Left') and (lvl>2) then lvl:=lvl-1;
		if (KeyEventToString(K) = 'Right') and (lvl<10) then lvl:=lvl+1;
		writeln('level [',lvl,']');
		writeln('Menu  [ ]');
		writeln('Exit  [ ]');
		writeln('');
		writeln('Press SPACEBAR to select.');
		pos:=wherey;
		gotoxy(8,pos-5);
	end;
until KeyEventToString(K) = ' ';
c:=wherey;
DoneKeyBoard();
if c=pos-4 then lvl:=1;
if c=pos-3 then lvl:=0;
end;



procedure display(lvl:integer; g:tab);

var col,lin:integer;

begin
clrscr;
for lin:=1 to lvl do
	begin
	for col:=1 to lvl do
		begin
		if g[col,lin]<>0 then
			begin
			{for numbers <10, to keep the same spacing}
			if g[col,lin] mod 2=0 then textbackground(red);
			if (g[col,lin]<10) and (g[col,lin]>0) then write('0');
			{return to the line}
			if col=lvl then writeln(g[col,lin],' ') else write(g[col,lin],' ');
			end 
		else if col=lvl then writeln('') else write('   ');
		textbackground(black);
		end;
	end;
end;



procedure move(lvl:integer; var col,lin:integer; var g:tab; var quit:boolean);

var i:integer;
	ch:string;

begin
quit:=false;
repeat
	ch:=readkey;
	i:=ord(ch[1]);
	if i=32 then quit:=true;
	if (i=80) and (lin>1) then {go up a number}
		begin
		g[col,lin]:=g[col,lin-1];
		g[col,lin-1]:=0;
		lin:=lin-1;
		end
	else if (i=72) and (lin<lvl) then {go down a number}
		begin
		g[col,lin]:=g[col,lin+1];
		g[col,lin+1]:=0;
		lin:=lin+1;
		end
	else if (i=77) and (col>1) then {go left a number}
		begin
		g[col,lin]:=g[col-1,lin];
		g[col-1,lin]:=0;
		col:=col-1;
		end
	else if (i=75) and (col<lvl) then {go right a number}
		begin
		g[col,lin]:=g[col+1,lin];
		g[col+1,lin]:=0;
		col:=col+1;
		end
until (i=72) or (i=75) or (i=77) or (i=80) or (i=32);
end;



procedure menu(var gogame,goscore,gorules:boolean;var lvl:integer);

var c:integer;
	K:TKeyEvent;

Begin
InitKeyBoard();
gogame:=false;
goscore:=false;
gorules:=false;

clrscr;
writeln('15 Puzzle by Luc PREVOST');
writeln('');
writeln('Play           [ ]');
writeln('Consult scores [ ]');
writeln('Consult rules  [ ]');
writeln('Exit           [ ]');
writeln('');
writeln('Press SPACEBAR to select.');
gotoxy(17,3);

repeat
	K:=GetKeyEvent();
	K:=TranslateKeyEvent(K);
	if (KeyEventToString(K) = 'Up') and (wherey>3) then	GotoXY(17,wherey-1);
	if (KeyEventToString(K) = 'Down') and (wherey<6)then GotoXY(17,wherey+1);
	c:=wherey;
until (KeyEventToString(K) = ' ');

DoneKeyBoard();
case c of 3 : gogame:=true;
		4 : goscore:=true;
		5 : gorules:=true;
		6 : lvl:=0;
end;
clrscr;
End;

BEGIN
END.
