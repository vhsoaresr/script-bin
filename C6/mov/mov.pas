uses SysUtils;
// tbDeleted
// needs to be tested: port_to_town; 
//  1-TI,2-Elven,3-Dwarven,4-D.Elf,5-Orc,6-Gludin,
//  7-Gludio,8-Dion,9-Heine,10-Giran,11-Oren,
//  12-Hunter,13-Aden,14-Rune,15-Goddard,16-Shutgart
//  17-Floran.

var
mov_int1: Integer; // variable for temporary use.
mov_int2: Integer; // variable for temporary use.
mov_str1: String;  // variable for temporary use.
vPart: String;     // variable for temporary use in loops.
temp_arr: array of String; // variable for temporary use.
// # PUBLIC
// get_to
// Return value: 
// get to gets to town specified by `where` variable.
// if `where` ommited -- gets to curent town's gatekeeper.
// if array `teleport` specified talks to that town's gatekeeper with dialog secuence `teleport`.
// uses functions:
// at_gk(int)
function get_to(where: String; arr: array of String): String; Overload; begin
  mov_int1 := gk_id(get_to(where));
  talk_to_gk(mov_int1, arr);
end;
function get_to(where: String = ''): String; Overload; begin
  // '': runs to gk
  // `town`: gets to specific town gatekeeper
  where := string_to_town(where);
  fRunToGk();
  if where <> '' then begin
    port_to_town(where);
  end;
  Result := identify_gk;
end;

// # PRIVATE
// helper functions
function string_to_town(str: String; vPrint: Boolean = True): String; begin
  // corects cammon spelling mistakes in town names.
    if ((str = 'human') or (str = 'elf') or (str = 'dwarf') or (str = 'delf') or (str = 'orc') or (str = 'gludin') or (str = 'gludio') or (str = 'dion') or (str = 'heine') or (str = 'giran') or (str = 'oren') or (str = 'hunter') or (str = 'aden') or (str = 'rune') or (str = 'goddard') or (str = 'shutgart') or (str = 'floran'))
    then Result := str
    else begin
      Result := '';
      if vPrint then Print('WARNING: string_to_town(str: String = "'+ str +'); -- parameter value not supported.');
    end;
end;
function gk_id(vPrint: Boolean = True): Integer; Overload; begin
  Result := gk_id(identify_gk());
end;
function gk_id(str: String; vPrint: Boolean = True): Integer; Overload; begin
  case str of
    'human'   : Result := 30006;
    'elf'     : Result := 30146;
    'dwarf'   : Result := 30540;
    'delf'    : Result := 30134;
    'orc'     : Result := 30576;
    'gludin'  : Result := 30320;
    'gludio'  : Result := 30256;
    'dion'    : Result := 30059;
    'heine'   : Result := 30899;
    'giran'   : Result := 30080;
    'oren'    : Result := 30177;
    'hunter'  : Result := 30233;
    'aden'    : Result := 30848;
    'rune'    : Result := 31320;
    'goddard' : Result := 31275;
    'shutgart': Result := 31964;
    else if vPrint then Print('WARNING: gk_id(str: String = "'+ str +'); -- parameter value not supported.');
	end;
end;
function identify_gk(): String; begin
	Result := '';
  // shitty ordering for performance improvement
	if User.InRange(147963, -55282, -2759, 250, 500) then Result := 'goddard';
  if User.InRange(83344, 147932, -3431, 500, 500)  then Result := 'giran';
  if User.InRange(43820, -47690, -823, 250, 500)   then Result := 'rune';
  if User.InRange(146709, 25759, -2039, 250, 500)  then Result := 'aden';
  if User.InRange(82970, 53174, -1490, 500, 500)   then Result := 'oren';
  if User.InRange(-12752, 122772, -3143, 500, 500) then Result := 'gludio';
  if User.InRange(15643, 142931, -2704, 500, 500)  then Result := 'dion';
  if User.InRange(111412, 219382, -3540, 500, 500) then Result := 'heine';
  if User.InRange(-84143, 244591, -3755, 500, 500) then Result := 'human';
  if User.InRange(-80782, 149800, -3070, 500, 500) then Result := 'gludin';
  if User.InRange(117107, 76911, -2722, 500, 500)  then Result := 'hunter';
  if User.InRange(87138, -143415, -1319, 250, 250) then Result := 'shutgat';
  if User.InRange(46924, 51485, -3003, 500, 500)   then Result := 'elf';
	if User.InRange(115093, -178177, -916, 300, 500) then Result := 'dwarf';
	if User.InRange(9695, 15556, -4601, 300, 500)    then Result := 'delf';
	if User.InRange(-45228, -112507, -265, 300, 500) then Result := 'orc';
end;
function talk_to_gk(town: String; arr: array of String; vPrint: Boolean = True): String; Overload; begin
  talk_to_gk(gk_id(town), arr, 700, vPrint);
end;
function talk_to_gk(vID: Integer; arr: array of String; vDelay: Integer = 700; vPrint: Boolean = True): String; Overload; begin // tbd
  mov_int1 := 0;
  while (User.Target.ID <> vID) and ( mov_int1 < 60 ) do
  begin
    Engine.SetTarget(vID);
    mov_int1 := mov_int1 + 1;
    Delay(500);
  end;
  if(User.Target.ID = vID)then
  begin
    if User.DistTo(User.Target) > 100 then Engine.MoveToTarget(-50);
    Engine.DlgOpen; Delay(vDelay);
    for vPart in arr do begin
      if vPart[1] = '-' then begin
        delete(vPart,1,1);
        Engine.ByPassToServer(vPart);
      end else Engine.DlgSel(vPart);
      delay(vDelay);
    end;
  end;
  Result := identify_gk;
end;

function port_to_town(vTo: String): String; 
var vFrom: String;
begin
  vFrom := identify_gk();
  vTo := string_to_town(vTo);
  if((vFrom <> vTo) and (vTo <> '')) then 
  begin
    temp_arr := ['Teleport',vTo];
    if (talk_to_gk(vFrom, temp_arr) <> '') then
		begin
			if(vFrom = 'human') and 
         ((vTo = 'gludio') or (vTo = 'dion' ) or (vTo = 'heine') or (vTo = 'giran') or (vTo = 'oren' 
        ) or (vTo = 'hunter') or (vTo = 'aden') or (vTo = 'rune') or (vTo = 'goddard') or (vTo = 'shutkart')) 
        then vFrom := port_to_town('gludin');
			if((vFrom = 'elf') or (vFrom = 'dwarf') or (vFrom = 'delf') or (vFrom = 'orc') or (vFrom = 'gludin')) and 
          ((vTo = 'gludin') or (vTo = 'gludio') or (vTo = 'dion') or (vTo = 'heine') or (vTo = 'giran') or (vTo = 'oren') or (vTo = 'hunter') or (vTo = 'aden') or (vTo = 'rune') or (vTo = 'goddard') or (vTo = 'shutgart')) 
        then vFrom := port_to_town('Gludio');
			if(vFrom = 'elf') and (vTo = 'delf') then vFrom := port_to_town('gludio');
        if(vFrom = 'delf') and (vTo = 'elf') then vFrom := port_to_town('gludio');
			if(vFrom = 'gludio') and (vTo = 'human') then vFrom := port_to_town('gludin');
			if(vFrom = 'hunter') and (vTo <> 'oren') and (vTo <> 'aden') then vFrom := port_to_town('oren');
			if((vTo = 'hunter') and (vFrom <> 'oren') and (vFrom <> 'aden')) then vFrom := port_to_town('oren');
			if((vFrom = 'dion') or (vFrom = 'heine') or (vFrom = 'giran') or (vFrom = 'oren') or (vFrom = 'hunter') or (vFrom = 'aden') or (vFrom = 'rune') or (vFrom = 'goddard') or (vFrom = 'shutgart'))  and (vFrom <> 'hunter') and 
          ((vTo = 'human') or (vTo = 'elf') or (vTo = 'delf') or (vTo = 'dwarf') or (vTo = 'orc') or (vTo = 'gludin'))
      then vFrom := port_to_town('gludio');
		end 
    else begin
			if (talk_to_gk(vFrom, ['teleport', vTo]) <> '') then 
        vFrom := vTo;
		end;
      vFrom := port_to_town(vTo);
    end;
	Result := vTo;
	if(vFrom = '') then 
  begin 
    Print('Critical error durring teleport. vTo = 0');
		Result := identify_gk;
	end;
end;

// 
procedure mov_unstuck(vPrint: Boolean = True); begin
   // Goes to town using appropriate method.
  // tbd: if there is soe in inventory use it instead of unstuck.
  // tbd: instead of 18000 delay after unstuck, delay it while casting.
  if User.Dead then begin
    Engine.GoHome();
    Print('User.Dead = true, going to vilage.');
  end else
  begin
    //control.Unstuck;
    //control.UseKey(191);
    //control.UseKey('u');
    //control.UseKey('n');
    //control.UseKey('s');
    //control.UseKey('t');
    //control.UseKey('u');
    //control.UseKey('c');
    //control.UseKey('k');
    //delay(10);
    //control.UseKey(13);
    Engine.UseSKill(2099);
    Delay(23000);
  end;
  Delay(3000);

