Unit sdpGPS;
interface
function GPS_MoveTo(name: String; vHunt, vLoadZone: Boolean = False): Integer; Overload;
function GPS_MoveTo(x, y, z: Integer; vHunt: Boolean = False): Integer; Overload;
function GPS_Hunt(vZone: String; vStealth: Boolean = True): Boolean;
procedure GPS_Export(x,y,z: Integer; asScript: Boolean = False); Overload;
procedure GPS_Export(vName: String; asScript: Boolean = False); Overload;
procedure GPS_Export(vName: String; startx, starty, startz: Integer; asScript: Boolean = False); Overload;
implementation
uses SDPStrings, sdpBYPASS, sdpREGEX, sdpCounter;
const 
  vPrint = False;
  vPos = False;
  vPrintPos = False;
var 
  i,j,index,gk_id: Integer; 
  str: String; 
  lastPoint: TGpsPoint;
  aNPC: TL2NPC; // tbd: make variables local.
function GPS_RunThePath(dist: Single): Integer; 
  var next_step_town: String;
  begin
    Result := 0;
    if (GPS.count > 0) then begin
      if vPrint then Print('Steps to be taken: GPS.Count=' + ToStr(GPS.Count));
      for i:= 0 to GPS.Count-1 do begin
        if vPrint then begin
          str := ToStr(GPS.Items(i).ID) + ' ' + GPS.Items(i).Name;
          if vPrintPos then 
            str := str + '@(' + ToStr(GPS.Items(i).x) + ', ' + ToStr(GPS.Items(i).y) + ', ' + ToStr(GPS.Items(i).z) + ')';
          Print(str);
         end;
        case Copy(GPS.Items(i).Name, 1, 4) of 
        'tlp:': begin
          next_step_town := extractTown(GPS.Items(i).Name); // extract name point name <npc:Town npcname>
          if (User.DistTo(Trunc(GPS.Items(i).x), Trunc(GPS.Items(i).y), Trunc(GPS.Items(i).z)) > 2000) then 
            begin
            if TalkTo(this_gk_id, ['1', next_step_town], 'oblesse') then 
              Delay(7000);
            end else 
            begin
              if (not Engine.MoveTo(Trunc(GPS.Items(i).x), Trunc(GPS.Items(i).y), Trunc(GPS.Items(i).z))) then 
                begin 
                  print('[GPS] Error while moving to point ID=' + ToStr(GPS.Items(i).ID));
                  Result:= 1;
                  exit;
                end;
            end;
          end;
        'ccc:': begin
          gk_id := this_gk_id();
          if NPCExists(gk_id) then begin
            Engine.SetTarget(gk_id);
            for j := 0 to 50 do begin // tbd: make function wait_target in some unit already you fuck.
              if User.Target.ID = gk_id then break
              else delay(100);
            end;
            Delay(500);
            Engine.DlgOpen; // tbd: array bypass funkcija
            Engine.DlgSel('Teleport'); Delay(1000);
            Delay(2000);
          end else Print('NPC of ID ' + ToStr(j) + ' was not found.');
          end;
        'flo:': begin
          gk_id := this_gk_id();
          if NPCExists(gk_id) then 
          begin
            Engine.SetTarget(gk_id);
            for j := 0 to 50 do begin // tbd: make function wait_target in some unit already.
              if User.Target.ID = gk_id then break
              else delay(100);
            end;
            Engine.DlgOpen; // tbd: array bypass funkcija
            Engine.DlgSel('Floor'); Delay(1000);
            Engine.DlgSel(extractTown(GPS.Items(i).Name)); 
            Delay(3000);
          end else Print('NPC of ID ' + ToStr(j) + ' was not found.');
          end;
        else begin
          if (not Engine.MoveTo(Trunc(GPS.Items(i).x), Trunc(GPS.Items(i).y), Trunc(GPS.Items(i).z))) then 
          begin 
            print('[GPS] Error while moving to point ID=' + ToStr(GPS.Items(i).ID));
            Result:= 1;
            exit;
          end;
         end;
        end; // end of case.
      end; // end of <for i>
    end else 
    begin
      Print('[GPS] Could not find route');
      Result := 2;
    end;
  end;
