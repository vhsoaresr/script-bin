Unit sdpBUFF;
Interface
function has_buff(aLive: TL2Live; vID: Integer): Boolean;
function buff_scheme(scheme_name: String): Boolean;
function buff_array(str_array: Array of String): Boolean;
Implementation
Uses serv_l2nanna;
function has_buff(aLive: TL2Live; vID: Integer): Boolean; 
  var aBuff: TL2Buff; i: Integer; 
  begin
    User.
  end;
function buff_scheme(scheme_name: String): Boolean; 
  var
    str_array: Array of String;
  begin
    case scheme_name of 
      'spoil': str_array := ['clarity','mdef','pdef','ww','bers','btb','vr','haste','dw','focus','might','gm','ren','smdef','spdef','sww','champ','sbtb','svr','shaste','sdw','sfocus','smight','cov'];
      'magnus': str_array := ['bts','sclarity','clarity','gs','pdef','spdef','sbtb','btb','conc','mental','sww','ww','bers','mdef','smdef','swm','wm','semp','emp','ren','sacumen','acumen','magnus'];
      else Print('Unknown scheme ' + scheme_name);
    end;
    buff_array(str_array);
  end;
function buff_array(str_array: Array of String): Boolean; 
  var
    i: Integer;
  begin
    if (not User.Dead) then begin
      for i := 0 to Length(str_array) - 1 do begin
        Print(str_array[i]);
        buff_one(str_array[i]);
        delay(delay_dialog);
      end;
      if (User.Noble) then begin
        Engine.SetTarget(User);
        Engine.UseSkill(1323);
      end;
    end 
    else Result := False;
  end;
end.