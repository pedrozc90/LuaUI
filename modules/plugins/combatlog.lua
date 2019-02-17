local T, C, L = Tukui:unpack()

----------------------------------------------------------------
-- CombatLog: prints combatlog events important to player
----------------------------------------------------------------
-- player info
local playerGUID = nil

-- import
local bor, band = bit.band, bit.bor
local format = string.format

-- string format
local STRING_HEX = "(0x%08x)"

-- tables
local CombatLogEnabled = false
local FilterCombatEvents = {
    SPELL_DAMAGE = true,
    SPELL_PERIODIC_DAMAGE = true,
    SPELL_HEAL = true,
    SPELL_PERIODIC_HEAL = true,
    SPELL_MISSED = true,
    SPELL_ABSORBED = true,
}

-- functions
local function Debug(...) print(format("|cff00FF96CombatLog:|r"), ...) end

local function Message(color, ...)
    local t = {}
    for k, v in pairs({ ... }) do
        if (type(v) == "string") then
            t[k] = T.RGBToHex(color[1], color[2], color[3]) .. v .. "|r"
        else
            t[k] = v
        end
        
    end
    Debug(unpack(t))
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
-- f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
-- f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

-- initialize plugin
function f:PLAYER_LOGIN(...)
    playerGUID = UnitGUID("player")
end

-- select a chat type based on instance/group
function f:PLAYER_ENTERING_WORLD(...)
    local chat = nil
    local inInstance, instanceType = IsInInstance()
    if (instanceType == "raid") and (IsInRaid()) then
        chat = "RAID"
    elseif (instanceType == "party") then
        if (IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
            chat = "INSTANCE_CHAT"
        elseif (IsInGroup()) then
            chat = "PARTY"
        end
    else
        chat = "SAY"
    end
end

function f:COMBAT_LOG_EVENT_UNFILTERED()
    local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags,
    destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()

    if (eventType:find("SPELL")) then

        local spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())

        -- check if caster is player or belongs to player
        local fromPlayer = CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_MINE)
        -- check if caster is player's pet/guardian
        local fromPet = CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_MY_PET)
        -- check if target is the player
        local toPlayer = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_ME)

        if (not fromPlayer) and (not fromPet) then return end

        -- if (FilterCombatEvents[eventType]) then return end

        color = { .93, .16, .08}
        if (sourceGUID == playerGUID) then
            color = { .61, 1., .0 }
        end

        Message(color, sourceName, format("(0x%08x)", sourceFlags), eventType,
        destName, format("(0x%08x)", destFlags), spellID, spellName, select(15, CombatLogGetCurrentEventInfo()))
    
    elseif (eventType:find("UNIT")) then

        local color = { .87, .92, .08 }

        Message(color, sourceName, STRING_HEX:format(sourceFlags), eventType,
        destName, STRING_HEX:format(destFlags), select(12, CombatLogGetCurrentEventInfo()))
    end
end

----------------------------------------------------------------
-- Slash Commands
----------------------------------------------------------------
SLASH_LUACOMBATLOG1 = "/log"
SlashCmdList["LUACOMBATLOG"] = function(msg)
    if (CombatLogEnabled) then
        Debug("CombatLog Disabled")
        f:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    else
        Debug("CombatLog Enabled")
        f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    end
end