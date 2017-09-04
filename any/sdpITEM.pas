unit sdpITEM;
interface
  function doEquip(vID: Integer): Boolean; Overload;
  function doEquip(vName: String): Boolean; Overload;
  function doEquip(vItem: TL2Item): Boolean; Overload;
implementation
  function doEquip(vID: Integer): Boolean; Overload;
    var aItem: TL2Item;
    begin
      if (Inventory.User.ByID(vID, aItem)) then doEquip(aItem);
    end;
  function doEquip(vName: String): Boolean; Overload;
    var aItem: TL2Item;
    begin
      if Inventory.User.ByName(vName, aItem) then doEquip(aItem)
      else Print('Could not find item ' + vName + '.');
    end;
  function doEquip(vItem: TL2Item): Boolean; Overload;
    begin
      if not vItem.Equipped then Engine.UseItem(vItem);
    end;
end.