end;
function fRunToGK(): String; begin
begin // savartynas
//Aden:
if User.InRange(146811,27109,-2231,500)  then
begin
 Engine.MoveTo(146811,27109,-2231);
 Engine.MoveTo(147289,26926,-2229);
 Engine.MoveTo(147267,26400,-2185);
 Engine.MoveTo(147266,26195,-2103);
 Engine.MoveTo(147250,25969,-2039);
 Engine.MoveTo(147206,25899,-2039);
 Engine.MoveTo(147138,25906,-2039);
end;
if User.InRange(146810,28059,-2294,500)  then
begin
 Engine.MoveTo(146810,28059,-2294);
 Engine.MoveTo(146847,27874,-2294);
 Engine.MoveTo(147004,27611,-2294);
 Engine.MoveTo(147004,27611,-2294);
 Engine.MoveTo(147004,27611,-2232);
 Engine.MoveTo(147244,26822,-2230);
 Engine.MoveTo(147267,26400,-2185);
 Engine.MoveTo(147266,26195,-2103);
 Engine.MoveTo(147250,25969,-2039);
 Engine.MoveTo(147206,25899,-2039);
 Engine.MoveTo(147138,25906,-2039);
end;
if User.InRange(145686,21112,-2167,500)  then
begin
 Engine.MoveTo(145686,21112,-2167);
 Engine.MoveTo(145697,21616,-2167);
 Engine.MoveTo(145050,22609,-2167);
 Engine.MoveTo(145218,23947,-2167);
 Engine.MoveTo(146377,24455,-2039);
 Engine.MoveTo(146484,25685,-2039);
 Engine.MoveTo(147130,25700,-2039);
 Engine.MoveTo(147112,25921,-2039);
end;
if User.InRange(148076,27069,-2231,500)  then
begin
 Engine.MoveTo(148076,27069,-2231);
 Engine.MoveTo(147666,27110,-2230);
 Engine.MoveTo(147308,26954,-2230);
 Engine.MoveTo(147267,26400,-2185);
 Engine.MoveTo(147266,26195,-2103);
 Engine.MoveTo(147250,25969,-2039);
 Engine.MoveTo(147206,25899,-2039);
 Engine.MoveTo(147138,25906,-2039);
end;
if User.InRange(148949,21125,-2167,500)  then
begin
 Engine.MoveTo(148949,21125,-2167);
 Engine.MoveTo(146122,21227,-2167);
 Engine.MoveTo(145697,21616,-2167);
 Engine.MoveTo(145050,22609,-2167);
 Engine.MoveTo(145218,23947,-2167);
 Engine.MoveTo(146377,24455,-2039);
 Engine.MoveTo(146484,25685,-2039);
 Engine.MoveTo(147130,25700,-2039);
 Engine.MoveTo(147112,25921,-2039);
end;
if User.InRange(144549,22828,-2167,500)  then
begin
 Engine.MoveTo(144549,22828,-2167);
 Engine.MoveTo(145697,21616,-2167);
 Engine.MoveTo(145050,22609,-2167);
 Engine.MoveTo(145218,23947,-2167);
 Engine.MoveTo(146377,24455,-2039);
 Engine.MoveTo(146484,25685,-2039);
 Engine.MoveTo(147130,25700,-2039);
 Engine.MoveTo(147112,25921,-2039);
end;
if User.InRange(144543,24666,-2167,500)  then
begin
 Engine.MoveTo(144543,24666,-2167);
 Engine.MoveTo(145279,24307,-2167);
 Engine.MoveTo(146377,24455,-2039);
 Engine.MoveTo(146484,25685,-2039);
 Engine.MoveTo(147130,25700,-2039);
 Engine.MoveTo(147112,25921,-2039);
end;
if User.InRange(146497,30582,-2487,500)  then
begin
 Engine.MoveTo(146497,30582,-2487);
 Engine.MoveTo(147058,30323,-2487);
 Engine.MoveTo(147427,29959,-2487);
 Engine.MoveTo(147427,29339,-2295);
 Engine.MoveTo(147373,28351,-2294);
 Engine.MoveTo(147100,27643,-2294);
 Engine.MoveTo(147246,26930,-2230);
 Engine.MoveTo(147267,26400,-2185);
 Engine.MoveTo(147266,26195,-2103);
 Engine.MoveTo(147250,25969,-2039);
 Engine.MoveTo(147206,25899,-2039);
 Engine.MoveTo(147138,25906,-2039);
end;
if User.InRange(144648,29158,-2487,500)  then
begin
 Engine.MoveTo(144648,29158,-2487);
 Engine.MoveTo(144966,28868,-2487);
 Engine.MoveTo(145110,27659,-2295);
 Engine.MoveTo(146220,27622,-2231);
 Engine.MoveTo(147108,27272,-2231);
 Engine.MoveTo(147224,26929,-2230);
 Engine.MoveTo(147267,26400,-2185);
 Engine.MoveTo(147266,26195,-2103);
 Engine.MoveTo(147250,25969,-2039);
 Engine.MoveTo(147206,25899,-2039);
 Engine.MoveTo(147138,25906,-2039);
end;
if User.InRange(150247,29109,-2487,500)  then
begin
 Engine.MoveTo(150247,29109,-2487);
 Engine.MoveTo(149921,28836,-2487);
 Engine.MoveTo(149859,28063,-2339);
 Engine.MoveTo(149776,27675,-2295);
 Engine.MoveTo(148731,27683,-2231);
 Engine.MoveTo(148224,27383,-2231);
 Engine.MoveTo(147306,26932,-2230);
end;
if User.InRange(147848,30309,-2487,500)  then
begin
 Engine.MoveTo(147848,30309,-2487);
 Engine.MoveTo(147677,30089,-2487);
 Engine.MoveTo(147462,29870,-2447);
 Engine.MoveTo(147462,29413,-2295);
 Engine.MoveTo(147335,28272,-2294);
 Engine.MoveTo(147108,27664,-2294);
 Engine.MoveTo(147194,26961,-2229);
 Engine.MoveTo(147267,26400,-2185);
 Engine.MoveTo(147266,26195,-2103);
 Engine.MoveTo(147250,25969,-2039);
 Engine.MoveTo(147206,25899,-2039);
 Engine.MoveTo(147138,25906,-2039);

end;
if User.InRange(144651,26680,-2295,500)  then
begin
 Engine.MoveTo(144651,26680,-2295);
 Engine.MoveTo(144681,27050,-2294);
 Engine.MoveTo(144936,27135,-2295);
 Engine.MoveTo(145145,27605,-2295);
 Engine.MoveTo(146182,27682,-2231);
 Engine.MoveTo(146921,27360,-2231);
 Engine.MoveTo(147218,26948,-2229);
 Engine.MoveTo(147267,26400,-2185);
 Engine.MoveTo(147266,26195,-2103);
 Engine.MoveTo(147250,25969,-2039);
 Engine.MoveTo(147206,25899,-2039);
 Engine.MoveTo(147138,25906,-2039);

end;
if User.InRange(148557,30461,-2487,500)  then
begin
 Engine.MoveTo(148557,30461,-2487);
 Engine.MoveTo(148114,30076,-2487);
 Engine.MoveTo(147453,30049,-2487);
 Engine.MoveTo(147474,29710,-2368);
 Engine.MoveTo(147397,28461,-2294);
 Engine.MoveTo(147044,27389,-2231);
 Engine.MoveTo(147242,26823,-2230);
 Engine.MoveTo(147267,26400,-2185);
 Engine.MoveTo(147266,26195,-2103);
 Engine.MoveTo(147250,25969,-2039);
 Engine.MoveTo(147206,25899,-2039);
 Engine.MoveTo(147138,25906,-2039);

end;
if User.InRange(147971,27982,-2294,500)  then
begin
 Engine.MoveTo(147971,27982,-2294);
 Engine.MoveTo(147846,27354,-2231);
 Engine.MoveTo(147265,26878,-2230);
 Engine.MoveTo(147267,26400,-2185);
 Engine.MoveTo(147266,26195,-2103);
 Engine.MoveTo(147250,25969,-2039);
 Engine.MoveTo(147206,25899,-2039);
 Engine.MoveTo(147138,25906,-2039);

