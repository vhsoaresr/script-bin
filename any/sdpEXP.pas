Unit sdpEXP;
Interface
function wait_level(vTo: Integer; doSoe: Boolean = True): Boolean;
procedure wait_loc_to_change(seconds: Integer = 60);
function level_in_between(a,b: Integer): Boolean;
function count(itemName: String): Integer;
Implementation
uses sdpSTRINGS;
function wait_level(vTo: Integer; doSoe: Boolean = True): Boolean; 
  begin
    // tbd: if no exp for 5 minutes or User.Dead -> Result := false; Engine.Unstuck;
    print('waiting for level ' + ToStr(vTo));
    if User.Level < vTo then
      Engine.FaceControl(0, True);
    while User.Level < vTo do delay(100);
    if (User.Level >= vTo) then Result := True;
    // tbd: kill mobs 
    Engine.FaceControl(0, False);
    if doSoe then Engine.Unstuck;
    print('stoped waiting');
  end;
procedure wait_loc_to_change(seconds: Integer = 60);
  var
  i,x,y,z: Integer;
  begin
   i := 0;
   x := User.X;
   y := User.Y;
   z := User.Z;
   while (User.X = x) and (User.Y = y) and (User.Z = z) and (i < seconds*10) do
   begin
     i := i + 1;
     delay(100);
   end;
  end;
function level_in_between(a,b: Integer): Boolean;
  begin
    Result := (User.Level >= a) and (User.Level <= b);
  end;
function count(itemName: String): Integer;
  var i: Integer;
  begin
    for i := 0 to Inventory.User.Count - 1 do 
    begin
      if(Inventory.User.Items(i).Name = itemName) then 
      begin
        Result := Inventory.User.Items(i).Count;
        break;
      end;
    end;

  end;
end.