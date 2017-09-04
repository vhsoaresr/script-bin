Unit sdpRADAR;
Interface
procedure labelPlayers();
Implementation
Uses sdpSTRINGs;
procedure labelPlayers(); 
  var q1,q2: Integer; aClass: Integer; skill_name: String; groupIgnore,group1, group2, group3, group4, group5: Array of String;
  begin
    groupIgnore := ['Arcane Power', 'Battle Heal', 'Body To Mind', 'Poison', 'Bleed', 'Aura Burn', 'Blaze', 'Gift of Seraphim', 'Bomb', 'Death Bomb', 'Might', 'Hex', 'Soul Cry', 'War Cry', 'Power Strike', 'Vicious Stance', 'War Frenzy', 'Focus Skill Mastery', 'Accuracy', 'Switch', 'Trick', 'Focus Attack', 'Fell Swoop', 'Braveheart', 'Spirit of Sagittarius', 'Blessing of Sagittarius', 'Dark Form', 'Ultimate Evasion', 'Sonic Blaster', 'Eye of Slayer', 'Eye of Hunter', 'Detect Dragon Weakness', 'Detect Animal Weakness', 'Detect Beast Weakness', 'Detect Plant Weakness', 'Detect Insect Weakness', 'Focus Skills Mastery', 'Mortal Blow', 'Dash', 'Summon Treasure Key', 'Earthquake', 'Battle Roar', 'Hammer Crush', 'Scroll of Escape', 'Last Judgment'
    , 'Nectar', 'Major Healing Potion', 'CP Potion', 'Greater CP Potion'
    , 'Soulshot (No-grade)', 'Soulshot (D-grade)', 'Soulshot (C-grade)', 'Soulshot (B-grade)', 'Soulshot (A-grade)', 'Soulshot (S-grade)'
    , 'Spiritshot (No-grade)', 'Spiritshot (D-grade)', 'Spiritshot (C-grade)', 'Spiritshot (B-grade)', 'Spiritshot (A-grade)', 'Spiritshot (S-grade)', 'Blessed Spiritshot (No-grade)', 'Blessed Spiritshot (D-grade)', 'Blessed Spiritshot (C-grade)', 'Blessed Spiritshot (B-grade)', 'Blessed Spiritshot (A-grade)', 'Blessed Spiritshot (S-grade)'
    , 'Scroll: Recovery (No-grade)', 'Scroll: Recovery (D-grade)', 'Scroll: Recovery (C-grade)', 'Scroll: Recovery (B-grade)', 'Scroll: Recovery (A-grade)', 'Scroll: Recovery (S-grade)'];
    group1 := ['Ice Vortex', 'Surrender to Water', 'Hydro Blast', 'Light Vortex', 'Solar Flare', 'Frost Wall', 'Aqua Splash', 'Aura Bolt', 'Ice Dagger', 'Frost Bolt', 'Surrender to Fire', 'Prominence', 'Fire Vortex', 'Blazing Circle', 'Rain of Fire', 'Wind Vortex', 'Surrender to Wind', 'Hurricane', 'Tempest', 'Curse Gloom', 'Mass Warrior Bane', 'Mass Mage Bane', 'Curse of Abyss', 'Mass Curse Fear', 'Curse of Doom', 'Anchor', 'Silence', 'Curse Weaknesss', 'Aura Flare', 'Aura Flash', 'Vampiric Claw', 'Death Spike', 'Dark Vortex'];
    group2 := ['Greater Battle Heal', 'Major Group Heal', 'Body of Avatar', 'Balance Life', 'Prayer', 'Major Heal', 'Might of Heaven', 'Turn Undead'];
    group3 := ['Seal of Suspension', 'Pa''agrio''s Heart', 'Seal of Despair', 'Seal of Silence', 'Seal of Binding', 'Seal of Slow', 'Pa''agrio''s Honor', 'Ritual of Life', 'Pa''agrio''s Wisdom', 'Pa''agrio''s Soul', 'Pa''agrio''s Rage', 'Pa''agrio''s Haste', 'Pa''agrio''s Glory', 'Pa''agrio''s Fist', 'Pa''agrio''s Blessing', 'Soul Guard','Stun Blast', 'Stun Stomp', 'Thunder Storm', 'Provoke', 'Howl', 'Steal Essence'];
    group4 := [''];
    group5 := ['Noblesse Blessing'];
    
    while true do begin
      aClass := 0;
      Case Engine.WaitAction([laCast], q1, q2) of 
        laCast:
        begin
          skill_name := TL2Live(q1).Cast.name;
          if (is_in(skill_name, group1)) then 
          begin
            aClass := 1;
          end else
            if (is_in(skill_name, group2)) then 
          begin
            aClass := 2;
          end else 
            if (is_in(skill_name, group3)) then 
          begin
            aClass := 3;
          end else 
            if (is_in(skill_name, group4)) then 
          begin
            aClass := 4;
          end else 
            if (is_in(skill_name, group5)) then 
          begin
            aClass := 5;
          end else 
          if not is_in(skill_name, groupIgnore) then 
          begin
            Print('[' + TL2Live(q1).name) + '] -> [' + TL2Live(q1).Target.Name + ']: ' + TL2Live(q1).Cast.name + '(lvl:' + ToStr(TL2Live(q1).Cast.Level) + ')';
            //Continue;
          end;
          if (TL2Live(q1).GetVar <> aClass) and (aClass <> 0) then begin
            if (TL2Live(q1).GetVar <> 0) then 
              Print('Conflict with skill ' + TL2Live(q1).Cast.name + '. Same character being asigned to multiple groups.');
              Print('Assigning value ' + ToStr(aClass) + ' to ' + TL2Live(q1).Name + ' [' + skill_name + ']');
              TL2Live(q1).SetVar(aClass);
          end;
        end;
      end;
    end;  
  end;
end.