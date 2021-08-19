# Macros

## Action Bar Swap

```lua
/changeactionbar [mod:ctrl] 2
/changeactionbar [nomod] 1
```

## Reset Challenge Mode

```lua
/script ResetChallengeMode()
```

## Extra Action Button 1

```lua
#showtooltip
/stopcasting
/click ExtraActionButton1
```

## Set Focus

```lua
/target Dragonmaw Tidal Shaman
/focus
/targetlasttarget
```

## Cast Spell By Player Name

```lua
#showtooltip
/cast [@Úrsão] Fear Ward
```

## Target and set Raid Icon

```lua
#showtooltip
/tar Lunarlight Bud
/tar Bloated Lootfly
/script SetRaidTarget("target", 4)
```

```lua
--[[ SKULL ]]--
/script SetRaidTarget("target", 8)
```

## 

```lua
#showtooltip
/cast [nomod] Void Shift
/cast [nomod] Healthstone
/cast [mod:ctrl] Void Tendrils
/cast [mod:ctrl] Psyfiend
/run SetMacroSpell ("Macro15", GetSpellInfo("Void Shift") or ("Void Tendrils") or ("Psyfiend"))
```

```lua
#showtooltip
/cast Void Tendrils
/cast Spectral Guise
/run SetMacroSpell ("Macro60", GetSpellInfo("Void Tendrils") or ("Spectral Guise"))
```

## Active Gear

```lua
/use 10
```

## Utility

```lua
/click CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
/click DropDownList1Button2
```

```lua
/click CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton
/click DropDownList1Button3
```

## Scholomance

```lua
/run frm = CreateFrame("PlayerModel");frm:SetPoint("BOTTOMRIGHT",nil,"BOTTOMRIGHT",-100,100);frm:SetHeight(600);frm:SetWidth(300);frm:RegisterEvent("PLAYER_TARGET_CHANGED");frm:SetScript("OnEvent",function(self,event,...) frm:SetUnit("target") end);
```

```lua
/run frm2 = CreateFrame("PlayerModel");frm2:SetPoint("BOTTOMRIGHT",frm,"BOTTOMLEFT",0,0);frm2:SetHeight(600);frm2:SetWidth(300);frm2:SetUnit("target")
```

```lua
/run frm:UnregisterEvent("PLAYER_TARGET_CHANGED");frm:Hide();frm2:Hide()
```
