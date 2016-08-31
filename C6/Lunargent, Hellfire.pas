// Script crafts up all materials available for lunargent and helfire oil craft.
// Script made to work and is tested only on l2Neo server.
// It may or may not work in other servers with same mixing urn's dialogs.
var
vDelay: Integer = 800;
item: TL2Item;

function countReagents(vWhat: String): Integer; begin
	case vWhat of
		'Moonstone Shard': Inventory.User.ByID(6013, item);
		'Volcanic Ash': Inventory.User.ByID(6018, item);
		'Quicksilver': Inventory.User.ByID(6019, item);
		'Lava Stone': Inventory.User.ByID(6012, item);
		'Demon Blood': Inventory.User.ByID(6015, item);
		'Blood Root': Inventory.User.ByID(6017, item);
		'Sulfur': Inventory.User.ByID(6020, item);

		'Moon Dust': Inventory.User.ByID(6023, item);
		'Magma Dust': Inventory.User.ByID(6022, item);
		'Demonplasm': Inventory.User.ByID(6025, item);

		'Fire Essence': Inventory.User.ByID(6028, item);
		'Demonic Essence': Inventory.User.ByID(6031, item);
		'Lunargent': Inventory.User.ByID(6029, item);

		'Helfire Oil': Inventory.User.ByID(6033, item);
	else print(vWhat + ' not supported in countReagents');
  end;
  Result := item.Count();
end;
function hasEnoughFor(vWhat: String): Boolean; begin
	case vWhat of
		'Moon Dust': Result := (countReagents('Moonstone Shard') >= 10) and (countReagents('Volcanic Ash') >= 1);
		'Magma Dust': Result := (countReagents('Lava Stone') >= 10) and (countReagents('Volcanic Ash') >= 1);
		'Demonplasm': Result := (countReagents('Demon Blood') >= 10) and (countReagents('Blood Root') >= 1);
		'Fire Essence': Result := (countReagents('Magma Dust') >= 10) and (countReagents('Sulfur') >= 1);
		'Demonic Essence': Result := (countReagents('Demonplasm') >= 10) and (countReagents('Sulfur') >= 1);
		'Lunargent': Result := (countReagents('Moon Dust') >= 10) and (countReagents('Quicksilver') >= 1);
		'Helfire Oil': Result := (countReagents('Fire Essence') >= 1) and (countReagents('Demonic Essence') >= 1);
	end;
	if not Result then print('Not enough to craft ' + vWhat + '.');