end;
// Dion:
if User.InRange(19134,144847,-3096, 250, 150) then begin
Engine.MoveTo(19134,144847,-3096);
Engine.MoveTo(18041,144052,-3057);
Engine.MoveTo(16727,144111,-2980);
Engine.MoveTo(15933,143331,-2771);  
Engine.MoveTo(15628,142920,-2704);
end;
if User.InRange(18954,144428,-3096, 250, 150) then begin
Engine.MoveTo(18954,144428,-3096);
Engine.MoveTo(18600,144387,-3070);
Engine.MoveTo(17733,143924,-3037);
Engine.MoveTo(16711,144167,-2980);
Engine.MoveTo(16622,144034,-2932);
Engine.MoveTo(15963,143381,-2784);  
Engine.MoveTo(15628,142920,-2704);
end;
if User.InRange(19012,145140,-3120, 250, 150) then begin
Engine.MoveTo(19012,145140,-3120);
Engine.MoveTo(19021,145126,-3123);
Engine.MoveTo(17600,145497,-3079);
Engine.MoveTo(16468,144129,-2964);  
Engine.MoveTo(15628,142920,-2704);
end;
if User.InRange(19613,145607,-3104, 250, 150) then begin
Engine.MoveTo(19613,145607,-3104);
Engine.MoveTo(17638,145591,-3084);
Engine.MoveTo(16214,143659,-2863);  
Engine.MoveTo(15628,142920,-2704);
end;
if User.InRange(18576,145136,-3104, 250, 150) then begin
Engine.MoveTo(18576,145136,-3104);
Engine.MoveTo(17727,145541,-3082);
Engine.MoveTo(16414,144174,-2969);  
Engine.MoveTo(15628,142920,-2704);
end;
if User.InRange(17398,145456,-3048, 250, 150) then begin
Engine.MoveTo(17398,145456,-3048);
Engine.MoveTo(17727,145541,-3082);
Engine.MoveTo(16414,144174,-2969);  
Engine.MoveTo(15628,142920,-2704);
end;
if User.InRange(17144,145055,-3024, 250, 150) then begin
Engine.MoveTo(17144,145055,-3024);
Engine.MoveTo(16350,143905,-2923);
Engine.MoveTo(15628,142920,-2704);
end;
if User.InRange(18078,145925,-3112, 250, 150) then begin
Engine.MoveTo(18078,145925,-3112);
Engine.MoveTo(16559,144353,-2987);
Engine.MoveTo(15628,142920,-2704);
end;
if User.InRange(19150,143941,-3056, 250, 150) then begin
Engine.MoveTo(19150,143941,-3056);
Engine.MoveTo(18112,145633,-3104);
Engine.MoveTo(17108,145059,-3031);
Engine.MoveTo(16469,144176,-2969);  
Engine.MoveTo(15628,142920,-2704);
end;
if User.InRange(18512,145536,-3120, 250, 150) then begin
Engine.MoveTo(18512,145536,-3120);
Engine.MoveTo(17226,145360,-3048);
Engine.MoveTo(16419,143955,-2935);  
Engine.MoveTo(15628,142920,-2704);
end;
if User.InRange(18717,145711,-3080, 250, 150) then begin
Engine.MoveTo(18717,145711,-3080);
Engine.MoveTo(17226,145360,-3048);
Engine.MoveTo(16419,143955,-2935);  
Engine.MoveTo(15628,142920,-2704);
end;
if User.InRange(17734, 146681, -3110, 500, 500) then begin
Engine.MoveTo(17734, 146681, -3110);
Engine.MoveTo(17873, 146031, -3125);
Engine.MoveTo(16940, 144708, -3026);
Engine.MoveTo(16016, 143397, -2821);
Engine.MoveTo(15657, 142935, -2732);
end;
if User.InRange(20071, 145660, -3154,500,500) then begin
Engine.MoveTo(20071, 145660, -3154);
Engine.MoveTo(18036, 145590, -3121);
Engine.MoveTo(17219, 145078, -3066);
Engine.MoveTo(16329, 143825, -2934);
Engine.MoveTo(15657, 142915, -2732);
end;
if User.InRange(16823, 144610, -2996, 500, 500) then begin
Engine.MoveTo(16823, 144610, -2996);
Engine.MoveTo(15658, 142947, -2732);
end;// Giran:
if User.InRange(18854, 144824, -3140, 500, 500) then begin
Engine.MoveTo(18854, 144824, -3140);
Engine.MoveTo(17894, 145461, -3090);
Engine.MoveTo(17001, 144913, -3040);
Engine.MoveTo(16331, 143874, -2945);
Engine.MoveTo(15658, 142931, -2732);
end;
if User.InRange(19067, 142896, -3049, 500, 500) then begin
Engine.MoveTo(19067, 142896, -3049);
Engine.MoveTo(18488, 143016, -3044);
Engine.MoveTo(17016, 144159, -3045);
Engine.MoveTo(15681, 142940, -2732);
end;
if User.InRange(81376,148095,-3464, 250, 150) then begin
	Engine.MoveTo(81376,148095,-3464);
	Engine.MoveTo(81881,148025,-3467);
	Engine.MoveTo(83027,148020,-3467);
	Engine.MoveTo(83402,147946,-3403);
end;
if User.InRange(82292,149450,-3464, 250, 150) then begin
	Engine.MoveTo(82292,149450,-3464);
	Engine.MoveTo(82865,148876,-3467);
	Engine.MoveTo(83054,148281,-3467);      
	Engine.MoveTo(83402,147946,-3403);
end;
if User.InRange(81562,147782,-3464, 250, 150) then begin
	Engine.MoveTo(81562,147782,-3464);
	Engine.MoveTo(82284,148077,-3467);
	Engine.MoveTo(83077,148159,-3467);      
	Engine.MoveTo(83402,147946,-3403);
end;
if User.InRange(83409,148578,-3400, 250, 150) then begin
	Engine.MoveTo(83409,148578,-3400);
	Engine.MoveTo(83427,148206,-3403);
	Engine.MoveTo(83402,147946,-3403);
end;
if User.InRange(81440,149119,-3464, 250, 150) then begin
	Engine.MoveTo(81440,149119,-3464);
	Engine.MoveTo(82200,149222,-3467);
	Engine.MoveTo(82722,148485,-3467);
	Engine.MoveTo(83087,148101,-3467);     
	Engine.MoveTo(83402,147946,-3403);
end;
if User.InRange(82496,148095,-3464, 250, 150) then begin
	Engine.MoveTo(82496,148095,-3464);
	Engine.MoveTo(83092,148094,-3467);
	Engine.MoveTo(83402,147946,-3403);
end;
if User.InRange(83473,149223,-3400, 250, 150) then begin
	Engine.MoveTo(83473,149223,-3400);
	Engine.MoveTo(83355,148728,-3403);
	Engine.MoveTo(83358,148292,-3403);     
	Engine.MoveTo(83402,147946,-3403);
end;
if User.InRange(82272,147801,-3464, 250, 150) then begin
	Engine.MoveTo(82272,147801,-3464);
	Engine.MoveTo(82565,148080,-3467);
	Engine.MoveTo(83101,148099,-3467);      
	Engine.MoveTo(83402,147946,-3403);
end;
if User.InRange(82480,149087,-3464, 250, 150) then begin
	Engine.MoveTo(82480,149087,-3464);
	Engine.MoveTo(82623,148694,-3467);
	Engine.MoveTo(83087,148157,-3467);      
	Engine.MoveTo(83402,147946,-3403);
end;
if User.InRange(81637,149427,-3464, 250, 150) then begin
	Engine.MoveTo(81637,149427,-3464);
	Engine.MoveTo(82229,149197,-3467);
	Engine.MoveTo(82610,148669,-3467);
	Engine.MoveTo(83088,148170,-3467);
	Engine.MoveTo(83402,147946,-3403);
end;
if User.InRange(81062,148144,-3464, 250, 150) then begin
	Engine.MoveTo(81062,148144,-3464);
	Engine.MoveTo(81574,147997,-3467);
	Engine.MoveTo(82302,147975,-3467);
	Engine.MoveTo(83070,148109,-3467);      
	Engine.MoveTo(83402,147946,-3403);
end;
if User.InRange(83426,148835,-3400, 250, 150) then begin
	Engine.MoveTo(83426,148835,-3400);
	Engine.MoveTo(83422,148276,-3403);     
	Engine.MoveTo(83402,147946,-3403);
end;
if User.InRange(81033,148883,-3464, 250, 150) then begin
	Engine.MoveTo(81033,148883,-3464);
	Engine.MoveTo(81769,149191,-3467);
	Engine.MoveTo(82322,149192,-3467);
	Engine.MoveTo(82622,148656,-3467);
	Engine.MoveTo(83079,148163,-3467);     
	Engine.MoveTo(83402,147946,-3403);
end;
if User.InRange(83415,148235,-3400, 250, 150) then begin
	Engine.MoveTo(83415,148235,-3400);      
	Engine.MoveTo(83402,147946,-3403);
