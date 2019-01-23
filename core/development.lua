local T, C, L = Tukui:unpack()

local CombatLog = true
----------------------------------------------------------------
-- Development (write anything here)
----------------------------------------------------------------
if (not CombatLog) then return end

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

    -- UNIT_DIED = true,
    -- UNIT_DESTROYED = true,
    -- UNIT_DISSIPATES = true,
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

-- create/send alert message
local function Message(isPlayer, eventType, sourceName, destName, spellID, ...)
    local spellName = GetSpellInfo(spellID)
    local spellIcon = GetSpellTexture(spellID)
    local spellLink = GetSpellLink(spellID)

    local r, g, b
    if (isPlayer) then
        r, g, b = unpack(T.Colors.class[T.MyClass])
    else
        r, g, b = 1, 1, 1
    end

    local color = format("|cff%02x%02x%02x", 255 * r, 255 * r, 255 * b)

    eventType = color .. eventType .. "|r"
    sourceName = color .. sourceName .. "|r"
    destName = color .. destName .. "|r"
    spellName = color .. spellName .. "|r"

    if (isPlayer) then
        spellID = color .. spellID .. "|r"
    else
        spellID = "|cffff0000" .. spellID .. "|r"
    end

    T.Print(sourceName, eventType, spellName, "on", destName, spellID, spellLink)
end

----------------------------------------------------------------
-- Events
----------------------------------------------------------------
local f = CreateFrame("Frame")
-- f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event, ...)
    -- call one of the functions below
    self[event](self, ...);
end);

function f:PLAYER_LOGIN()
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function f:COMBAT_LOG_EVENT_UNFILTERED()
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
    if (not UnitIsMine(sourceFlags) and destGUID ~= playerGUID) then return end

    -- get 12th to 15th parameters
    local spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())
    local isPlayer = (sourceGUID == playerGUID)
    Message(isPlayer, eventType, sourceName, destName, spellID)

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

----------------------------------------------------------------
-- Slash Command
----------------------------------------------------------------
function f:Start()
    T.Print("Starting Spell Tracing ...")
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function f:Stop()
    T.Print("Spell Tracing Ended!")
    self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

local function SplitCmd(args)
    if (args:find("%s")) then
        return strsplit(" ", args)
    else
        return args
    end
end

SLASH_LUASLASHHANDLER1, LUASLASHHANDLER2 = "/dev", "/dev-spells"
SlashCmdList["LUASLASHHANDLER"] = function(cmd)
    local arg1, arg2 = SplitCmd(cmd)

    if (arg1 == "start") then
        f:Start()
    elseif (arg1 == "stop") then
        f:Stop()
    end
end
