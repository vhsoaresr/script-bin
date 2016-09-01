// Change nick1, nick2 values to both tank names.
// Change BUFF_ID, TRIGGER_ID, SOS_ID for respective Pheonix Knight skills if it is used, otherwise do not change.
const
    nick1: String = 'sosas1'; // tank1 name
    nick2: String = 'sosas2'; // tank2 name
    SOS_ID = 789;      // Spirit of Shilen ID
    BUFF_ID = 788;     // Pain of Shilen ID
    TRIGGER_ID = 5564; // Pain of Shilen trigger ID

  
//
// Do not change anything after this point.
//
var
    sosSkill: TL2skill;
    sosBuff, buffBuff, triggerBuff: TL2buff;
    part: String;
    Control: TL2Control;
    vUser: TL2User;
    tempInt: Integer;
function min(x: Integer; y: Integer): Integer; begin
    if x<=y then Result := x
    else Result := y;
end;
function Charge(Control: TL2Control): Boolean; begin
    Result := false;
    while not Result do begin // while not 3lv BUFF_ID
        if (Control.GetPetList().Items(0) = nil) or Control.GetPetList().Items(0).Dead then
        begin
            Control.EnterText('#There is no summon to hit!');
            break;
        end else begin
            Control.GetUser.Buffs.ByID(BUFF_ID, buffBuff);
            Control.GetUser.Buffs.ByID(TRIGGER_ID, triggerBuff);
            if (triggerBuff.EndTime + buffBuff.EndTime = 0) then // jei nera nei 0lvl nei charginamo bufo dar uzmesto
            Control.UseSkill(BUFF_ID);
            Control.SetTarget(Control.GetPetList().Items(0)); // Target summon
            Control.Attack(2000, true); // AttackForce the summon
            Delay(100);
            Result := triggerBuff.level >= 3;
            if Result then begin // jei 3 lvl bufas, nustoti musti sumona
                vUser := Control.GetUser;
                Control.MoveTo(vUser.X, vUser.Y, vUser.Z);
            end;
        end;
    end;
end;
function doSOSNext(nick: String): Boolean; begin
    Control:= GetControl(nick);
    if Control = nil then Print('There is no such nick ' + nick)
    else begin
        while Control.GetSkillList.ByID(SOS_ID, sosSkill) and (sosSkill.EndTime > 30000) do delay(500);
        while Control.GetUser.Buffs.ByID(SOS_ID, sosBuff) and (sosBuff.EndTime > 25000) do delay(100); // wait SOS to be less than 25 seconds
        Control.UseSkill(BUFF_ID); // uses BUFF_ID in advance to save time.
        while Control.GetUser.Buffs.ByID(SOS_ID, sosBuff) and (sosBuff.EndTime > 20000) do delay(100); // waits SOS to be less than 20 seconds before starting
        Charge(Control); // Charge up BUFF_ID to 3lv
        if Control.GetSkillList.ByID(SOS_ID, sosSkill) and (sosSkill.EndTime > 20000) then begin // if sos wont reuse in 20 seconds, starts all over again.
        Control.Dispel(TRIGGer_ID);// remove 3lv buff
        Result := doSOSNext(nick);// start all over again (same char)
        end else begin
            while(sosSkill.EndTime>0) do delay(50); // Wait for sosSkill to reuse.
            while Control.GetUser.Buffs.ByID(TRIGGER_ID, triggerBuff) and Control.GetUser.Buffs.ByID(SOS_ID, sosBuff) and (min(sosBuff.EndTime, triggerBuff.EndTime) > 1000) do
                delay(50); 
            Control.UseSkill(SOS_ID); delay(1000);
        end;
    end;
end;

begin
    Control := GetControl(nick1);
    Control.GetSkillList.ByID(SOS_ID, sosSkill);
    tempInt := sosSkill.EndTime;
    Control := GetControl(nick2);
    Control.GetSkillList.ByID(SOS_ID, sosSkill);
    if sosSkill.EndTime < tempInt then begin // starts with tank2 if it's SOS reuse is shorter.
        doSOSNext(nick2); delay(500);
    end;
    while true do begin
        doSOSNext(nick1); 
        doSOSNext(nick2); 
    end;
end.