end;
if User.InRange(81510, 151064, -3554, 500, 500) then begin
Engine.MoveTo(81510, 151064, -3554);
Engine.MoveTo(81561, 149432, -3495);
Engine.MoveTo(82819, 149387, -3495);
Engine.MoveTo(83114, 148010, -3486);
Engine.MoveTo(83328, 147913, -3431);
end;
if User.InRange(85603, 149642, -3413, 500, 500) then begin
Engine.MoveTo(85603, 149642, -3413);
Engine.MoveTo(83634, 149405, -3431);
Engine.MoveTo(83410, 147960, -3431);
Engine.MoveTo(83347, 147930, -3431);
end;
if User.InRange(83903, 145674, -3426, 500, 500) then begin
Engine.MoveTo(83903, 145674, -3426);
Engine.MoveTo(83863, 147663, -3431);
Engine.MoveTo(83494, 147901, -3431);
Engine.MoveTo(83341, 147924, -3431);
end;
if User.InRange(85495, 147367, -3426, 500, 500) then begin
Engine.MoveTo(85495, 147367, -3426);
Engine.MoveTo(84582, 147487, -3431);
Engine.MoveTo(83502, 147893, -3431);
Engine.MoveTo(83340, 147935, -3431);
end;
if User.InRange(81231, 148652, -3464, 500, 500) then begin
Engine.MoveTo(81231, 148652, -3464);
Engine.MoveTo(81820, 149448, -3495);
Engine.MoveTo(82771, 149356, -3495);
Engine.MoveTo(83080, 148147, -3495);
Engine.MoveTo(83332, 147931, -3431);
end;
if User.InRange(78682, 148642, -3618, 500, 500) then begin
Engine.MoveTo(78682, 148642, -3618);
Engine.MoveTo(80290, 148614, -3559);
Engine.MoveTo(81009, 148625, -3495);
Engine.MoveTo(81123, 149398, -3495);
Engine.MoveTo(82813, 149379, -3495);
Engine.MoveTo(82998, 148358, -3495);
Engine.MoveTo(83315, 147911, -3431);
end;
if User.InRange(81813, 149242, -3490, 500, 500) then begin
Engine.MoveTo(81813, 149242, -3490);
Engine.MoveTo(82175, 149377, -3495);
Engine.MoveTo(82791, 149364, -3495);
Engine.MoveTo(83086, 148111, -3495);
Engine.MoveTo(83318, 147903, -3431);
end;
//Gludin: 
if User.InRange(-82909,150357,-3120, 250, 150) then begin
	Engine.MoveTo(-82909,150357,-3120);
	Engine.MoveTo(-82293,150405,-3127);
	Engine.MoveTo(-81099,150292,-3048);  
	Engine.MoveTo(-81073,150110,-3042);
end;
if User.InRange(-83520,150560,-3120, 250, 150) then begin
	Engine.MoveTo(-83520,150560,-3120);
	Engine.MoveTo(-82640,150552,-3127);
	Engine.MoveTo(-81440,150392,-3127);
	Engine.MoveTo(-81054,150149,-3042);  
	Engine.MoveTo(-81073,150110,-3042);
end;
if User.InRange(-82195,150489,-3120, 250, 150) then begin
	Engine.MoveTo(-82195,150489,-3120);
	Engine.MoveTo(-81832,150490,-3101);
	Engine.MoveTo(-81023,150193,-3042);  
	Engine.MoveTo(-81073,150110,-3042);
end;
if User.InRange(-80053,154348,-3168, 250, 150) then begin
	Engine.MoveTo(-80053,154348,-3168);
	Engine.MoveTo(-80686,153974,-3176);
	Engine.MoveTo(-81784,153952,-3176);
	Engine.MoveTo(-83049,153943,-3176);
	Engine.MoveTo(-83023,152370,-3127);
	Engine.MoveTo(-82637,151293,-3127);
	Engine.MoveTo(-81296,150467,-3127);
	Engine.MoveTo(-81042,150263,-3042); 
	Engine.MoveTo(-81073,150110,-3042);
end;
if User.InRange(-82035,152647,-3168, 250, 150) then begin
	Engine.MoveTo(-82035,152647,-3168);
	Engine.MoveTo(-82975,152676,-3176);
	Engine.MoveTo(-82932,151752,-3127);
	Engine.MoveTo(-81276,150510,-3127);
	Engine.MoveTo(-81036,150260,-3042); 
	Engine.MoveTo(-81073,150110,-3042);
end;
if User.InRange(-83529,151205,-3120, 250, 150) then begin
	Engine.MoveTo(-83529,151205,-3120);
	Engine.MoveTo(-82130,150895,-3127);
	Engine.MoveTo(-81088,150361,-3044);  
	Engine.MoveTo(-81073,150110,-3042);
end;
if User.InRange(-81721,151202,-3120, 250, 150) then begin
	Engine.MoveTo(-81721,151202,-3120);
	Engine.MoveTo(-81403,150675,-3127);
	Engine.MoveTo(-81057,150318,-3042);  
	Engine.MoveTo(-81073,150110,-3042);
end;
if User.InRange(-82575,151025,-3120, 250, 150) then begin
	Engine.MoveTo(-82575,151025,-3120);
	Engine.MoveTo(-81540,150540,-3127);
	Engine.MoveTo(-80989,150147,-3042);  
	Engine.MoveTo(-81073,150110,-3042);
end;
if User.InRange(-84064,150864,-3120, 250, 150) then begin
	Engine.MoveTo(-84064,150864,-3120);
	Engine.MoveTo(-83114,150635,-3127);
	Engine.MoveTo(-81390,150478,-3127);
	Engine.MoveTo(-81017,150133,-3042);  
	Engine.MoveTo(-81073,150110,-3042);
end;
if User.InRange(-82241,151163,-3120, 250, 150) then begin
	Engine.MoveTo(-82241,151163,-3120);
	Engine.MoveTo(-81391,150602,-3127);
	Engine.MoveTo(-80999,150174,-3042);  
	Engine.MoveTo(-81073,150110,-3042);
end;
if User.InRange(-81787,150780,-3120, 250, 150) then begin
	Engine.MoveTo(-81787,150780,-3120);
	Engine.MoveTo(-81049,150378,-3042);  
  Engine.MoveTo(-81073,150110,-3042);
end;

// Goddard:
if User.InRange(150206, -57176, -3002, 500, 500) then
begin
  Engine.MoveTo(149833, -56821, -3007);
  Engine.MoveTo(149147, -56361, -2807);
  Engine.MoveTo(147946, -55965, -2799);
  Engine.MoveTo(147983, -55301, -2759);
  
end;
if User.InRange(150206, -57160, -2981, 500, 500) then
begin
  Engine.MoveTo(149711, -56738, -2942);
  Engine.MoveTo(149063, -56370, -2807);
  Engine.MoveTo(147967, -55953, -2799);
  Engine.MoveTo(147927, -55280, -2759);

end;
if user.InRange(146272, -58176, -2976, 250, 150) then begin
	Engine.MoveTo(147593, -58103, -3007);
	Engine.MoveTo(147727, -57141, -2807);
	Engine.MoveTo(147936, -55368, -2760);
end;  
	if user.InRange(145264, -57680, -2976, 250, 150) then begin
	Engine.MoveTo(145588, -56926, -3007);
	Engine.MoveTo(146673, -56095, -2807);
	Engine.MoveTo(147543, -56054, -2807);
	Engine.MoveTo(147936, -55368, -2760);  
end;  
if user.InRange(145696, -57696, -2976, 250, 150) then begin
	Engine.MoveTo(145510, -56930, -3007);
	Engine.MoveTo(146499, -56202, -2807);
	Engine.MoveTo(147481, -56031, -2807);
	Engine.MoveTo(147936, -55368, -2760);
end;  
if user.InRange(144944, -55392, -2976, 250, 150) then begin
	Engine.MoveTo(145153, -56813, -3007);
	Engine.MoveTo(145569, -56855, -3007);
	Engine.MoveTo(146467, -56271, -2807);
	Engine.MoveTo(147566, -56034, -2807);
	Engine.MoveTo(147936, -55368, -2760);   
end;  
if user.InRange(144752, -56752, -2976, 250, 150) then begin
	Engine.MoveTo(145534, -56884, -3007);
	Engine.MoveTo(146265, -56418, -2807);
	Engine.MoveTo(147407, -56063, -2807);
	Engine.MoveTo(147936, -55368, -2760);
end;  
if user.InRange(149120, -58064, -2976, 250, 150) then begin
	Engine.MoveTo(147706, -58107, -3007);
	Engine.MoveTo(147751, -56737, -2807);
	Engine.MoveTo(147936, -55368, -2760);
end;  
if user.InRange(150400, -56752, -2976, 250, 150) then begin
	Engine.MoveTo(149935, -56870, -3007);
	Engine.MoveTo(149139, -56390, -2807);
	Engine.MoveTo(147929, -56063, -2807);
	Engine.MoveTo(147936, -55368, -2760);   
end;  
if user.InRange(150704, -55744, -2976, 250, 150) then begin
	Engine.MoveTo(149935, -56870, -3007);
	Engine.MoveTo(149139, -56390, -2807);
	Engine.MoveTo(147929, -56063, -2807);
	Engine.MoveTo(147936, -55368, -2760);   
