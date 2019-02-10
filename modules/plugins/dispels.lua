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
    -- Mogu'shan Vaults: 
    [117961] = true,        -- Impervious Shield
    [117697] = true,        -- Shield of Darkness
    [117837] = true,        -- Delirious
    [117949] = true,        -- Closed Circuit
    -- Heart of Fear: 
    [122149] = true,        -- Quickening
    [124862] = true,        -- Visions of Demise
    -- Terrace of Endless Spring
    [117398] = true,        -- Lightning Prison
    [117235] = true,        -- Purified
    [123011] = true,        -- Terrorize
    -- Throne of Thunder
    -- Siege od Orgrimmar
    [143791] = true,        -- Corrosive Blood
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

-- scan dispel list for invalid spells
local function CheckSpellList()
    for spellID, value in pairs(DispellList) do
        local name = GetSpellInfo(spellID)
        if (not name) then
            print("|cffff330fDispel WARNING:|r", "Invalid spellID (" .. spellID .. ")")
            tremove(DispellList, spellID)
        end
    end
end

function f:PLAYER_LOGIN()
    chatType = C.Dispels.Chat or "SAY"
    playerGUID = UnitGUID("player")
    CheckSpellList()
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
    