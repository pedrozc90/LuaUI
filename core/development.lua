local T, C, L = Tukui:unpack()

----------------------------------------------------------------
-- Development (write anything here)
----------------------------------------------------------------
local ICON_SIZE = 16
local playerGUID = UnitGUID("player")
local format = string.format

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

    UNIT_DIED = true,
    UNIT_DESTROYED = true,
}

-- text color based on spell school
local SpellSchoolColors = {
	[0]  = { 1., 1., 1. },		-- NONE
	[1]	 = { 1., 1., .0 },		-- PHYSICAL
	[2]  = { 1., .9, .5 },		-- HOLY
	[4]  = { 1., .5, .0 },		-- FIRE
	[8]  = { .3, 1., .3 },		-- NATURE
	[16] = { .5, 1., 1. },		-- FROST
	[32] = { .5, .5, 1. },		-- SHADOW
	[64] = { 1., .5, 1. },		-- ARCANE
}
----------------------------------------------------------------
-- Functions
----------------------------------------------------------------
local function UnitIsMine(unitFlags)
    return (CombatLog_Object_IsA(unitFlags, COMBATLOG_FILTER_ME) or
            CombatLog_Object_IsA(unitFlags, COMBATLOG_FILTER_MINE) or
            CombatLog_Object_IsA(unitFlags, COMBATLOG_FILTER_MY_PET))
end

-- create an escape sequence to insert icon texture into a string.
local function CreateIcon(texture, size, ...)
    local xoffset, yoffset, dimx, dimy, coordx1, coordx2, coordy1, coordy2 = ...
    if (not xoffset) then xoffset = 0 end
    if (not yoffset) then yoffset = 0 end
    if (not dimx) then dimx = 64 end
    if (not dimy) then dimy = 64 end
    if (not coordx1) then coordx1 = 5 end
    if (not coordx2) then coordx2 = 59 end
    if (not coordy1) then coordy1 = 5 end
    if (not coordy2) then coordy2 = 59 end
	local fmt = "|T%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d|t"
	return string.format(fmt, texture, size, size, xoffset, yoffset, dimx, dimy, coordx1, coordx2, coordy1, coordy2)
end

-- display message
local function Display(fmt, r, g, b, sourceName, eventType, destName, spellID, ...)
    local spellIcon = GetSpellTexture(spellID)
    local spellLink = GetSpellLink(spellID)
    local icon = CreateIcon(spellIcon, ICON_SIZE)
    local color = format("|cff%02x%02x%02x", 255 * r, 255 * g, 255 * b)
    local spell = format("%s %s (%d)", icon, spellLink, spellID)
    T.Print(color, format(fmt, sourceName, eventType, spell, destName), ...)
end

----------------------------------------------------------------
-- Events
----------------------------------------------------------------
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
    if (not UnitIsMine(sourceFlags)) then return end

    -- get 12th to 15th parameters
    local spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())

    -- print event information for testing
    local r, g, b = unpack(T.Colors.class[T.MyClass])
    T.Debug(CombatLogGetCurrentEventInfo())
    if (spellID and type(spellID) == "number") then
        Display("%s %s %s on %s", r, g, b, sourceName, eventType, destName, spellID)
    end

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