function GPS_MoveTo(name: String; vHunt, vLoadZone: Boolean = False): Integer; 
  begin
    if (name <> '') then
    begin
      Print('MovingTo "' + name + '"');
      if User.Dead then 
        Result := 3
      else 
        Result := GPS_RunThePath(GPS.GetPathByName(User.x, User.y, User.z, name));

      if (Result = 0) then 
      begin
        if vLoadZone then
        begin
          Engine.LoadZone(Copy(name,5,999));
          Print('Loading zone: ' + Copy(name,5,999));
        end;
        if vHunt then Engine.FaceControl(0, True);
      end;
      if (Result = 1) then 
      begin
        if (GPS_MoveTo(name, False, False) = 1) then Result := 2;
      end;
      if (Result = 2) then Print('Final Note: Could not find the path.');
    end else Result := 0;
  end;
function GPS_MoveTo(x, y, z: Integer; vHunt: Boolean = False): Integer; 
  begin
    if User.Dead then 
    begin 
      Result := 3;
      Print('User is Dead. no go amigo.');
      
    end
    else 
    begin

    Result := GPS_RunThePath(GPS.GetPath(User.x, User.y, User.z, x, y, z));
    if (Result = 0) and vHunt then 
        Engine.FaceControl(0, True);
    if (Result = 1) then 
      Result := GPS_MoveTo(x,y,z, False);
    if (Result = 2) then Print('Final Note: Could not find the path.');
    end;
  end;
function GPS_Hunt(vZone: String; vStealth: Boolean = True): Boolean;
  begin
    if vZone <> '' then 
    begin
      if vStealth then Engine.LoadConfig('stealth'); Engine.FaceControl(0, True);
      GPS_MoveTo('hnt:' + str_extract(vZone, '(.*)\.', '$1'));
      Engine.LoadZone(vZone);
      if vStealth then
      begin // wait out stealth withouth attacking.
        Engine.FaceControl(0, False);
        Engine.LoadConfig(User.Name);
        Engine.FaceControl(1, False);
        Engine.FaceControl(0, True);
        while buffTime('stealth') > 0 do delay(1000);
      end;
      Engine.FaceControl(0, True);
      Engine.FaceControl(1, True);
    end;
  end;

procedure GPS_Export(x,y,z: Integer; asScript: Boolean = False); Overload;
  begin
    GPS.GetPath(User.x, User.y, User.z, x,y,z);
    Export(asScript);
  end;
procedure GPS_Export(vName: String; asScript: Boolean = False); Overload;
  begin
    GPS_Export(vName, User.x, User.y, User.z, asScript);
  end;
procedure GPS_Export(vName: String; startx, starty, startz: Integer; asScript: Boolean = False); Overload;
  begin
    GPS.GetPathByName(startx, starty, startz, vName);
    Export(asScript);
  end;
