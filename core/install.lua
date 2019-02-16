local T, C, L = Tukui:unpack()

----------------------------------------------------------------
-- Install
----------------------------------------------------------------
local function GetUIScale()
    local uiScale = 1
    -- calculates uiScale based on screen size
    if (C.Lua.uiScale == "auto") then
        uiScale = 768 / tonumber(string.match(T.Resolution, "%d+x(%d+)"))
        uiScale = T.RoundValue(uiScale, 5)
    
    -- uiScale set manually
    elseif (type(C.Lua.uiScale) == "number") then
        uiScale = C.Lua.uiScale
    end
    return uiScale
end

-- configure default console variables.
local function SetVariables()
    if (not C.Lua.Setup) then return end

    -- System

        -- Advanced
        if (C.Lua.uiScale) then
            SetCVar("uiScale", GetUIScale())
        end
        
        -- Sound
        SetCVar("Sound_EnableAllSound", C.Lua.Mute and 0 or 1)      -- enables all sounds
        SetCVar("Sound_MasterVolume", 0.25)                         -- set master volume (0.0 to 1.0)
        SetCVar("Sound_EnableSFX", 1)                               -- enables sound effects
        SetCVar("Sound_SFXVolume", 0.20)                            -- sound effects volume (default = 1.0)
        SetCVar("Sound_EnableMusic", 1)                             -- enables music sounds
        SetCVar("Sound_MusicVolume", 0.20)                          -- set music volume (default = 0.4)
        SetCVar("Sound_EnableAmbience", 1)                          -- enables ambience sounds
        SetCVar("Sound_AmbienceVolume", 0.35)                       -- ambience volume (default = 0.6)
        SetCVar("Sound_EnableDialog", 1)                            -- enables dialog volume
        SetCVar("Sound_DialogVolume", 0.50)                         -- dialog volume (default 1.0)
        
        -- Chat
        SetCVar("ChatAmbienceVolume", 0.3)                          -- ambience volume (default = 0.3)
        SetCVar("ChatMusicVolume", 0.3)                             -- music volume (default = 0.3)
        SetCVar("ChatSoundVolume", 0.4)                             -- sound volume (default = 0.4)
    
    -- General
    SetCVar("deselectOnClick", 1)                                   -- clear the target when clicking on terrain
    SetCVar("autoDismount", 1)                                      -- enables automatically dismount when needed
	SetCVar("autoDismountFlying", 1)                                -- enables automatically dismount before casting while flying
	SetCVar("showTutorials", 0)                                     -- enables tutorials.
    SetCVar("autoLootDefault", 1)                                   -- automatically loot items when the loot window opens
    
    -- Social
    SetCVar("chatBubbles", 1)                                       -- show in-game chat bubbles
	SetCVar("chatBubblesParty", 0)                                  -- show in-game party chat bubbles
    SetCVar("guildMemberNotify", 0)                                 -- enables notification when guild members log on/off (default 1)
    
    -- Names
	SetCVar("UnitNameEnemyGuardianName", 1)                         -- default = 1
    SetCVar("UnitNameEnemyMinionName", 1)                           -- default = 1
    SetCVar("UnitNameEnemyPetName", 1)                              -- default = 1
    SetCVar("UnitNameEnemyPlayerName", 1)                           -- default = 1
    SetCVar("UnitNameEnemyTotemName", 1)                            -- default = 1
    SetCVar("UnitNameForceHideMinus", 0)                            -- default = 0
    SetCVar("UnitNameFriendlyGuardianName", 0)                      -- default = 1
    SetCVar("UnitNameFriendlyMinionName", 0)                        -- default = 1
    SetCVar("UnitNameFriendlyPetName", 0)                           -- default = 1
    SetCVar("UnitNameFriendlyPlayerName", 0)                        -- default = 1
    SetCVar("UnitNameFriendlySpecialNPCName", 0)                    -- default = 1
    SetCVar("UnitNameFriendlyTotemName", 0)                         -- default = 1
    SetCVar("UnitNameGuildTitle", 0)                                -- default = 1
    SetCVar("UnitNameHostleNPC", 1)                                 -- default = 1
    SetCVar("UnitNameInteractiveNPC", 1)                            -- default = 1
    SetCVar("UnitNameNonCombatCreatureName", 0)                     -- default = 0
    SetCVar("UnitNameNPC", 0)                                       -- default = 0
    SetCVar("UnitNameOwn", 0)                                       -- default = 0
    SetCVar("UnitNamePlayerGuild", 0)                               -- default = 1
    SetCVar("UnitNamePlayerPVPTitle", 0)                            -- default = 1
    
    -- Nameplates
	SetCVar("nameplateMotion", 0)
    SetCVar("nameplateShowAll", 1)
    SetCVar("nameplateShowDebuffsOnFriendly", 0)
    SetCVar("nameplateShowEnemies", 1)
    SetCVar("nameplateShowEnemyGuardians", 0)
    SetCVar("nameplateShowEnemyMinions", 0)
    SetCVar("nameplateShowEnemyMinus", 0)
    SetCVar("nameplateShowEnemyPets", 0)
    SetCVar("nameplateShowEnemyTotems", 0)
    SetCVar("nameplateShowFriendlyGuardians", 0)
    SetCVar("nameplateShowFriendlyMinions", 0)
    SetCVar("nameplateShowFriendlyNPCs", 0)
    SetCVar("nameplateShowFriendlyPets", 0)
    SetCVar("nameplateShowFriendlyTotems", 0)
    SetCVar("nameplateShowFriends", 0)
    SetCVar("nameplateShowOnlyNames", 0)
    SetCVar("nameplateShowSelf", 0)

    -- Camera
    SetCVar("cameraView", 1)                                        -- stores the last saved camera position the camera was in. (default = 0)
    SetCVar("cameraSmoothStyle", 0)                                 -- sets the automatic camera adjustment/following style. (default = 4)
	SetCVar("cameraSmoothTrackingStyle", 0)
    SetCVar("cameraDistanceMaxZoomFactor", 2.6)                     -- sets the factor by which maximum camera distance (equals to 15) is multiplied. (cannot exceed 39 yards, default = 1.9)

    -- ActionBars
    if (C.ActionBars.Enable) then
        SetActionBarToggles(1, 1, 1, 1, 1)                          -- enable all extra action bars.
    end

    LuaUIData[GetRealmName()][UnitName("player")].InstallDone = true
end

-- initialize saved variables
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
    if (addon ~= "LuaUI") then return end

    local Name = UnitName("player")
    local Realm = GetRealmName()

    if (not LuaUIData) then
        LuaUIData = {}
    end

    if (not LuaUIData[Realm]) then
        LuaUIData[Realm] = {}
    end

    if (not LuaUIData[Realm][Name]) then
        LuaUIData[Realm][Name] = {}
    end

    if (LuaUIDataPerChar) then
        LuaUIData[Realm][Name] = LuaUIDataPerChar
        LuaUIDataPerChar = nil
    end

    local IsInstalled = LuaUIData[Realm][Name].InstallDone

    -- check if LuaUI was already installed
    if (not IsInstalled) then
        local Data = LuaUIData[Realm][Name]

        -- define visible actionbars
        Data["HideBar2"] = false
        Data["HideBar3"] = false
        Data["HideBar4"] = false
        Data["HideBar5"] = true
        Data["HideBar6"] = true

        SetVariables()
    end

    self:UnregisterEvent("ADDON_LOADED")
end)