Unit sdpGPS2;
Interface
var 
  GPSPrint: Boolean = False;
  GPSPath: String = 'D:\Desktop\git\db\';
function GPS_Init(vPath: String = 'dbfile.db3'): Boolean;
function GPS_MoveTo(vName: String): Boolean; Overload;
function GPS_MoveTo(endX,endY,endZ: Integer): Boolean; Overload;
Implementation
Uses sdpSTRINGs, sdpBYPASS, sdpREGEX;

function GPS_Init(vPath: String = 'dbfile.db3'): Boolean;
  begin
    if GPSPrint then 
    begin 
      Print('GPSPath: String = ''' + GPSPath + ''';');
    end else Print('GPSPrint: Boolean = ' + ToStr(GPSPrint) + '; // Change this variable to see more info');
    Result := GPS_load(GPSPath + vPath);
  end;
function GPS_Load(vPath: String): Boolean; 
  begin
    Result := GPS.LoadBase(vPath) > -1;
    if GPSPrint then
    begin
      if Result then Print('GPS_Load(' + GPSPath + vPath + ') succeeded.')
      else Print('GPS_Load(' + GPSPath + vPath + ') failed.');
    end;
    
  end;
function GPS_RunThePath(): Boolean; 
  // Input:
    // You have to 'GPS_FindPath' before function call.
  var i: Integer;
  begin
    Result := True;
    for i := 0 to GPS.Count - 1 do 
    begin
      if not GPS_MoveToOnePoint(GPS.Items(i)) then 
      begin
        Result := False;
        Break;
      end;
    end;
  end;
function GPS_MoveToOnePoint(vGps: TGpsPoint): Boolean;
  var teleportText: String; aName: String; aX,aY,aZ: Integer;
  begin
    aX := ToInt(vGps.x);
    aY := ToInt(vGps.y);
    aZ := ToInt(vGps.z);
    aName := vGps.Name;
    if GPSPrint then Print('TGpsPoint(id=' + ToStr(vGps.ID) + ', x=' + ToStr(aX) + ', y=' + ToStr(aY) + ', z=' + ToStr(aZ) + ', name=''' + vGps.Name + ''')');
    if Copy(aName, 1, 4) = 'tlp:' then 
    begin
      if User.DistTo(aX, aY, aZ) > 2000 then 
      begin
        teleportText := Copy(aName, 5, 999); // 'tlp:asdasd asd' -> 'asdasd asd'
        if GPSPrint then Print('teleportText = ' + teleportText);
        if TalkTo(this_gk_id, ['Teleport', teleportText], 'obles') then Delay(3000);
      end else 
      begin
        if GPSPrint then 
          Print('Distance to point is <= 2000, will not teleport. Will run.')
      end;
    end;
    Engine.MoveTo(aX, aY, aZ);
    Result := User.DistTo(aX,aY,aZ) < 100;
    if not Result then
      Print('GPS_MoveToOnePoint failed on TGpsPoint(id=' + ToStr(vGps.ID) + ', x=' + ToStr(aX) + ', y=' + ToStr(aY) + ', z=' + ToStr(aZ) + ', name=''' + vGps.Name + ''')');
  end;

function GPS_MoveTo(vName: String): Boolean; Overload;
  begin
    if vName = '' then 
    begin
      Result := True;
      Exit;
    end;
    if User.Dead then 
    begin
      Print('User is dead. Terminating GPS_MoveTo');
      Result := False;
      Exit;
    end;
    if GPS_FindPath(vName) then
    begin
      Print('MovingTo: ' + vName);
      Result := GPS_RunThePath();
    end;
  end;
function GPS_MoveTo(endX,endY,endZ: Integer): Boolean; Overload;
  begin
    if User.Dead then 
    begin
      Print('User is dead. Terminating GPS_MoveTo');
      Result := False;
      Exit;
    end;
    if GPS_FindPath(endX,endY,endZ) then
    begin
      Print('MovingTo: Point(' + ToStr(endX) + ', ' + ToStr(endY) + ', ' + ToStr(endZ) + ')');
      Result := GPS_RunThePath();
    end;
  end;

function GPS_FindPath(vName: String): Boolean; Overload;
  begin
    Result := GPS_FindPath(vName, ToInt(User.X), ToInt(User.Y), ToInt(User.Z));
  end;
function GPS_FindPath(vName: String; x,y,z: Integer): Boolean; Overload;
  begin
    GPS.GetPathByName(x, y, z, vName);
    if GPS.Count > 0 then 
    begin
      Result := True;
    end else 
    begin 
      Print('GPS_FindPath could''t find path to ' + vName + ' from Point(' + ToStr(x) + ', ' + ToStr(y) + ', ' + ToStr(z) + ').');
      Result := False;
    end;
  end;
function GPS_FindPath(startX,startY,startZ: Integer): Boolean; Overload;
  begin
    Result := GPS_FindPath(startX,startY,startZ, ToInt(User.X), ToInt(User.Y), ToInt(User.Z));
  end;
function GPS_FindPath(startX,startY,startZ, endX,endY,endZ: Integer): Boolean; Overload;
  begin
    GPS.GetPath(endX, endY, endZ, startX, startY, startZ);
    if GPS.Count > 0 then 
    begin
      Result := True;
    end else 
    begin 
      Print('GPS_FindPath could''t find path to Point(' + ToStr(endX) + ', ' + ToStr(endY) + ', ' + ToStr(endZ) + ') from Point(' + ToStr(startX) + ', ' + ToStr(startY) + ', ' + ToStr(startZ) + ').');
      Result := False;
    end;
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
end.