procedure Export(asScript: Boolean);
  begin
    str := '';
    for i:= 0 to GPS.Count-1 do
    begin
      if asScript then 
      begin
        str := str + 'Engine.MoveTo(' + ToStr(GPS.Items(i).X) + ', ' + ToStr(GPS.Items(i).Y) + ', ' + ToStr(GPS.Items(i).Z) + ');';
        if GPS.Items(i).Name <> '' then 
          str := str + ' // ' + GPS.Items(i).Name;
        str := str + AnsiString(#13#10);
      end
      else
        str := str + ToStr(GPS.Items(i).X) + ', ' + ToStr(GPS.Items(i).Y) + ', ' + ToStr(GPS.Items(i).Z) + ', ' + GPS.Items(i).Name + AnsiString(#13#10);
    end;
    print(str);
    end;
function town_of_gk(vID: Integer): String;
  begin
    case vID of
      31320: Result := 'Rune';
      else Result := '';
    end;
  end;
function this_gk_name: String; 
  begin
   // tbd: finish up
    Result := '';
    if User.InRange(147963, -55282,-2759, 250, 500) then Result := 'Goddard';
    if User.InRange( 83344, 147932,-3431, 500, 500) then Result := 'Giran';
    if User.InRange( 43820, -47690, -823, 250, 500) then Result := 'Rune';
    if User.InRange(146709,  25759,-2039, 250, 500) then Result := 'Aden';
    if User.InRange( 82970,  53174,-1490, 500, 500) then Result := 'Valentina';
    if User.InRange(-12752, 122772,-3143, 500, 500) then Result := 'gludio';
    if User.InRange( 15643, 142931,-2704, 500, 500) then Result := 'dion';
    if User.InRange(111412, 219382,-3540, 500, 500) then Result := 'Flauen';
    if User.InRange(-84143, 244591,-3755, 500, 500) then Result := 'island';
    if User.InRange(-80782, 149800,-3070, 500, 500) then Result := 'gludin';
    if User.InRange(117107,  76911,-2722, 500, 500) then Result := 'hunter';
    if User.InRange( 87138,-143415,-1319, 250, 250) then Result := 'shutgart';
    if User.InRange( 46924,  51485,-3003, 500, 500) then Result := 'elf';
    if User.InRange(115093,-178177, -916, 300, 500) then Result := 'dwarf';
    if User.InRange(  9695,  15556,-4601, 300, 500) then Result := 'delf';
    if User.InRange(-45228,-112507, -265, 300, 500) then Result := 'orc';
    
  end;
function this_gk_id: Integer; 
  begin
    Result := -99;
    if User.InRange(147963, -55282,-2759, 450, 500) then Result := 31275; // Goddard
    if User.InRange( 83344, 147932,-3431, 500, 500) then Result := 30080; // -Giran
    if User.InRange( 43820, -47690, -823, 250, 500) then Result := 31320; // rune main gk
    if User.InRange(146709,  25759,-2039, 250, 500) then Result := 30848; // -Aden
    if User.InRange( 82970,  53174,-1490, 500, 500) then Result := 30177; // -Oren
    if User.InRange(-12752, 122772,-3143, 500, 500) then Result := 30256; // -Gludio
    if User.InRange( 15643, 142931,-2704, 500, 500) then Result := 30059; // -Dion
    if User.InRange(111412, 219382,-3540, 500, 500) then Result := 30899; // -Heine
    if User.InRange(-84143, 244591,-3755, 500, 500) then Result := 30006; // Talking Island
    if User.InRange(-80782, 149800,-3070, 500, 500) then Result := 30320; // -Gludin
    if User.InRange(117107,  76911,-2722, 500, 500) then Result := 30233; // Hunter
    if User.InRange( 87138,-143415,-1319, 250, 250) then Result := 31964; // -Schutgart
    if User.InRange( 46924,  51485,-3003, 500, 500) then Result := 30146; // Elven Village
    if User.InRange(115093,-178177, -916, 300, 500) then Result := 30540; // Dwarf
    if User.InRange(  9695,  15556,-4601, 300, 500) then Result := 30134; // Dark
    if User.InRange(-45228,-112507, -265, 300, 500) then Result := 30576; // Orc
    if User.InRange(105888, 109808,-3216, 300, 500) then Result := 30836;
    if User.InRange(38370, -48097, -1152, 400, 300) then Result := 31699;
    if User.InRange( 38307, -48020,  896, 400, 300) then Result := 31698;
    if User.InRange( 47966, 186754,-3480, 500, 500) then Result := 30878; // Giran Harbour
    if User.InRange( 84814, 15886, -4291, 300, 200) then Result := 30162; // Ivory tover undergound
    if User.InRange( 85336, 16194, -3672, 300, 200) then Result := 30727; // Ivery tower loby
    if User.InRange( 85333, 16178, -2800, 300, 200) then Result := 30716; // Ivory tower 2nd (Human)
    if User.InRange( 85336, 16194, -1768, 300, 200) then Result := 30719; // Ivory tower 3rd (Elf)
    if User.InRange( 85364, 16164, -2288, 300, 200) then Result := 30722; // Ivory tower 4th (Dark Elf)
    if User.InRange( 77284, 78410, -5151, 300, 200) then Result := 31116; // Apostate cc [out]
    if User.InRange(139983, 79680, -5455, 300, 200) then Result := 31117; // Witch cc [out]
    if User.InRange(140778, 79694, -5453, 300, 200) then Result := 31123; // Witch cc [in]

    if (Result < 0) then 
      Print('You should check out this_gk_id function. ID is negative. Value = ' + ToStr(Result));
  end;
function this_town_name: String;
  begin
    Result := town_of_gk(this_gk_id);
  end;
function NPCExists(vID: Integer): Boolean; 
  begin // tbd: probably move to other unit
    NPCList.ByID(vID, aNPC);
    Result := aNPC <> Nil;
  end;
function extractTown(name: String; sep: String = ' '): String; 
  begin
    // extracts Town from name atribute of GPS database point table's object.
    // name syntax: asd:TownName NpcName
    for index := 5 to name.Length do 
      if (Copy(name, index, 1) = sep) then break;
    Result := Copy(name, 5, 999);
    if vPrint then Print('extractTown = ' + Result);
  end;
end.