// if last in text already - try that
// change vdelay to waittochange + vdelay
Unit sdpBYPASS;
Interface
function Dlg(arr: Array of String; exclude: String = '$a^'; vDelay: Integer = 1000): Boolean;
function CB(arr: Array of String; exclude: String = '$a^'; vDelay: Integer = 1000): Boolean;
function GPSTalkTo(vName: String; arr: Array of String; exclude: String = '$a^'; vDelay: Integer = 1000): Boolean; Overload;
function TalkTo(vID: Integer; arr: Array of String; exclude: String = '$a^'; vDelay: Integer = 1000): Boolean; Overload;
function TalkTo(vName: String; arr: Array of String; exclude: String = '$a^'; vDelay: Integer = 1000): Boolean; Overload;
procedure PrintAllTags(source: String = 'DlgText');
Implementation
uses SysUtils, Classes, RegExpr, sdpSTRINGS, sdpREGEX, sdpGPS;
function Dlg(arr: Array of String; exclude: String = '$a^'; vDelay: Integer = 1000): Boolean;
  begin
    Result := Bypass('DlgText', arr, exclude, vDelay);
  end;
function CB(arr: Array of String; exclude: String = '$a^'; vDelay: Integer = 1000): Boolean;
  begin
    Result := True;
    //if str_detect(Engine.CBText, arr[Length(arr)-1]) then // if possible to click right away
    //  Print(Bypass(Engine.CBText, arr[Length(arr)-1], exclude, True))
    //else 
    Result := Bypass('CBText', arr, exclude, vDelay);
  end;