end;  
if user.InRange(147680, -58208, -2976, 250, 150) then begin
	Engine.MoveTo(147727, -57141, -2807);
	Engine.MoveTo(147936, -55368, -2760);
end;  
if user.InRange(148288, -58304, -2976, 250, 150) then begin
	Engine.MoveTo(147738, -58050, -3007);
	Engine.MoveTo(147727, -57141, -2807);
	Engine.MoveTo(147936, -55368, -2760);
end;  
if user.InRange(147232, -58480, -2976, 250, 150) then begin
	Engine.MoveTo(147677, -58063, -3007);
	Engine.MoveTo(147727, -57141, -2807);
	Engine.MoveTo(147936, -55368, -2760);
end;  
if user.InRange(149088, -56256, -2776, 250, 150) then begin
	Engine.MoveTo(147854, -56054, -2807);
	Engine.MoveTo(147934, -55354, -2760);   
end;
if user.InRange(146832, -55904, -2776, 250, 150) then begin
	Engine.MoveTo(147529, -56046, -2807);
	Engine.MoveTo(147936, -55368, -2760);
end;
if user.InRange(146368, -56256, -2776, 250, 150) then begin
	Engine.MoveTo(147529, -56046, -2807);
	Engine.MoveTo(147936, -55368, -2760);
end;
if user.InRange(147664, -56464, -2776, 250, 150) then begin
	Engine.MoveTo(147936, -55368, -2760);
end;
if user.InRange(147680, -56928, -2776, 250, 150) then begin
	Engine.MoveTo(147810, -56110, -2807);
	Engine.MoveTo(147936, -55368, -2760);
end;
if user.InRange(148560, -55904, -2776, 250, 150) then begin
	Engine.MoveTo(147936, -55368, -2760);
end;
if user.InRange(149872, -57424, -2976, 250, 150) then begin
	Engine.MoveTo(149897, -56910, -2979);
	Engine.MoveTo(149230, -56412, -2779);
	Engine.MoveTo(147939, -55999, -2772);
	Engine.MoveTo(147936, -55368, -2760);
end;
if user.InRange(144960, -56224, -2976, 250, 150) then begin
	Engine.MoveTo(145458, -56853, -2979);
	Engine.MoveTo(146343, -56326, -2779);
	Engine.MoveTo(147625, -55995, -2772);
	Engine.MoveTo(147936, -55368, -2760);
end;   
if user.InRange(144496, -55088, -2976, 250, 150) then begin
	Engine.MoveTo(145327, -56873, -2979);
	Engine.MoveTo(146337, -56445, -2779);
	Engine.MoveTo(147533, -55963, -2766);
	Engine.MoveTo(147936, -55368, -2760);
end;
if user.InRange(145392, -56960, -2976, 250, 150) then begin
	Engine.MoveTo(146347, -56305, -2779);
	Engine.MoveTo(147514, -56003, -2772);
	Engine.MoveTo(147936, -55368, -2760);
end;

// Heine:

if User.InRange(110912,219584,-3664, 250, 150) then begin
	Engine.MoveTo(110912,219584,-3664);
	Engine.MoveTo(111154,219735,-3675);
	Engine.MoveTo(111176,219395,-3546);  
	Engine.MoveTo(111387,219387,-3544);
end;
if User.InRange(111888,219584,-3664, 250, 150) then begin
	Engine.MoveTo(111888,219584,-3664);
	Engine.MoveTo(111617,219703,-3674);
	Engine.MoveTo(111591,219371,-3544);  
	Engine.MoveTo(111387,219387,-3544);
end;
if User.InRange(112064,219792,-3664, 250, 150) then begin
	Engine.MoveTo(112064,219792,-3664);
	Engine.MoveTo(111665,219800,-3675);
	Engine.MoveTo(111580,219329,-3544);  
	Engine.MoveTo(111387,219387,-3544);
end;
if User.InRange(107808,217856,-3672, 250, 150) then begin
	Engine.MoveTo(107808,217856,-3672);
	Engine.MoveTo(107769,217524,-3673);
	Engine.MoveTo(109387,217509,-3747);
	Engine.MoveTo(110037,217257,-3747);
	Engine.MoveTo(110072,219029,-3477);
	Engine.MoveTo(111202,219130,-3541);  
	Engine.MoveTo(111387,219387,-3544);
end;
if User.InRange(110896,220768,-3664, 250, 150) then begin
	Engine.MoveTo(110896,220768,-3664);
	Engine.MoveTo(111191,219621,-3663);
	Engine.MoveTo(111190,219303,-3544);  
	Engine.MoveTo(111387,219387,-3544);
end;
if User.InRange(110768,219824,-3664, 250, 150) then begin
	Engine.MoveTo(110768,219824,-3664);
	Engine.MoveTo(111163,219763,-3671);
	Engine.MoveTo(111199,219319,-3544);  
	Engine.MoveTo(111387,219387,-3544);
end;
if User.InRange(112112,220576,-3664, 250, 150) then begin
	Engine.MoveTo(112112,220576,-3664);
	Engine.MoveTo(111600,219666,-3669);
	Engine.MoveTo(111586,219305,-3544);  
	Engine.MoveTo(111387,219387,-3544);
end;
if User.InRange(110688,220576,-3664, 250, 150) then begin
	Engine.MoveTo(110688,220576,-3664);
	Engine.MoveTo(111183,219655,-3669);
	Engine.MoveTo(111201,219292,-3544);  
	Engine.MoveTo(111387,219387,-3544);
end;
if User.InRange(108032,218048,-3672, 250, 150) then begin
	Engine.MoveTo(108032,218048,-3672);
	Engine.MoveTo(107862,218003,-3673);
	Engine.MoveTo(107840,217532,-3673);
	Engine.MoveTo(109383,217465,-3747);
	Engine.MoveTo(110036,217280,-3747);
	Engine.MoveTo(110096,219040,-3478);
	Engine.MoveTo(111086,219100,-3541);  
	Engine.MoveTo(111387,219387,-3544);
end;
if User.InRange(107568,218256,-3672, 250, 150) then begin
	Engine.MoveTo(107568,218256,-3672);
	Engine.MoveTo(107542,217872,-3673);
	Engine.MoveTo(107840,217532,-3673);
	Engine.MoveTo(109383,217465,-3747);
	Engine.MoveTo(110036,217280,-3747);
	Engine.MoveTo(110096,219040,-3478);
	Engine.MoveTo(111086,219100,-3541);  
	Engine.MoveTo(111387,219387,-3544);
end;
if User.InRange(107552,218000,-3672, 250, 150) then begin
	Engine.MoveTo(107552,218000,-3672);
	Engine.MoveTo(107862,218003,-3673);
	Engine.MoveTo(107840,217532,-3673);
	Engine.MoveTo(109383,217465,-3747);
	Engine.MoveTo(110036,217280,-3747);
	Engine.MoveTo(110096,219040,-3478);
	Engine.MoveTo(111086,219100,-3541);  
	Engine.MoveTo(111387,219387,-3544);
end;
if User.InRange(111856,220752,-3664, 250, 150) then begin
	Engine.MoveTo(111856,220752,-3664);
	Engine.MoveTo(111573,219730,-3675);
	Engine.MoveTo(111589,219342,-3544);
	Engine.MoveTo(111387,219387,-3544);
end;




