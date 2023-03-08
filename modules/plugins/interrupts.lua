local T, C, L = Tukui:unpack()

----------------------------------------------------------------
-- Interrupt Announce
----------------------------------------------------------------
if (not C.Interrupts.Enable) then return end

local CombatLog_Object_IsA = CombatLog_Object_IsA
local COMBATLOG_FILTER_ME = COMBATLOG_FILTER_ME
local COMBATLOG_FILTER_MINE = COMBATLOG_FILTER_MINE
local COMBATLOG_FILTER_MY_PET = COMBATLOG_FILTER_MY_PET
local STRING_INTERRUPT = "Interrupted %s %s!"

-- variable to store selected chat channel
local chatType

-- variables used to prevent AoE spam interrupts
local lastTimestamp, lastSpellID = 0, nil

-- configure group messages
local chatChannels = {
    ["SAY"] = true,
    ["PARTY"] = true,
    ["RAID"] = true,
    ["RAID_WARNNING"] = false,
    ["INSTANCE_CHAT"] = false
}

-- create a possesion form by appending ('s) to the string, unless it ends
-- with s, x or z, in which only (') is added.
local function StringPossesion(s)
    if (s:sub(-1):find("[sxzSXZ]")) then
        return s .. "\'"
    end
    return s .. "\'s"
end

local Interrupt = CreateFrame("Frame")
Interrupt:RegisterEvent("PLAYER_LOGIN")
Interrupt:RegisterEvent("PLAYER_ENTERING_WORLD")
Interrupt:SetScript("OnEvent", function(self, event, ...)
    -- call one of the event handlers
    if (not self[event]) then return end
    self[event](self, ...)
end)

function Interrupt:PLAYER_LOGIN()
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    self.guid = UnitGUID("player")
end

function Interrupt:PLAYER_ENTERING_WORLD()
    local _, instanceType = IsInInstance()
    local inInstance, inGroup, inRaid = IsInGroup(LE_PARTY_CATEGORY_INSTANCE), IsInGroup(), IsInRaid()

    -- check group status
    if (instanceType == "raid") or (instanceType == "party") then
        if (inInstance) then
            chatType = "INSTANCE_CHAT"
        elseif (inRaid) then
            chatType = "RAID"
        elseif (inGroup) then
            chatType = "PARTY"
        else
            chatType = "SAY"
        end
    else
        chatType = "SAY"
    end

    -- check if channel is enable for announcing
    if (not chatChannels[chatType]) then
        chatType = "SAY"
    end
end

function Interrupt:COMBAT_LOG_EVENT_UNFILTERED()
    local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags,
        destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()

    -- check if event type was a spell interrupt
    if (eventType == "SPELL_INTERRUPT") then
        -- spell standard
        local spellID, spellName, spellSchool, extraSpellID, extraSpellName,
        extraSchool = select(12, CombatLogGetCurrentEventInfo())
        
        -- do not announce self interrputs (quake from mythic affixes)
        if (sourceGUID == destGUID and destGUID == self.guid) then return end

        -- prevents spam announcements
        if (spellID == lastSpellID) and (timestamp - lastTimestamp <= 1) then return end

        -- update last timestamp e spellID
        lastTimestamp, lastSpellID = timestamp, spellID

        -- check if source is the player or belong to player
        if (CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_ME) or
            CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_MINE) or
            CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_MY_PET)) then
            if (C.Interrupts.SpellLink) then
                local extraSpellLink = GetSpellLink(extraSpellID)
                SendChatMessage(STRING_INTERRUPT:format(StringPossesion(destName or "?"), extraSpellLink or "Error"), chatType)
            else
                SendChatMessage(STRING_INTERRUPT:format(StringPossesion(destName or "?"), extraSpellName), chatType)
            end
        end
    end
end
