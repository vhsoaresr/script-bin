const
  bypass_buff_sequence: array of String = ['-buffer', '-010'];
var
vPart: String;
procedure fSelOrBypass(temp: array of String; control: TL2Control; vDelay: Integer); begin
  for vPart in temp do begin
   if vPart[1] = '-' then 
   begin
     delete(vPart,1,1);
     if vPart <> '' then
        control.ByPassToServer(vPart);
     end else control.DlgSel(vPart);
      delay(vDelay);
  end; 
end;// fDlgSelStr()


procedure CheckNobless;
var
  buff: TL2Buff;
begin
  while Engine.Status = lsOnline do begin
    if ((not User.Buffs.ByID(1323, buff)) or (buff.EndTime < 120000)) then begin
        Engine.FaceControl(0, False);
        while not User.Dead and ((not User.Buffs.ByID(1323, buff)) or (buff.EndTime < 120000)) do
          fSelOrBypass(bypass_buff_sequence, Engine, 500);
        Engine.FaceControl(0, True);
    end;
    Delay(500);
  end;
end;
begin
  Script.NewThread(@CheckNobless);
end.
