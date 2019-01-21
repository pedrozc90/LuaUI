local T, C, L = Tukui:unpack()

----------------------------------------------------------------
-- Spell Announce
----------------------------------------------------------------
if (not C.SpellAnnounce.Enable) then return end

local chatType = "SAY"
local playerName, playerGUID
local format = string.format

local COMBAT_EVENTS = {
    SPELL_CAST_SUCCESS = true,
    SPELL_CAST_FAILED = true,
    SPELL_AURA_APPLIED = true,
    SPELL_AURA_REMOVED = true,
    SPELL_SUMMON = true,
    SPELL_HEAL = true,
    UNIT_DESTROYED = true,
    UNIT_DIED = true,
}

local OnEvent = function(self, event)
    local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags,
    sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID,
    spellName, spellSchool, amount, overkill, school, resisted, blocked,
    absorbed, critical, glancing, crushing = CombatLogGetCurrentEventInfo()

    -- check if event has been set
    if (not COMBAT_EVENTS[eventType]) then return end

    -- code
end

local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", OnEvent)