const
  Steal_Divinity_ID = 1440;
  Steal_Divinity_CastTime = 228;
var
  aSkill: TL2Skill;
  aBuff: TL2Buff;
  aCharacter: TL2Live;
  intPart: Integer;
  intTemp: Integer;
type
  TofIIxI = function(a,b: Integer): Integer;
// do_<XXXXXX>


function do_steal(main: TL2Control; victim: TL2Control; vTimeToUseSkills: Integer; vID: Array of Integer): Integer; begin
  Result := 0;
  while fReuseTime(main, [Steal_Divinity_ID], max) > vTimeToUseSkills do delay(5);
  do_UseSkills(victim, vID);
  main.SetTarget(victim.GetUser);
  delay(500);
  while fCastTimeLeft(victim) > Steal_Divinity_CastTime do delay(1);
  repeat 
    main.UseSkill(Steal_Divinity_ID);
    Result := Result + 1;
  until fHasBuffs(main, vID);
end;
function do_UseSkills(control: TL2Control; vID: Array of Integer): Boolean; begin
  // if there is no such skill in skill list Result := false;
  while fReuseTime(control, vID, max) > 0 do delay(50);
  for intPart := 0 to high(vID)-1 do
    control.UseSKill(vID[intPart]);
  control.DUseSkill(vID[high(vID)], false, false); 
end;
// f<XXXXXXXXX>Time
function fCastTimeLeft(control: TL2Control): Integer; begin
  Result := control.GetUser.Cast.EndTime;
end;
function fReuseTime(control: TL2Control; vID: Array of Integer; f: TofIIxI): Integer; begin
  for intPart in vID do begin
    control.GetSkillList.ByID(intPart, aSkill);
    Result := f(Result, aSkill.EndTime);
  end;
  
  Result := aSkill.EndTime;
end;
function fHasBuffs(control: TL2Control; vID: Array of Integer): Boolean; begin
  Result := true;
  for intPart in vID do begin
    Result := Result and control.GetUser.Buffs.ByID(intPart, aBuff);
  end;
end;
// math
function countCastTime(control: TL2Control; vID: Array of Integer): Integer; begin
  Result := GetTickCount;
  for intPart := 0 to high(vID) do
    control.UseSKill(vID[intPart]);
  
  Result := (GetTickCount - Result);
  Print(Result);
end;
function max(a: Integer; b: Integer): Integer; begin
  if b > a then
    Result := b
  else 
    Result := a;
end;
function min(a,b: Integer): Integer; begin
  if b < a then
    Result := b
  else 
    Result := a;
end;
