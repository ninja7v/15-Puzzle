Program TaquinMain;

uses taquinoutils, TaquinIHM, crt {color}, keyboard {read a key}, dos {time}, sysutils, taquincalc;

var lvl,nbrmove:integer;
var t2:longint;
var gogame,goscore,gorules,quit:boolean;

BEGIN
repeat
menu(gogame,goscore,gorules,lvl);
if goscore then AffichageDesScores(lvl);
if gorules then rules(lvl); 
if gogame then
	begin
	repeat
		chooselevel(lvl);
		if (lvl>minlvl-1) and (lvl<maxlvl+1) then
			begin
			game(lvl,nbrmove,t2,quit);
			if quit=false then EnregistrementDesScores(lvl,nbrmove,t2);
			end;
	until (lvl=1) or (lvl=0);
	end;
until lvl=0;
END.
