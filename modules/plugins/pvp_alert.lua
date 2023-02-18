local T, C, L = Tukui:unpack()

----------------------------------------------------------------
-- PvP Alert
-- Author: Unknown
-- Editor: Luaerror
-- Reference: https://www.tukui.org/forum/viewtopic.php?f=10&t=3142 on January 23th, 2019
----------------------------------------------------------------
if (not C.PvPAlert.Enable) then return end

local SpellList = {
    -- Mage
    [118] = true,                       -- Polymorph: Sheep
    [28271] = true,                     -- Polymorph: Turtle
    [28272] = true,                     -- Polymorph: Pig
    [61305] = true,                     -- Polymorph: Black Cat
    [61721] = true,                     -- Polymorph: Rabbit
    [61780] = true,                     -- Polymorph: Turkey
    [126819] = true,                    -- Polymorph: Porcupine
    [161353] = true,                    -- Polymorph: Polar Bear Cub
    [161354] = true,                    -- Polymorph: Monkey
    [161355] = true,                    -- Polymorph: Penguin
    [161372] = true,                    -- Polymorph: Peacock
    [277787] = true,                    -- Polymorph: Direhorn
    [277792] = true,                    -- Polymorph: Bumblebee

    -- Shaman
    [51514] = true,                     -- Hex: Frog
    [210873] = true,                    -- Hex: Compy
    [211004] = true,                    -- Hex: Spider
    [211010] = true,                    -- Hex: Snake
    [211015] = true,                    -- Hex: Cockroach
    [269352] = true,                    -- Hex: Skeletal Hatchling
    [277778] = true,                    -- Hex: Zandalari Tendonripper
    [277784] = true,                    -- Hex: Wicker Mongrel

    -- Warlock
    [5782] = true, 			            -- Fear

    -- Druid
    [33786] = true, 		            -- Cyclone

    -- Paladin
    [20066] = true, 		            -- Repentance

    -- Priest
    [605] = true,                       -- Mind Control
    [9484] = true,                      -- Shackle Undead
    [32375] = true,                     -- Mass Dispel
}

local CombatEvents = {
SPELL_CAST_START = true,
SPELL_CAST_SUCCESS = true,
}

local playerGUID = nil
local chatType = nil
local Font, FontSize, FontStyle = C.Medias.Font, 18, "THINOUTLINE"
local format = string.format
local band = bit.band
local bor = bit.bor

local PARTY_MEMBER_MASK = bit.bor(COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_AFFILIATION_PARTY)
local ENEMY_PLAYER_MASK = bit.bor(COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_REACTION_HOSTILE)

----------------------------------------------------------------
-- Functions
----------------------------------------------------------------
-- compare unit flag mask
local function CombatLog_Mask(unitFlags, Mask)
    return (band(unitFlags, Mask) == Mask)
end

-- create/send alert message
local function Message(self, caster, target, template, spellID)
    local spellIcon = GetSpellTexture(spellID)
    local spellLink = GetSpellLink(spellID)

    if (caster) then caster = "|cffff0000" .. caster .. "|r" end
    if (target) then target = "|cff00ff00" .. target .. "|r" end

    local msg = format(template, caster, spell, nil, target)

    -- send message to message frame
    self:AddMessage(msg)

    -- send message to chat, if in group
    if (chatType) then
        SendChatMessage(msg, chatType)
    end
end

----------------------------------------------------------------
-- Events
----------------------------------------------------------------
local f = CreateFrame("MessageFrame", nil, UIParent)
f:SetPoint("LEFT")
f:SetPoint("RIGHT")
f:SetPoint("TOP", UIParent, "TOP", 0, -230)
f:SetHeight(1.5 * FontSize)
f:SetFrameStrata("HIGH")
f:SetFont(Font, FontSize, FontStyle)
f:SetInsertMode("TOP")
f:SetTimeVisible(1)
f:SetFadeDuration(3)

f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event, ...)
    -- call one of the event handlers
    if (not self[event]) then return end
    self[event](self, ...)
end)

function f:PLAYER_LOGIN()
    playerGUID = UnitGUID("player")
end

function f:PLAYER_ENTERING_WORLD()
    local inInstance, instanceType = IsInInstance()
    if (inInstance and (instanceType == "pvp" or instanceType == "arena")) then
        if (instanceType == "arena") then
            chatType = "ARENA"
        else
            if (IsInGroup(LE_PARTY_CATEGORY_HOME)) then
                chatType = "PARTY"
            else
                chatType = "SAY"
            end
        end
        self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    else
        self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    end
end

function f:COMBAT_LOG_EVENT_UNFILTERED()
    local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags,
    destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()

    -- filter combat events type
    if (not CombatEvents[eventType]) then return end

    -- check if caster is a hostile player
    if (not CombatLog_Mask(sourceFlags, ENEMY_PLAYER_MASK)) then return end

    -- check if target is a party member or player
    if (not CombatLog_Mask(destFlags, PARTY_MEMBER_MASK) or destGUID ~= playerGUID) then return end

    local spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())

    if (SpellList[spellID]) then
        local template = nil

        if (eventType == "SPELL_CAST_START") then
            if (sourceName and destName) then
                template = ACTION_SPELL_CAST_START_FULL_TEXT
            elseif (sourceName) then
                template = ACTION_SPELL_CAST_START_FULL_TEXT_NO_DEST
            elseif (destName) then
                template = ACTION_SPELL_CAST_START_FULL_TEXT_NO_SOURCE
            end
        elseif (eventType == "SPELL_CAST_SUCCESS") then
            if (sourceName and destName) then
                template = ACTION_SPELL_CAST_SUCCESS_FULL_TEXT
            elseif (sourceName) then
                template = ACTION_SPELL_CAST_SUCCESS_FULL_TEXT_NO_DEST
            elseif (destName) then
                template = ACTION_SPELL_CAST_SUCCESS_FULL_TEXT_NO_SOURCE
            end	
        end

        if (template) then
            -- format message
            Message(self, sourceName, destName, template, spellID)
        end
    end
end