begin // Shuttgart:
if User.InRange(87184,-140256,-1536, 250, 150) then begin
Engine.MoveTo(87184,-140256,-1536);
Engine.MoveTo(87368,-140838,-1512);
Engine.MoveTo(87319,-141796,-1338);
Engine.MoveTo(87145,-142916,-1313);
Engine.MoveTo(87070,-143418,-1290);
end;
if User.InRange(87408,-142304,-1336, 250, 150) then begin
Engine.MoveTo(87408,-142304,-1336);
Engine.MoveTo(87145,-142916,-1313);
Engine.MoveTo(87070,-143418,-1290);
end;
if User.InRange(88240,-142736,-1336, 250, 150) then begin
Engine.MoveTo(88240,-142736,-1336);  
Engine.MoveTo(87585,-142662,-1338);  
Engine.MoveTo(87070,-143418,-1290);
end;
if User.InRange(85056,-141328,-1528, 250, 150) then begin
Engine.MoveTo(85056,-141328,-1528);
Engine.MoveTo(85181,-141845,-1539);
Engine.MoveTo(85804,-142279,-1339);
Engine.MoveTo(87157,-142636,-1338);  
Engine.MoveTo(87070,-143418,-1290);
end;
if User.InRange(88624,-142480,-1336, 250, 150) then begin
Engine.MoveTo(88624,-142480,-1336);
Engine.MoveTo(87548,-142686,-1331);
Engine.MoveTo(87070,-143418,-1290);
end;
if User.InRange(86400,-142672,-1336, 250, 150) then begin
Engine.MoveTo(86400,-142672,-1336);
Engine.MoveTo(87143,-142570,-1338);
Engine.MoveTo(87070,-143418,-1290);
end;
if User.InRange(86560,-140320,-1536, 250, 150) then begin
Engine.MoveTo(86560,-140320,-1536);
Engine.MoveTo(87300,-140655,-1539);
Engine.MoveTo(87385,-141436,-1339);
Engine.MoveTo(87246,-142537,-1338);
Engine.MoveTo(87070,-143418,-1290);
end;
if User.InRange(88448,-140512,-1536, 250, 150) then begin
Engine.MoveTo(88448,-140512,-1536);
Engine.MoveTo(87410,-140642,-1539);
Engine.MoveTo(87299,-141493,-1338);
Engine.MoveTo(87291,-142607,-1338);
Engine.MoveTo(87070,-143418,-1290);
end;
if User.InRange(89712,-141472,-1528, 250, 150) then begin
Engine.MoveTo(89712,-141472,-1528);
Engine.MoveTo(89497,-141893,-1539);
Engine.MoveTo(88963,-142272,-1339);
Engine.MoveTo(87737,-142631,-1338);
Engine.MoveTo(87070,-143418,-1290);
end;
if User.InRange(87344,-141696,-1336, 250, 150) then begin
Engine.MoveTo(87344,-141696,-1336);
Engine.MoveTo(87354,-142594,-1338);
Engine.MoveTo(87070,-143418,-1290);
end;
if User.InRange(85472,-140752,-1536, 250, 150) then begin
Engine.MoveTo(85472,-140752,-1536);
Engine.MoveTo(85191,-141803,-1539);
Engine.MoveTo(85909,-142322,-1338);
Engine.MoveTo(87096,-142671,-1338);
Engine.MoveTo(87070,-143418,-1290);
end;
if User.InRange(89360,-140944,-1536, 250, 150) then begin
Engine.MoveTo(89360,-140944,-1536);
Engine.MoveTo(89539,-141762,-1539);
Engine.MoveTo(88910,-142276,-1339);
Engine.MoveTo(87637,-142734,-1332);
Engine.MoveTo(87070,-143418,-1290);
end;
if User.InRange(87776,-140384,-1536, 250, 150) then begin
Engine.MoveTo(87776,-140384,-1536);
Engine.MoveTo(87403,-140707,-1539);
Engine.MoveTo(87351,-141645,-1338);
Engine.MoveTo(87310,-142568,-1338);
Engine.MoveTo(87070,-143418,-1290);
end;
if User.InRange(84720,-141936,-1536, 250, 150) then begin
Engine.MoveTo(84720,-141936,-1536);
Engine.MoveTo(85201,-141842,-1539);
Engine.MoveTo(85807,-142262,-1339);
Engine.MoveTo(87116,-142704,-1338);
Engine.MoveTo(87070,-143418,-1290);
end;
if User.InRange(85968,-142384,-1336, 250, 150) then begin
Engine.MoveTo(85968,-142384,-1336);
Engine.MoveTo(87116,-142704,-1338);
Engine.MoveTo(87070,-143418,-1290);
end;
end;
end;
begin // Tvarkingi:
begin // Talking Island:
if User.InRange(-83056, 244333, -3750, 1000, 500) then begin
Engine.MoveTo(-83267, 244424, -3755);
Engine.MoveTo(-83727, 244714, -3755);
Engine.MoveTo(-84071, 244607, -3755);
end;
if User.InRange(-85000, 242067, -3750, 1000, 500) then begin
Engine.MoveTo(-84776, 243046, -3755);
Engine.MoveTo(-85044, 243937, -3755);
Engine.MoveTo(-84130, 244582, -3755);
end;
if User.InRange(-84193, 243399, -3121, 1000, 500) then begin
Engine.MoveTo(-84720, 243331, -3696);
Engine.MoveTo(-85044, 243937, -3755);
Engine.MoveTo(-84130, 244582, -3755);
end;
if User.InRange(-85573, 243972, -3750, 1000, 500) then begin
Engine.MoveTo(-84130, 244582, -3755);
end;
end;
begin // Elf
if User.InRange(45568, 47104, -3022, 1000, 500)
then Engine.MoveTo(45483, 48153, -3086); //-> North center

if User.InRange(43206, 48952, -3022, 500, 500)
or User.InRange(43485, 50418, -2990, 500, 500)
then Engine.MoveTo(44776, 49928, -3086); //-> Sauth-West center

if User.InRange(45577, 48257, -3086, 1000, 500) // North center
or User.InRange(44776, 49928, -3086, 1000, 500) // Sauth-West center
then Engine.MoveTo(46391, 49941, -3086); // pre prie gk

if User.InRange(47463, 48989, -2990, 500, 500)
then Engine.MoveTo(47458, 50239, -3022);

if User.InRange(46391, 49941, -3086, 1000, 500) // pre prie gk
or User.InRange(47458, 50239, -3022, 500, 500)
then Engine.MoveTo(47074, 50750, -3022);      //-> prie gk

if User.InRange(47074, 50750, -3022, 500, 500) // prie gk
then Engine.MoveTo(46934, 51454, -3003); //-> GK

if User.InRange(45355, 51601, -2832, 250, 500) then begin // bazinycios balkonas
Engine.MoveTo(45355, 51601, -2832); 
Engine.MoveTo(45367, 52275, -2823);
Engine.MoveTo(46033, 52183, -2823);
Engine.MoveTo(46045, 51606, -2839);
Engine.MoveTo(46387, 51532, -2872);
Engine.MoveTo(46413, 51247, -2952);
Engine.MoveTo(46687, 51261, -3022);
Engine.MoveTo(46934, 51454, -3003); //-> GK
end;
end;
begin // Dwarf:
if User.InRange(116535, -182369, -1539, 2000, 500) // North end of village
then Engine.MoveTo(116685, -179982, -1191); //-> center

if User.InRange(116685, -179982, -1191, 500, 500) //center
then Engine.MoveTo(115664, -179252, -996); //-> hero monemnt

if User.InRange(115222, -177313, -925, 700, 500) // sauth exit
or User.InRange(115664, -179252, -996, 700, 500) // hero monemnt
then Engine.MoveTo(115406, -178105, -955); //-> prie gk

if User.InRange(115406, -178105, -955, 300, 500) // prie gk
then Engine.MoveTo(115093, -178177, -916); //-> GK
end;
begin // D.Elf:

		
		
		
		
		
		
if User.InRange(10376, 14435, -4269, 200, 500) then begin // Harne
	Engine.MoveTo(10376, 14435, -4269);
	Engine.MoveTo(10810, 14330, -4269);
	Engine.MoveTo(10987, 14963, -4367);
	Engine.MoveTo(10552, 15043, -4367);
	Engine.MoveTo(10629, 15519, -4601);
	Engine.MoveTo(10200, 15658, -4601);
end;

if User.InRange(12839, 16526, -4585, 700, 500) // east
or User.InRange(11126, 15746, -4606, 500, 500) // bottom of stairs
or User.InRange(11808, 18261, -4578, 500, 500) // Sauth
or User.InRange(14151, 16202, -4579, 500, 500) // east far
then Engine.MoveTo(11471, 16739, -4688); //-> center

if User.InRange(11471, 16739, -4688, 700, 500) // center
or User.InRange(7544, 17717, -4372, 500, 500)  // far west
or User.InRange(9096, 17393, -4605, 500, 500) // west
then Engine.MoveTo(10204, 17113, -4610); //-> pre prie gk

if User.InRange(10204, 17113, -4610, 500, 500) // pre prie gk
then Engine.MoveTo(9838, 15662, -4601); //-> prie gk

if User.InRange(9838, 15662, -4601, 500, 500) // prie gk
then Engine.MoveTo(9695, 15556, -4601); //-> GK
end;
begin // Orc
if User.InRange(-47704, -113607, -255, 500, 500) // West outside town
then Engine.MoveTo(-45353, -113598, -265); //-> West entrance

if User.InRange(-46013, -116612, -260, 500, 500) // north [outside] vilage
then Engine.MoveTo(-45426, -115377, -265); 	//-> far North of village

if User.InRange(-45930, -110796, -260, 500, 500) // Sauth [outside]
then Engine.MoveTo(-45240, -111934, -265); // []

if User.InRange(-45426, -115377, -265, 500, 500) // far North of village
then Engine.MoveTo(-44660, -114727, -265);       //-> North end of village


if User.InRange(-45353, -113598, -265, 500, 500) // West entrance
then Engine.MoveTo(-44825, -113049, -265); //-> tarp centro ir 'prie gk'

if User.InRange(-44660, -114727, -265, 1000, 500) // North end of village
then Engine.MoveTo(-44066, -113572, -265); //-> pre prie gk

