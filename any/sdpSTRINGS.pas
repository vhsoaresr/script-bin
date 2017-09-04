Unit sdpStrings;
interface
// strings
function ToStr(i: Double): String; Overload;
function ToStr(i: Boolean): String; Overload;
function ToStr(i: Single): String; Overload;
function ToStr(i: Integer): String; Overload;
function ToStr(str: String): String; Overload;

function ToInt(dbl: Double): Integer; Overload;
function ToInt(str: String): Integer; Overload;
// vectors
function is_in(a: Integer; arr: Array of Integer): Boolean; Overload;
function is_in(a: String; arr: Array of String): Boolean; Overload;
function overlap(arrA, arrB: Array of Integer): Boolean; Overload; 
function overlap(arrA, arrB: Array of String): Boolean; Overload; 
// math
function max(a: Integer; b: Integer): Integer;
function min(a,b: Integer): Integer;
function factorial(n, step: Integer = 1): Integer;
function distance(x0, y0, x, y: Double): Double;
function angle(x0, y0, x,y: Double; inverse_y: Boolean = False): Double;
function arcsin(x: Double; steps:Integer = 1000): Double;
// other
procedure cmd(command: String);
implementation
Uses SysUtils;
var i: Integer; str: String; // tbd: make variables local;
// Conversion
function ToStr(i: Double): String; Overload; 
  begin
    Result := FToStr(i);
  end;
function ToStr(i: Boolean): String; Overload; 
  begin
    if (i) then 
      Result := 'true'
    else 
      Result := 'false';
  end;
function ToStr(i: Single): String; Overload; 
  begin
    Result := ToStr(trunc(i));
  end;
function ToStr(str: String): String; Overload; 
  begin
    Result := str;
  end;
function ToStr(i: Integer): String; Overload; 
  begin
    str := FToStr(i);
    Result := Copy(str, 1, str.Length-3);
  end;

function ToInt(dbl: Double): Integer; Overload;
  begin
    Result := trunc(dbl);

  end;
function ToInt(str: String): Integer; Overload;
  begin
    try
      Result := StrToInt(str);    // 'G' is an invalid hexadecimal digit
    except
    on Exception : EConvertError do
    begin
    end;
    end;

  end;
// vectors
function is_in(a: Integer; arr: Array of Integer): Boolean; Overload;
  var part: Integer;
  begin
    Result := False;
    for part in arr do 
    begin 
      if part = a then 
  	begin 
  	  Result := True;
  	  Break;
  	end;
    end;
  end;
function is_in(a: String; arr: Array of String): Boolean; Overload;
  var part: String; i: Integer;

  begin
    Result := False;
    for i := 0 to Length(arr) - 1 do
    begin
      if a = arr[i] then 
        begin 
          Result := True;
          Break;
        end;
    end;
//    if Length(arr) > 0 then 
//      for part in arr do 
//      begin 
//        if part = a then 
//    	  begin 
//    	    Result := True;
//    	    Break;
//    	  end;
//      end;
  end;
function overlap(arrA, arrB: Array of Integer): Boolean; Overload; 
  var part: Integer;
  begin
    Result := False;
    for part in arrA do 
    begin
      if is_in(part, arrB) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
function overlap(arrA, arrB: Array of String): Boolean; Overload; 
  var part: String;
  begin
    Result := False;
    for part in arrA do 
    begin
      if is_in(part, arrB) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
// math
function max(a: Integer; b: Integer): Integer;
  begin
    if b > a then
      Result := b
    else 
      Result := a;
  end;
function min(a,b: Integer): Integer; 
  begin
    if b < a then
      Result := b
    else 
      Result := a;
  end;
function factorial(n, step: Integer = 1): Integer; 
  begin
    if (n <= step) then
      Result := 1
    else
      Result := n * factorial(n-step, step);
  end;
function distance(x0, y0, x, y: Double): Double;
  begin
    Result := sqrt(Power(x-x0, 2) + Power(y-y0, 2));

  end;
function angle(x0, y0, x,y: Double; inverse_y: Boolean = True): Double;
  var temp,length: Double;
  begin
    x := (x - x0);
    y := (y - y0);
    length := sqrt(Power(x,2) + Power(y, 2));
    x := x/length;
    y := y/length;

    if (inverse_y) then y := -y; // inverse so it is consistent with game coordinate system;
    //print('User(' + ToStr(0) + ',' + ToStr(0) + '); Target(' + ToStr(x) + ',' + ToStr(y) + ');');
    if(x = 0) and (y = 0) then temp := -1
    else
    begin
      temp := arcsin(abs(y));
      if (x < 0) and (y >= 0) then
        temp := pi - temp
      else if (x < 0) and (y < 0) then
        temp := pi + temp
      else if (x >=0) and (y < 0) then
        temp := 2*pi - temp;
    end;
    Result := temp;
  end;
function arcsin(x: Double; steps:Integer = 1000): Double;
  var n: Integer; point_at, width: Double;
  begin
    if (x > 1) or (x<-1) then 
    begin
      Print('arcsin x out of range!');
      Result := Null;
    end
    else 
    begin
      Result := 0;
      width := x/steps;
      point_at := width/2;
      while abs(point_at) < abs(x) do
      begin
        Result := Result + width*1/Power(1-Power(point_at,2),0.5);
        point_at := point_at + width;
      end;
    end;
  end;
function arccos(x: Double; steps:Integer = 1000): Double;
  var n: Integer; point_at, width: Double;
  begin
    if (x > 1) or (x<-1) then 
    begin
      Print('arccos x out of range!');
      Result := Null;
    end
    else 
    begin
      Result := 0;
      width := x/steps;
      point_at := width/2;
      while abs(point_at) < abs(x) do
      begin
        Result := Result + width*(-1)/Power(1-Power(point_at,2),0.5);
        point_at := point_at + width;
      end;
    end;
  end;
// other
procedure cmd(command: String);
  begin
    ShellExecuteW(0, 'open', PChar(command), nil, nil, 0);
  end;
function ShellExecuteW(hwnd: integer; lpOperation, lpFile, lpParameters, lpDirectory: PChar;  nShowCmd: integer): integer; stdcall; external 'Shell32.dll';
end.