end;
function mix(vWhat: String): Boolean; begin
	case vWhat of
		'Helfire Oil': begin
			Engine.ByPassToServer('Quest 373_SupplierOfReagents U_I_Insert'); delay(vDelay);// Insert1
			Engine.ByPassToServer('Quest 373_SupplierOfReagents x_1_I_6028'); delay(vDelay);// 10x MS
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.

			Engine.ByPassToServer('Quest 373_SupplierOfReagents U_C_Insert'); delay(vDelay); // Insert2
			Engine.ByPassToServer('Quest 373_SupplierOfReagents x_1_C_6031'); delay(vDelay); // 1x Volcanic Ash
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.

			Engine.ByPassToServer('Quest 373_SupplierOfReagents 31149-5.htm'); delay(vDelay); // select temperature
			Engine.ByPassToServer('Quest 373_SupplierOfReagents tmp_1'); delay(vDelay); // tmp_1
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.

			Engine.ByPassToServer('Quest 373_SupplierOfReagents 31149-6.htm'); delay(vDelay); // Mix Ingredients
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.
		end;
		'Lunargent': begin
			Engine.ByPassToServer('Quest 373_SupplierOfReagents U_I_Insert'); delay(vDelay);// Insert1
			Engine.ByPassToServer('Quest 373_SupplierOfReagents x_2_I_6023'); delay(vDelay);// 10x MS
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.

			Engine.ByPassToServer('Quest 373_SupplierOfReagents U_C_Insert'); delay(vDelay); // Insert2
			Engine.ByPassToServer('Quest 373_SupplierOfReagents x_1_C_6019'); delay(vDelay); // 1x Volcanic Ash
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.

			Engine.ByPassToServer('Quest 373_SupplierOfReagents 31149-5.htm'); delay(vDelay); // select temperature
			Engine.ByPassToServer('Quest 373_SupplierOfReagents tmp_1'); delay(vDelay); // tmp_1
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.

			Engine.ByPassToServer('Quest 373_SupplierOfReagents 31149-6.htm'); delay(vDelay); // Mix Ingredients
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.
		end;
		'Demonic Essence': begin
			Engine.ByPassToServer('Quest 373_SupplierOfReagents U_I_Insert'); delay(vDelay);// Insert1
			Engine.ByPassToServer('Quest 373_SupplierOfReagents x_2_I_6025'); delay(vDelay);// 10x MS
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.

			Engine.ByPassToServer('Quest 373_SupplierOfReagents U_C_Insert'); delay(vDelay); // Insert2
			Engine.ByPassToServer('Quest 373_SupplierOfReagents x_1_C_6020'); delay(vDelay); // 1x Volcanic Ash
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.

			Engine.ByPassToServer('Quest 373_SupplierOfReagents 31149-5.htm'); delay(vDelay); // select temperature
			Engine.ByPassToServer('Quest 373_SupplierOfReagents tmp_1'); delay(vDelay); // tmp_1
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.

			Engine.ByPassToServer('Quest 373_SupplierOfReagents 31149-6.htm'); delay(vDelay); // Mix Ingredients
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.
		end;
		'Fire Essence': begin
			Engine.ByPassToServer('Quest 373_SupplierOfReagents U_I_Insert'); delay(vDelay);// Insert1
			Engine.ByPassToServer('Quest 373_SupplierOfReagents x_2_I_6022'); delay(vDelay);// 10x MS
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.

			Engine.ByPassToServer('Quest 373_SupplierOfReagents U_C_Insert'); delay(vDelay); // Insert2
			Engine.ByPassToServer('Quest 373_SupplierOfReagents x_1_C_6020'); delay(vDelay); // 1x Volcanic Ash
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.

			Engine.ByPassToServer('Quest 373_SupplierOfReagents 31149-5.htm'); delay(vDelay); // select temperature
			Engine.ByPassToServer('Quest 373_SupplierOfReagents tmp_1'); delay(vDelay); // tmp_1
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.

			Engine.ByPassToServer('Quest 373_SupplierOfReagents 31149-6.htm'); delay(vDelay); // Mix Ingredients
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.
		end;
		'Magma Dust': begin
			Engine.ByPassToServer('Quest 373_SupplierOfReagents U_I_Insert'); delay(vDelay);// Insert1
			Engine.ByPassToServer('Quest 373_SupplierOfReagents x_2_I_6012'); delay(vDelay);// 10x MS
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.

			Engine.ByPassToServer('Quest 373_SupplierOfReagents U_C_Insert'); delay(vDelay); // Insert2
			Engine.ByPassToServer('Quest 373_SupplierOfReagents x_1_C_6018'); delay(vDelay); // 1x Volcanic Ash
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.

			Engine.ByPassToServer('Quest 373_SupplierOfReagents 31149-5.htm'); delay(vDelay); // select temperature
			Engine.ByPassToServer('Quest 373_SupplierOfReagents tmp_1'); delay(vDelay); // tmp_1
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.

			Engine.ByPassToServer('Quest 373_SupplierOfReagents 31149-6.htm'); delay(vDelay); // Mix Ingredients
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.
		end;
		'Demonplasm': begin
			Engine.ByPassToServer('Quest 373_SupplierOfReagents U_I_Insert'); delay(vDelay);// Insert1
			Engine.ByPassToServer('Quest 373_SupplierOfReagents x_2_I_6015'); delay(vDelay);// 10x MS
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.

			Engine.ByPassToServer('Quest 373_SupplierOfReagents U_C_Insert'); delay(vDelay); // Insert2
			Engine.ByPassToServer('Quest 373_SupplierOfReagents x_1_C_6017'); delay(vDelay); // 1x Volcanic Ash
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.

			Engine.ByPassToServer('Quest 373_SupplierOfReagents 31149-5.htm'); delay(vDelay); // select temperature
			Engine.ByPassToServer('Quest 373_SupplierOfReagents tmp_1'); delay(vDelay); // tmp_1
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.

			Engine.ByPassToServer('Quest 373_SupplierOfReagents 31149-6.htm'); delay(vDelay); // Mix Ingredients
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.
		end;
	  	'Moon Dust': begin
			Engine.ByPassToServer('Quest 373_SupplierOfReagents U_I_Insert'); delay(vDelay);// Insert1
			Engine.ByPassToServer('Quest 373_SupplierOfReagents x_2_I_6013'); delay(vDelay);// 10x MS
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.

			Engine.ByPassToServer('Quest 373_SupplierOfReagents U_C_Insert'); delay(vDelay); // Insert2
			Engine.ByPassToServer('Quest 373_SupplierOfReagents x_1_C_6018'); delay(vDelay); // 1x Volcanic Ash
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.

			Engine.ByPassToServer('Quest 373_SupplierOfReagents 31149-5.htm'); delay(vDelay); // select temperature
			Engine.ByPassToServer('Quest 373_SupplierOfReagents tmp_1'); delay(vDelay); // tmp_1
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.

			Engine.ByPassToServer('Quest 373_SupplierOfReagents 31149-6.htm'); delay(vDelay); // Mix Ingredients
			Engine.ByPassToServer('Quest 373_SupplierOfReagents urn'); delay(vDelay);// back to urn.
	  	end;  
	end;
end;
begin
  while hasEnoughFor('Moon Dust') do mix('Moon Dust');
  while hasEnoughFor('Lunargent') do mix('Lunargent');

  while hasEnoughFor('Magma Dust') do mix('Magma Dust');
  while hasEnoughFor('Demonplasm') do mix('Demonplasm');

  while hasEnoughFor('Fire Essence') do mix('Fire Essence');
  while hasEnoughFor('Demonic Essence') do mix('Demonic Essence');

  while hasEnoughFor('Helfire Oil') do mix('Helfire Oil');
end.