if User.InRange(-44066, -113572, -265, 700, 500) // pre prie gk
or User.InRange(-44825, -113049, -265, 500, 500) // tarp centro ir 'prie gk'
then Engine.MoveTo(-44843, -112538, -230); //-> prie gk

if User.InRange(-44843, -112538, -230, 1000, 500) // prie gk
then Engine.MoveTo(-45228, -112507, -265); //-> GK
end;
begin // Gludin:
if User.InRange(-80746, 153948, -3172, 500, 500) // prie orc
then Engine.MoveTo(-80757, 152741, -3204);     //-> sankryza 1 (prie orc)

if User.InRange(-81901, 154897, -3199, 500, 500) // Sauth of Warehouse
then Engine.MoveTo(-83046, 154834, -3204);     //-> Sankryza 3

if User.InRange(-83046, 154834, -3204, 500, 500) // sankryza 3 
then Engine.MoveTo(-83066, 153965, -3199);      //-> sankryza 2.5 ( tarp 2 ir 3 )

if User.InRange(-80757, 152741, -3204, 500, 500) // sankryza 1 (prie orc)
or User.InRange(-83066, 153965, -3199, 500, 500) // sankryza 2.5 ( tarp 2 ir 3 )
then Engine.MoveTo(-83066, 152740, -3204); //-> sankryza 2 (centrine)

if User.InRange(-83066, 152740, -3204, 500, 500) // sankryza 2(centrine)
then Engine.MoveTo(-82741, 151239, -3155); //-> newbie helper

if User.InRange(-82741, 151239, -3155, 500, 500) // newbie helper
then Engine.MoveTo(-81021, 150223, -3070);   //-> prie gk

if User.InRange(-81021, 150223, -3070, 500, 500) // prie gk
then Engine.MoveTo(-80764, 149783, -3070); //-> GK	
end;
begin // Gludio:
if User.InRange(-14135, 122026, -2983,500,500) then begin    // dawn
Engine.MoveTo(-14135, 122026, -2983);
Engine.MoveTo(-13293, 122433, -3015);
Engine.MoveTo(-13249, 122672, -3080);
Engine.MoveTo(-12752, 122772, -3143);
end;
if User.InRange(-12261, 121801, -3010, 500, 500) then begin   // Black Marketeer of mammon
Engine.MoveTo(-12261, 121801, -3010);
Engine.MoveTo(-13293, 122433, -3015);
Engine.MoveTo(-13249, 122672, -3080);
Engine.MoveTo(-12752, 122772, -3143);
end;
if User.InRange(-14315, 124873, -3123, 500, 500) or User.InRange(-15547, 123960, -3138, 500, 500) then
begin
Engine.MoveTo(-14352, 123859, -3143);
Engine.MoveTo(-12401, 123621, -3102); 
end;
if User.InRange(-12401, 123621, -3102, 500, 500) then begin
Engine.MoveTo(-12401, 123621, -3102);
Engine.MoveTo(-12271, 122917, -3129);
Engine.MoveTo(-12743, 122846, -3143);
end;
end;
begin // Dion
if User.InRange(15652, 169119, -3536, 500, 500) then begin // floran toliau nuo centro
Engine.MoveTo(16697, 170014, -3522);
Engine.MoveTo(17514, 170430, -3532);
Engine.MoveTo(17580, 170112, -3529);
end;

if User.InRange(17580, 170112, -3529, 700, 500) then begin // floran centras
Engine.MoveTo(17639, 169691, -3521);
Engine.MoveTo(17754, 169351, -3523);
Engine.MoveTo(17537, 168742, -3557);
Engine.MoveTo(17875, 165835, -3587);
Engine.MoveTo(17734, 164731, -3668);
Engine.MoveTo(17351, 163045, -3590);
mov_unstuck();
end;
end;
begin // Heine:
if User.InRange(107101, 221185, -3635, 500, 500) then begin
Engine.MoveTo(107101, 221185, -3635);
Engine.MoveTo(108088, 221221, -3697);
Engine.MoveTo(108321, 221401, -3672);
Engine.MoveTo(110171, 221390, -3569);
Engine.MoveTo(110244, 219140, -3507);
Engine.MoveTo(111376, 219157, -3569);
Engine.MoveTo(111386, 219387, -3572);
end;
if User.InRange(114547, 221396, -3650, 500, 500) then begin
Engine.MoveTo(114547, 221396, -3650);
Engine.MoveTo(112542, 221393, -3569);
Engine.MoveTo(112533, 219095, -3569);
Engine.MoveTo(111393, 219138, -3569);
Engine.MoveTo(111385, 219389, -3572);
end;														
if User.InRange(107086, 218185, -3669, 500, 500) then begin
Engine.MoveTo(107086, 218185, -3669);
Engine.MoveTo(107877, 217527, -3701);
Engine.MoveTo(109407, 217429, -3775);
Engine.MoveTo(110081, 217293, -3775);
Engine.MoveTo(110094, 219064, -3505);
Engine.MoveTo(111369, 219152, -3569);
Engine.MoveTo(111385, 219399, -3572);
end;
if User.InRange(112603, 221240, -3537, 500, 500) then begin
Engine.MoveTo(112603, 221240, -3537);
Engine.MoveTo(112566, 219151, -3569);
Engine.MoveTo(111382, 219170, -3569);
Engine.MoveTo(111385, 219396, -3572);
end;
if User.InRange(109802, 217207, -3743, 500, 500) then begin
Engine.MoveTo(109802, 217207, -3743);
Engine.MoveTo(110065, 217319, -3775);
Engine.MoveTo(110097, 219133, -3505);
Engine.MoveTo(111388, 219148, -3552);
Engine.MoveTo(111388, 219397, -3572);
end;
if User.InRange(112621, 219102, -3564, 500, 500) then begin
Engine.MoveTo(112621, 219102, -3564);
Engine.MoveTo(111415, 219113, -3569);
Engine.MoveTo(111382, 219395, -3572);
end;
if User.InRange(115535, 219216, -3657, 500, 500) then begin
Engine.MoveTo(115535, 219216, -3657);
Engine.MoveTo(115016, 218419, -3655);
Engine.MoveTo(114292, 217815, -3655);
Engine.MoveTo(112705, 217857, -3769);
Engine.MoveTo(112686, 219051, -3569);
Engine.MoveTo(111388, 219082, -3569);
Engine.MoveTo(111393, 219398, -3572);
end;
if User.InRange(109514, 221374, -3479, 500, 500) then begin
Engine.MoveTo(109514, 221374, -3479);
Engine.MoveTo(110189, 221385, -3569);
Engine.MoveTo(110222, 219143, -3505);
Engine.MoveTo(111378, 219122, -3568);
Engine.MoveTo(111394, 219405, -3572);
end;
if User.InRange(110120, 219485, -3500, 500, 500) then begin
Engine.MoveTo(110120, 219485, -3500);
Engine.MoveTo(110185, 219105, -3505);
Engine.MoveTo(111377, 219091, -3569);
Engine.MoveTo(111390, 219387, -3572);
end;
if User.InRange(111380, 219063, -3538, 100, 500)then begin
Engine.MoveTo(111380, 219063, -3538);
Engine.MoveTo(111389, 219396, -3572);
end;
end;
begin // Giran
if User.InRange(81314, 149696, -3495, 250, 250) then begin // gabriele -> GK
Engine.MoveTo(81650, 149429, -3495);
Engine.MoveTo(82536, 149438, -3495);
Engine.MoveTo(82891, 149224, -3495);
Engine.MoveTo(83547, 148845, -3431);
Engine.MoveTo(83405, 147930, -3431);
end;
if User.InRange(84274, 143710, -3431, 300, 500) then begin // Martien -> GK
	Engine.MoveTo(84274, 143710, -3431);
	Engine.MoveTo(84035, 143837, -3431);
	Engine.MoveTo(83901, 147024, -3426);
	Engine.MoveTo(83691, 147919, -3431);
	Engine.MoveTo(83344, 147932, -3431);
end;
end;
begin // Oren:
if User.InRange(80156, 55749, -1581, 500, 500) then Engine.MoveTo(80848, 54642, -1519); // between Grocery/Warrior. -> West of Werehouse
if User.InRange(80848, 54642, -1519, 500, 500) then Engine.MoveTo(80997, 53511, -1586); // West of Warehouse -> North exit
if User.InRange(80434, 53769, -1581, 200, 500) then Engine.MoveTo(80997, 53511, -1586); // East of Weapon/Armor shop -> North exit
if User.InRange(80997, 53511, -1586, 500, 500) then Engine.MoveTo(82972, 53221, -1522); // North exit -> GK

if User.InRange(82246, 55686, -1546, 500, 500) then Engine.MoveTo(82388, 53741, -1517); // Sauth exit -> Pet manager
if User.InRange(82388, 53741, -1517, 500, 500) then Engine.MoveTo(82966, 53229, -1522); // Pet manager -> GK
end;
begin // Hunter:
if User.InRange(119777, 75347, -2365, 500, 500) // orc 
then Engine.MoveTo(119614, 75970, -2301);       //-> d.elf

