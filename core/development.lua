local T, C, L = Tukui:unpack()

----------------------------------------------------------------
-- Development (write anything here)
----------------------------------------------------------------
local CombatEvents = {
    SPELL_DAMAGE = true,
    SPELL_PERIODIC_DAMAGE = true,
    SPELL_HEAL = true,
    SPELL_PERIODIC_HEAL = true,
    SPELL_INTERRUPT = true,
    SPELL_DISPEL = true,
    SPELL_DISPEL_FAILED = true,
    SPELL_STOLEN = true,
    SPELL_AURA_APPLIED = true,
    SPELL_AURA_REMOVED = true,
    SPELL_CAST_START = true,
    SPELL_CAST_SUCCESS = true,
    SPELL_CAST_FAILED = true,
    SPELL_CREATE = true,
    SPELL_SUMMON = true,
    SPELL_RESURRECT = true,
}

local events = {}
function events:COMBAT_LOG_EVENT_UNFILTERED(self, ...)
    -- get 1st to 11th parameter
    local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags,
    destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()

    -- check combat event filter
    if (not CombatEvents[eventType]) then return end

    -- some spells return destName as nil if you don't have a target.
    if (not destName) then
        destGUID = sourceGUID
        destName = sourceName
        destFlags = sourceFlags
        destRaidFlags = sourceRaidFlags
    end

    -- spells casted by others are just important if destination is my character.
    if ((sourceGUID ~= playerGUID) and (destGUID ~= playerGUID)) then return end

    -- get 12th to 15th parameters
    local spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())
    local spellIcon = GetSpellTexture(spellID)
    local spellLink = GetSpellLink(spellID)

    -- print event information for testing
    T.Print(spellID, spellLink, eventType, sourceName, destName, select(15, CombatLogGetCurrentEventInfo()))

    if (eventType == "SPELL_DAMAGE") or (eventType == "SPELL_PERIODIC_DAMAGE") then
        local spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())
        local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffhand = select(15, CombatLogGetCurrentEventInfo())
    end

    if (eventType == "SPELL_HEAL") or (eventType == "SPELL_PERIODIC_HEAL") then
        local spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())
        local amount, overhealing, absorbed, critical = select(15, CombatLogGetCurrentEventInfo())
    end

    if (eventType == "SPELL_INTERRUPT") then
        local spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())
        local extraSpellID, extraSpellName, extraSpellSchool = select(15, CombatLogGetCurrentEventInfo())
    end

    if (eventType == "SPELL_DISPEL") then
        local spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())
        local extraSpellID, extraSpellName, extraSpellSchool, auraType = select(15, CombatLogGetCurrentEventInfo())
    end

    if (eventType == "SPELL_DISPEL_FAILED") then
        local spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())
        local extraSpellID, extraSpellName, extraSpellSchool = select(15, CombatLogGetCurrentEventInfo())
    end

    if (eventType == "SPELL_STOLEN") then
        local spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())
        local extraSpellID, extraSpellName, extraSpellSchool, auraType = select(15, CombatLogGetCurrentEventInfo())
    end

    if (eventType == "SPELL_AURA_APPLIED") then
        local spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())
        local auraType, amount = select(15, CombatLogGetCurrentEventInfo())
    end

    if (eventType == "SPELL_AURA_REMOVED") then
        local spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())
        local auraType, amount = select(15, CombatLogGetCurrentEventInfo())
    end

    if (eventType == "SPELL_CAST_START") then
        local spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())
    end

    if (eventType == "SPELL_CAST_SUCCESS") then
        local spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())
    end

    if (eventType == "SPELL_CAST_FAILED") then
        local spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())
        local failedType = select(15, CombatLogGetCurrentEventInfo())
    end

    if (eventType == "SPELL_CREATE") or
        (eventType == "SPELL_SUMMON") or
        (eventType == "SPELL_RESURRECT") then
        local spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())
    end
end

function events:PLAYER_LEAVING_WORLD(self, ...)
    -- handle PLAYER_LEAVING_WORLD here
    T.Debug("Development #2")
end

local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", function(self, event, ...)
    events[event](self, ...); -- call one of the functions above
end);