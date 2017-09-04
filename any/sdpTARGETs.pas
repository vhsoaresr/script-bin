unit sdpTARGETs;
interface
function targetByTitle(patrn: String; maxDist: Integer = 500): Boolean;
function countMobTargetors(target: TL2Live; count_party, count_clan: Boolean = False): Integer; 
function countMobInZone(isDead: Boolean = False): Integer;
implementation
Uses sdpSTRINGS, sdpREGEX;
function targetByTitle(patrn: String; maxDist: Integer = 500): Boolean;
  var
    aNPC: TL2NPC;
       i: Integer;
  begin
    Result := False;
    for i := 0 to NpcList.Count - 1 do
    begin
      aNPC := NpcList.Items(i);
      if   str_detect(aNPC.Title, patrn)
       and not aNPC.Dead
       and (User.DistTo(aNPC) < maxDist)
       and (aNPC <> User.Target)
      then
      begin
        Engine.SetTarget(aNPC);
        Print(aNPC.Name + '[' + aNPC.Title + ']');
        Result := True;
        Break;
      end;
    end;
  end;
function countMobTargetors(target: TL2Live; count_party, count_clan: Boolean = False): Integer;
  var
    allMobList: TNpcList; i: Integer;
  begin
    Result := 0;
    allMobList := Engine.GetNPCList;
    for i := 0 to allMobList.Count - 1 do begin
      if (not allMobList.Items(i).IsMember or count_party) and ((allMobList.Items(i).ClanID <> Target.ClanID) or count_clan) then 
      if (allMobList.Items(i).Target = target) then Result := Result + 1;
    end;
  end;
function countMobInZone(isDead: Boolean = False): Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to NpcList.Count - 1 do 
    begin
      if NpcList.Items(i).InZone and NpcList.Items(i).Valid then 
      begin
        if (isDead and NpcList.Items(i).Dead and NpcList.Items(i).Sweepable) 
          or ((not isDead) and (not NpcList.Items(i).Dead))
        then 
          Result := Result + 1;
      end;
    end;
  end;
end.