if User.InRange(118441, 78328, -2202, 500, 500) // magic guild
then Engine.MoveTo(117763, 79054, -2289);         //-> midway to sauth bridge from warrior

if User.InRange(117763, 79054, -2289, 300, 500) //midway to sauth bridge from warrior
or User.InRange(116166, 79091, -2417, 300, 500)  //extra
then Engine.MoveTo(117024, 79043, -2289);      //-> Sauth bridge top

if User.InRange(117024, 79043, -2289, 250, 500) // Sauth bridge top
or User.InRange(115074, 77754, -2703, 600, 500)  // west exit
then Engine.MoveTo(116078, 77531, -2729);       //-> Sauth bridge bottom

if User.InRange(119161, 77148, -2301, 300, 500) // warrior guild
or User.InRange(119614, 75970, -2301, 500, 500) // d.elf
or User.InRange(120238, 76906, -2169, 300, 200) // North bridge top TOP
then Engine.MoveTo(119779, 76665, -2300);       //-> North bridge top

if User.InRange(119779, 76665, -2300, 300, 500) // North bridge top
or User.InRange(118224, 74580, -2522, 500, 500) // North gate
then Engine.MoveTo(118012, 76101, -2720);       //-> North bidge bottom

if User.InRange(118012, 76101, -2720, 400, 400) // North bridge bottom
or User.InRange(115841, 75288, -2625, 800, 300) // prie dawn
or User.InRange(116078, 77531, -2729, 300, 500)  // Sauth bridge bottom
or User.InRange(116596, 76159, -2724, 300, 500)
then Engine.MoveTo(116888, 76806, -2744);       //-> salia gk

if User.InRange(116888, 76806, -2744, 300, 300)    // salia gk
then Engine.MoveTo(117107, 76911, -2722);       //-> GK
end;
begin // Aden:
if User.InRange(147736, 26360, -2136, 250, 500) then begin // NPC Talien -> GK
Engine.MoveTo(147243, 25802, -2039);
end;
if User.InRange(144095, 23597, -2146, 300, 500) then begin
Engine.MoveTo(144136, 23942, -2146);
Engine.MoveTo(144948, 23938, -2167);
Engine.MoveTo(145011, 24148, -2167);
end;

if User.InRange(147464, 21058, -2135, 500, 400) then Engine.MoveTo(146290, 21196, -2167); // North exit -> North exit step west 1
if User.InRange(146290, 21196, -2167, 500, 400) then Engine.MoveTo(145012, 22599, -2142); // North exit step west 1 -> North exit step west 2

if User.InRange(145009, 27651, -2290, 500, 400) // prie west susiaurejimo 
then begin
Engine.MoveTo(145006, 26392, -2295);
Engine.MoveTo(145026, 24230, -2167);
end;

if User.InRange(145012, 22599, -2142, 500, 400) // North exit step west 2 -> bottom of West stairs
or User.InRange(145031, 27669, -2290, 500, 400) // west susiaurejimas -> bottom of West stairs
or User.InRange(149896, 27602, -2263, 500, 400) // East susiaurejimas
then Engine.MoveTo(149773, 24025, -2162);     //-> bottom of West stairs

if User.InRange(149773, 24025, -2162, 500, 500) then Engine.MoveTo(148624, 24275, -2039); // bottom of East stairs -> top of East stairs
if User.InRange(145036, 24107, -2162, 500, 400) then Engine.MoveTo(146290, 24251, -2039); // bottom of West stairs -> top of West stairs
if User.InRange(146290, 24251, -2039, 500, 400) then Engine.MoveTo(146387, 25221, -2034); // top of West stairs -> prie gk uz kampo
if User.InRange(148624, 24275, -2039, 500, 500) then Engine.MoveTo(148543, 25785, -2039); // top of East stairs -> east of gk
if User.InRange(147429, 27054, -2199, 500, 500) then Engine.MoveTo(147405, 25976, -2007); // bottom of Center stairs -> top of Center stairs


if User.InRange(146387, 25221, -2034, 500, 500) then Engine.MoveTo(146297, 25760, -2039); // prie gk uz kampo -> west of gk

if User.InRange(148543, 25785, -2039, 500, 500) // east of gk -> GK
or User.InRange(147405, 25976, -2007, 500, 500) // top of Center stairs -> GK
or User.InRange(146297, 25760, -2039, 250, 500) // west of gk 
or User.InRange(146591, 25772, -2021, 250, 500) // salia salia gk
then  Engine.MoveTo(146748, 25771, -2039);    //-> GK
end;
begin // Rune:
if User.InRange(38545, -48177, 902, 3000, 200) then // Temple to Temple GK and port.
begin
Engine.MoveTo(38444, -48098, 870);
Engine.MoveTo(38231, -48071, 870);  

Engine.SetTarget(31698); Delay(700);
Engine.MoveToTarget(-50); 
Engine.DlgOpen(); Delay(700);
Engine.DlgSel('Teleport'); Delay(700);
Engine.DlgSel(1); Delay(3000);
end;
if User.InRange(43893, -50600, -791, 250, 500) then Engine.MoveTo(43874, -49373, -823); // North of GK far -> North of GK midway
if User.InRange(37377, -48234,-1174, 250, 500) then Engine.MoveTo(38334, -48231,-1179); // West of GK far -> guild GK
if User.InRange(38338, -48084, -1148, 100, 300) then Engine.MoveTo(38334, -48231,-1179); // guild GK close -> guild GK
if User.InRange(40067, -49975, -300, 250, 500) then Engine.MoveTo(40233, -46708, -378); // Nort of up the hill 2 -> Nort of up the hill
if User.InRange(40048, -46525, -332, 150, 500) then Engine.MoveTo(40233, -46708, -378); // Nort of up the hill 3 -> Nort of up the hill
if User.InRange(38334, -48231,-1179, 250, 500) then Engine.MoveTo(40326, -48224, -800); // guild GK -> up the hill
if User.InRange(40233, -46708, -378, 450, 500) then Engine.MoveTo(40326, -48224, -800); // North of up the hill -> up the hill
if User.InRange(40326, -48224, -800, 250, 500) then Engine.MoveTo(40796, -48214, -769); // up the hill -> West of GK, further end of bridge
if User.InRange(40796, -48214, -769, 250, 500) then Engine.MoveTo(43888, -48319, -792); // West of GK, further end of bridge -> North of GK very close
if User.InRange(43874, -49373, -823, 250, 500) then Engine.MoveTo(43888, -48319, -792); // North of GK midway -> North of GK very close
if User.InRange(45864, -48106, -791, 250, 500) then Engine.MoveTo(43888, -48319, -792); // East of GK, far -> North of GK very close
if User.InRange(43888, -48319, -792, 250, 500) then Engine.MoveTo(43820, -47690, -823); // North of GK very close -> GK
end;
begin // Goddard:
if User.InRange(147934, -55429, -2733, 150, 150) then begin // stuck near of gk
Engine.MoveTo(147934, -55429, -2733);
Engine.MoveTo(147937, -55476, -2759);
Engine.MoveTo(148083, -55421, -2759);
Engine.MoveTo(148088, -55304, -2728);
Engine.MoveTo(147982, -55205, -2758);
end;
if User.InRange(147933, -55371, -2757,250, 500) then Engine.MoveTo(147963, -55282, -2759);
end;
begin // Shutgart:
if User.InRange(84489, -143528, -1562, 400, 400) then Engine.MoveTo(84544, -142348, -1567); // west far -> west midway
if User.InRange(84544, -142348, -1567, 400, 400) then Engine.MoveTo(85041, -141710, -1567); // west midway -> west stairs bottom
if User.InRange(85041, -141710, -1567, 400, 400) then Engine.MoveTo(85864, -142308, -1366); // west stairs bottom -> west stairs top
if User.InRange(85864, -142308, -1366, 400, 400) then Engine.MoveTo(87167, -142708, -1359); // west stairs top -> kaireje prie pakylos
if User.InRange(87438, -140209, -1536, 500, 500) then Engine.MoveTo(87360, -141465, -1366); // center stairs bottom -> center stairs top
if User.InRange(87360, -141465, -1366, 500, 500) then Engine.MoveTo(87195, -143132, -1319); // center stairs top -> kaireje prie pakylos
if User.InRange(87167, -142708, -1359, 400, 400) then Engine.MoveTo(87195, -143132, -1319); // kaireje prie pakylos -> prie gk
if User.InRange(87195, -143132, -1319, 300, 150) // prie gk
or User.InRange(87362, -143280, -1290, 250, 500) // tp zona
then Engine.MoveTo(87105, -143443, -1318);     //-> gk
end;
end;

begin // Result
  Result := identify_gk;
  if(Result = '') then
  begin
    mov_unstuck();
    Result := fRunToGK();
  end;
  end;
end;
