local T, C, L = Tukui:unpack()

----------------------------------------------------------------
-- Dispel Announce by Foof
----------------------------------------------------------------
if (not C.Dispels.Enable) then return end

local band = bit.band
local COMBATLOG_OBJECT_AFFILIATION_MINE = COMBATLOG_OBJECT_AFFILIATION_MINE     -- 0x00000001

local ChatType = "SAY"
-- list of spell to announce when dispeled
local SpellList = {
    -- testing
    [221395] = true,            -- Poisonous Molt (Anax)
    [219153] = true,            -- Fel Might (Mal'Dreth the Corruptor)

    -- add more spellID here
}

local function Disple_OnEvent(self, event)
    local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags,
    sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID,
    spellName, spellSchool, extraSpellID, extraSpellName, extraSchool,
    auraType = CombatLogGetCurrentEventInfo()

    if (band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= COMBATLOG_OBJECT_AFFILIATION_MINE or sourceGUID ~= UnitGUID("player")) then return end

    if (SpellList[extraSpellID]) then
        local extraSpellLink = GetSpellLink(extraSpellID)

        if (eventType == "SPELL_DISPEL") then
            if (C.Dispels.SpellLink) then
                SendChatMessage("<< " .. destName .. " " .. extraSpellLink .. " dispeled!>>", ChatType)
            else
                SendChatMessage("<< " .. destName .. " " .. extraSpellName .. " dispeled!>>", ChatType)
            end
        elseif (eventType == "SPELL_STOLEN") then
            if (C.Dispels.SpellLink) then
                SendChatMessage("<< " .. destName .. " " .. extraSpellLink .. " stolen!>>", ChatType)
            else
                SendChatMessage("<< " .. destName .. " " .. extraSpellName .. " stolen!>>", ChatType)
            end
        elseif (eventType == "SPELL_DISPEL_FAILED") then
            if (C.Dispels.SpellLink) then
                SendChatMessage("<< " .. destName .. " " .. extraSpellLink .. " dispel FAILED!>>", ChatType)
            else
                SendChatMessage("<< " .. destName .. " " .. extraSpellName .. " dispel FAILED!>>", ChatType)
            end
        end
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", Disple_OnEvent)