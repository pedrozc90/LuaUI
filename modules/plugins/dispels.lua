local T, C, L = Tukui:unpack()

----------------------------------------------------------------
-- Dispel Announce by Foof
----------------------------------------------------------------
if (not C.Dispels.Enable) then return end

local band = bit.band
local format = string.format
local COMBATLOG_OBJECT_AFFILIATION_MINE = COMBATLOG_OBJECT_AFFILIATION_MINE     -- 0x00000001

local chatType = nil
local playerGUID = nil

-- list of spell to announce when dispeled
local DispellList = {
    -- testing
    [221395] = true,            -- Poisonous Molt (Anax)
    [219153] = true,            -- Fel Might (Mal'Dreth the Corruptor)

    -- add more spellID here
}

local CombatEvents = {
    SPELL_DISPEL = true,
    SPELL_STOLEN = true,
    SPELL_DISPEL_FAILED = true,
}

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event, ...)
    -- callone of the function below
    self[event](self, ...)
end)

function f:PLAYER_LOGIN()
    chatType = C.Dispels.Chat or "SAY"
    playerGUID = UnitGUID("player")
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function f:COMBAT_LOG_EVENT_UNFILTERED()
    local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags,
    destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()

    -- filter combat events type
    if (not CombatEvents[eventType]) then return end

    -- filter casters, only player or belong to player
    if (band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= COMBATLOG_OBJECT_AFFILIATION_MINE) or (sourceGUID ~= playerGUID) then return end
    
    local spellID, spellName, spellSchool, extraSpellID, extraSpellName, extraSchool,
    auraType = select(12, CombatLogGetCurrentEventInfo())

    if (DispellList[spellID]) then
        local extraSpellLink = GetSpellLink(extraSpellID)

        if (eventType == "SPELL_DISPEL") then
            SendChatMessage(format("%s %s dispeled!", destName, extraSpellLink), chatType)
        elseif (eventType == "SPELL_STOLEN") then
            SendChatMessage(format("%s's %s stolen!", destName, extraSpellLink), chatType)
        elseif (eventType == "SPELL_DISPEL_FAILED") then
            SendChatMessage(format("%s's %s dispel FAILED!", destName, extraSpellLink), chatType)
        end
    end
end 
    