function bypass(source: string; arr: Array of String; exclude: String; vDelay: Integer): boolean; Overload;
  var 
    part, htmlText, tempStr, fullStr: String;
  begin
    Result := True;
    for part in arr do 
    begin
      case source of
        'DlgText': htmlText := Engine.DlgText;
        'CBText': 
        begin
          if (part = arr[0]) and (arr[0] <> '_bbshome') then
          begin
            Engine.ByPassToServer('_bbshome');
            fullStr := 'Engine.ByPassToServer(''_bbshome'');' + AnsiString(#13#10);
            Delay(vDelay);
          end;
          htmlText := Engine.CBText;
        end;
        else 
        begin
          htmlText := source;
          Print('Unknown source "' + source + '". It better be valid html.');
        end;
      end;
      if str_detect(part, '^\d*$') then // if digit
      begin
        tempStr := Bypass(htmlText, ToInt(part));
      end
      else
      begin
        tempStr := Bypass(htmlText, part, exclude);
        if (tempStr = '') then // if could not find anything to click
        begin
          Print('Could not find anything with ' + part);
          // if (vByPassBlindlyIfNotFound) then Engine.ByPassToServer(part);
          Result := False;
        end;
      end;
      //fullStr := fullStr + tempStr + ' // ' + part + AnsiString(#13#10);
      Delay(vDelay)
    end;
    //Print(fullStr);
  end;
function bypass(htmlText: string; dlg: string; exclude: String; clickIfOnlyOneAvailable: Boolean = True): String; Overload;
  var
    SL: TStringList;
    i: integer;
    bps: string;
    text: string;
  begin
    Result:= '';

    SL := str_extract_all(htmlText, '(<a *(.+?)</a>)|(<button *(.+?)>)', '$0');
    for i := 0 to SL.Count-1 do begin
      if str_detect(SL[i], dlg) and not str_detect(SL[i], exclude)
       or ((SL.Count = 1) and clickIfOnlyOneAvailable) then begin
        text := SL[i];
        //text := '<a action="bypass )0"> Necromancer</a>';
        //text := '<button action="bypass -h )0" value="Англ./English" width=120 height=20 back="Ketrawars.a1b" fore="Ketrawars.a1">';
        //text := '<button value="Mage set" action="bypass -h )0" width=120 height=20 back="Ketrawars.a1b" fore="Ketrawars.a1">';
        //text := '<button value="" action="bypass  )1" width=34 height=23 back="Crest.crest_31_79515408" fore="Crest.crest_31_138348129">';
        //text := '<button value="" action="bypass  )1" width=34 height=23 back="Crest.crest_31_155287654" fore="Crest.crest_31_193920412">';
        bps := TrimLeft(str_extract(text, '"(bypass -h|bypass) (.*)"', '$2'));
      end;
    end;
    if (Length(bps) > 0) then 
    begin 
      Engine.BypassToServer(bps);
      Result := 'Engine.ByPassToServer(''' + bps + ''');';
    end;
    SL.Free;
  end;
function bypass(htmlText: string; dlg: Integer): String; Overload;
  var
    SL: TStringList;
    bps: string;
  begin
    Result := '';

    SL := str_extract_all(htmlText, '(<a *(.+?)</a>)|(<button *(.+?)>)');
    if not (SL = nil) and (SL.Count > dlg) then 
    begin
      bps := str_extract(SL[dlg-1], '"(bypass -h|bypass) (.*)"', '$2');
      if (Length(bps) > 0) then 
      begin 
        Engine.BypassToServer(bps);
        Result := 'Engine.ByPassToServer(''' + bps + ''');';
      end;
    end;
    SL.Free;
  end;
function GPSTalkTo(vName: String; arr: Array of String; exclude: String = '$a^'; vDelay: Integer = 1000): Boolean; Overload;
  begin
    Result := False;
    if start_dlg(vName, vDelay) then 
    begin
      if (User.DistTo(User.Target) > 350) then GPS_MoveTo(User.Target.X, User.Target.Y, User.Target.Z);
      bypass('DlgText', arr, exclude, vDelay);
      Result := True;
    end;
  end;
function TalkTo(vID: Integer; arr: Array of String; exclude: String = '$a^'; vDelay: Integer = 1000): Boolean; Overload;
  begin
    Result := False;
    if start_dlg(vID, vDelay) then
    begin
      bypass('DlgText', arr, exclude, vDelay);
      Result := True;
    end;
  end;
function TalkTo(vName: String; arr: Array of String; exclude: String = '$a^'; vDelay: Integer = 1000): Boolean; Overload;
  begin
    Result := False;
    if start_dlg(vName, vDelay) then 
    begin
      bypass('DlgText', arr, exclude, vDelay);
      Result := True;
    end;
  end;
function start_dlg(vName: String; vDelay: Integer = 1000): boolean; Overload;
  var j: Integer;
  begin
    Result := False;
    if npc_exists(vName) then 
    begin
      Engine.SetTarget(vName);
      for j := 0 to 5*(vDelay/10) do begin
        if User.Target.Name = vName then 
        begin
          Engine.MoveTo(User.Target, -45);
          Engine.DlgOpen;
          Delay(vDelay);
          Result := True;
          break;
        end else delay(100);
      end;
    end 
    else
      Print('NPC of name ' + vName + ' was not found.');
  end;
function start_dlg(vID: Integer; vDelay: Integer = 1000): boolean; Overload;
  var j: Integer;
  begin
    Result := False;
    if npc_exists(vID) then 
    begin
      Engine.SetTarget(vID);
      for j := 0 to 5*(vDelay/10) do begin
        if User.Target.ID = vID then 
        begin
          Engine.MoveTo(User.Target, -45);
          Engine.DlgOpen;
          Delay(vDelay);
          Result := True;
          break;
        end else delay(100);
      end;
    end 
    else 
      Print('NPC of ID ' + ToStr(vID) + ' was not found.');
  end;

procedure PrintAllTags(source: String = 'DlgText');
  var RegExp: TRegExpr; 
  begin  
    case source of 
      'CBText': source := Engine.CBText;
      'DlgText':source := Engine.DlgText;
      else Print('Unknown source "' + source + '". It better be valid html.');
    end;
    RegExp:= TRegExpr.Create;
    RegExp.Expression:= '(<a *(.+?)</a>)|(<button *(.+?)>)';   
    if RegExp.Exec(source) then 
      repeat Print(RegExp.Match[0]);
      until (not RegExp.ExecNext);  
    RegExp.Free;
  end;

function npc_exists(vName: String): Boolean; Overload;
  var aNPC: TL2NPC;
  begin // tbd: probably move to other unit
    NPCList.ByName(vName, aNPC);
    Result := aNPC <> Nil;
  end;
function npc_exists(vID: Integer): Boolean; Overload;
  var aNPC: TL2NPC;
  begin // tbd: probably move to other unit
    NPCList.ByID(vID, aNPC);
    Result := aNPC <> Nil;
  end;
end.
