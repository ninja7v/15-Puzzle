Unit taquinoutils;
{This unit contains the types and constants}
interface

const
maxlvl=10;
minlvl=2;
MAXSS=3; {Maximum number of score saved}

type tab=array [1..maxlvl,1..maxlvl+1] of integer;

Type score=record
nametime:array[minlvl..maxlvl,1..MAXSS] of string;
scoretime:array[minlvl..maxlvl,1..MAXSS] of longint;
namemove:array[minlvl..maxlvl,1..MAXSS] of string;
scoremove:array[minlvl..maxlvl,1..MAXSS] of integer;
end;

implementation

BEGIN
END.
