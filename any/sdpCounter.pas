unit sdpCounter;
interface
procedure useSkills(vString: String); Overload;
procedure useSkills(arr: Array of String); Overload;
procedure useSkills(vControl: TL2Control; arr: Array of String); Overload;
  
procedure setToggle(arr: Array of String; vState: Boolean); Overload;
function countMobTargetors(): Integer; Overload;
function countMobTargetors(vParam1: TL2Live): Integer; Overload;
function skillReuse(vName: String): Integer; Overload;

function buffCount(nick: String; arr: Array of String; time: Integer = 60000): Integer; Overload;
function buffCount(nick: String; time: Integer = 60000): Integer; Overload;
function buffCount(time: Integer = 60000): Integer; Overload;
function buffCount(vControl: TL2Control; arr: Array of String; time: Integer = 60000): Integer; Overload; 

function buffTime(vID: Integer): Integer; Overload;
function buffTime(vName: String): Integer; Overload;
implementation
Uses sdpStrings;
procedure useSkills(vString: String); Overload;
  begin
    useSkills([vString]);
  end;
procedure useSkills(arr: Array of String); Overload;
  begin
    useSkills(Engine, arr);
  end;
procedure useSkills(vControl: TL2Control; arr: Array of String); Overload;
  var part: String;
  begin
    for part in arr do
    begin
      vControl.UseSkill(part); 
      Delay(10);

    end;
  end;
procedure setToggle(arr: Array of String; vState: Boolean); Overload;
  var aBuff: TL2Buff; part: String;
  begin
    for part in arr do 
    begin
      if    (User.Buffs.ByName(part, aBuff) and not vState) 
         or (not User.Buffs.ByName(part, aBuff) and vState) 
      then Engine.UseSkill(part);
    end;
  end;
function countMobTargetors(): Integer; Overload;
  begin
    Result := countMobTargetors(User as TL2Live);
  end;
function countMobTargetors(vParam1: TL2Live): Integer; Overload;
  var 
    i, sum: Integer;
    aMob: TL2Npc;
  begin
    sum := 0;
    for i := 0 to NpcList.Count - 1 do 
    begin
      aMob := NpcList.Items(i);
      if (aMob.Target <> Nil) then Print(aMob.Target.Name);
      if (aMob.Target as TL2Live = vParam1) then sum := sum + 1;
      
    end;
    Result := sum;
  end;

function skillReuse(vName: String): Integer; Overload;
  var aSkill: TL2Skill;
  begin
    if SkillList.ByName(vName, aSkill) then Result := aSKill.EndTime
    else 
    begin
      Print('Could not find skill ' + vName + '.');
      Result := 0;
    end;
  end;

function buffCount(nick: String; arr: Array of String; time: Integer = 60000): Integer; Overload;
  begin
     Result := buffCount(GetControl(nick), arr, time);
  end;
function buffCount(nick: String; time: Integer = 60000): Integer; Overload;
  begin
    Result := buffCount(GetControl(nick),[], time);
  end;
function buffCount(time: Integer = 60000): Integer; Overload; 
  var aBuff: TL2Buff; i: Integer;
  begin
    Result := buffCount(Engine,[], time);
  end;
function buffCount(vControl: TL2Control; arr: Array of String; time: Integer = 60000): Integer; Overload; 
  var aBuff: TL2Buff; LBuffs: TBuffList; i: Integer; 
  begin
    Result := 0;
    LBuffs := vControl.GetUser.Buffs;
    for i := 0 to LBuffs.Count - 1 do
    begin
      aBuff := LBuffs.Items(i);
      if (aBuff.EndTime > time) and ((Length(arr) = 0) or is_in(aBuff.Name, arr))
      then
      begin
        Result := Result + 1;
      end;
    end;
  end;
function buffTime(vID: Integer): Integer; Overload;
  var aBuff: TL2Buff;
  begin
    if User.Buffs.ByID(vID, aBuff) then 
      Result := EndTime(aBuff as TL2Effect)
    else Result := 0;
  end;
function buffTime(vName: String): Integer; Overload;
  var aBuff: TL2Buff;
  begin
    if User.Buffs.ByName(vName, aBuff) then 
      Result := EndTime(aBuff as TL2Effect)
    else Result := 0;
  end;
function EndTime(a: TL2Effect): Integer;
  begin
    Result := a.EndTime;
  end;
end.