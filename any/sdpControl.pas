Unit sdpControl;
Interface

Implementation
Uses sdpSTRINGs;
constructor TPoint.Create(x,y,z: Integer);
  begin
    Self.x := x;
    Self.y := y;
    Self.z := z;
  end;
class operator TPoint.Implicit(vSpawn: TL2Spawn): TPoint;
  begin
    Result.x := vSpawn.X;
    Result.y := vSpawn.Y;
    Result.z := vSpawn.Z;
  end;
class operator TPoint.Explicit(name: String): TPoint;
  var
    aUser: TL2User;
  begin
    aUser := GetControl(name).GetUser;
    print(aUser);
    Result.x := aUser.x;
    Result.y := aUser.y;
    Result.z := aUser.z;
  end;
procedure TPoint.Shift(x,y,z: Integer);
  begin
    Self.x := Self.x + x;
    Self.y := Self.y + y;
    Self.z := Self.z + z;
  end;
procedure TPoint.Print();
  begin
    Print(ToStr(Self.x) + ', ' + ToStr(Self.y) + ', ' + ToStr(Self.z));
  end;



end.