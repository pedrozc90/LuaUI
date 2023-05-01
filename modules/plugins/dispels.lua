local T, C, L = Tukui:unpack()

----------------------------------------------------------------
-- Dispel Announce by Foof
----------------------------------------------------------------
if (not C.Dispels.Enable) then return end

local band = bit.band
local format = string.format
local tremove = table.remove
local COMBATLOG_OBJECT_AFFILIATION_MINE = COMBATLOG_OBJECT_AFFILIATION_MINE     -- 0x00000001

local CombatEvents = {
    SPELL_DISPEL = true,
    SPELL_STOLEN = true,
    SPELL_DISPEL_FAILED = true
}

-- list of spell to announce when dispeled
local DispellList = {}

-- Mists of Pandaria
if (T.Interface >= 50000) then
    -- Temple of the Jade Serpent
    DispellList[106113] = true                  -- Touch of Nothingness

    -- Mogu'shan Vaults
    DispellList[117961] = true                  -- Impervious Shield
    DispellList[117697] = true                  -- Shield of Darkness
    DispellList[117837] = true                  -- Delirious
    DispellList[117949] = true                  -- Closed Circuit

    -- Heart of Fear
    DispellList[122149] = true                  -- Quickening
    DispellList[124862] = true                  -- Visions of Demise
    
    -- Terrace of Endless Spring
    DispellList[117398] = true                  -- Lightning Prison
    DispellList[117235] = true                  -- Purified
    DispellList[123011] = true                  -- Terrorize
    
    -- Throne of Thunder
    
    -- Siege of Orgrimmar
    DispellList[143791] = true                  -- Corrosive Blood
end

-- Dragonflight
if (T.Interface >= 100000) then
    -- Algeth'ar Academy
    DispellList[389033] = true                  -- Lasher Toxin

    -- Brackenhide Hollow

    -- Halls of Infusion

    -- Neltharus

    -- Ruby Life Pools
    DispellList[373589] = true                  -- Primal Chill
    DispellList[372749] = true                  -- Ice Shield

    -- The Azure Vault

    -- The Nokhud Offensive
    DispellList[376827] = true                  -- Conductive Strike

    -- Uldaman: Legacy of Tyr
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event, ...)
    -- call one of the event handlers
    if (not self[event]) then return end
    self[event](self, ...)
end)

-- scan dispel list for invalid spells
function f:ValidateDispellList()
    for spellID, _ in pairs(DispellList) do
        local name = GetSpellInfo(spellID)
        if (not name) then
            print("|cffff330fDispel WARNING:|r", "Invalid spellID (" .. spellID .. ")")
            tremove(DispellList, spellID)
        end
    end
end

function f:PLAYER_LOGIN()
    self.unit = "player"
    self.guid = UnitGUID(self.unit)
    self.chatType = C.Dispels.Chat or "SAY"
    self:ValidateDispellList()
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function f:COMBAT_LOG_EVENT_UNFILTERED()
    local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags,
        destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()

    -- filter combat events type
    if (not CombatEvents[eventType]) then return end

    -- filter casters, only player or belong to player
    if (band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= COMBATLOG_OBJECT_AFFILIATION_MINE) or (sourceGUID ~= self.guid) then return end

    local spellID, spellName, spellSchool, extraSpellID, extraSpellName, extraSchool,
        auraType = select(12, CombatLogGetCurrentEventInfo())

    if (DispellList[spellID]) then
        local extraSpellLink = GetSpellLink(extraSpellID)
        if (eventType == "SPELL_DISPEL") then
            self:SendChatMessage("%s %s dispeled!", destName, extraSpellLink)
        elseif (eventType == "SPELL_STOLEN") then
            self:SendChatMessage("%s's %s stolen!", destName, extraSpellLink)
        elseif (eventType == "SPELL_DISPEL_FAILED") then
            self:SendChatMessage("%s's %s dispel FAILED!", destName, extraSpellLink)
        end
    end
end 

function f:SendChatMessage(fmt, ...)
    local text = format(fmt, ...)
    SendChatMessage(text, self.chatType)
end
