local T, C, L = Tukui:unpack()

----------------------------------------------------------------
-- Interrupt Announce bt Elv22
----------------------------------------------------------------
if (not C.Interrupts.Enable) then return end

local chatType = "SAY"
local CHANNELS = {
    ["SAY"] = true,
    ["PARTY"] = true,
    ["RAID"] = true,
    ["RAID_WARNNING"] = false,
    ["INSTANCE_CHAT"] = true
}

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event, ...)
    -- call one of the functions above
    self[event](self, ...)
end)

function f:PLAYER_LOGIN()
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function f:PLAYER_ENTERING_WORLD()
    inInstance, instanceType = IsInInstance()
    if (inInstance and (instanceType == "raid" or instanceType == "party")) then
        if (IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
            chatType = "INSTANCE_CHAT"
        elseif (IsInRaid()) then
            chatType = "RAID"
        elseif (IsInGroup()) then
            chatType = "PARTY"
        end
    else
        chatType = "SAY"
    end
end

function f:COMBAT_LOG_EVENT_UNFILTERED()
    local timestamp, eventType, hideCaster, sourceGUID, sourceName,
    sourceFlags, sourceRaidFlags, destGUID, destName, destFlags,
    destRaidFlags = CombatLogGetCurrentEventInfo()

    -- check if event is interrupt
    if ((eventType == "SPELL_INTERRUPT") and (sourceGUID == UnitGUID("player"))) then
        local spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())
        local extraSpellID, extraSpellName, extraSchool = select(15, CombatLogGetCurrentEventInfo())

        -- check if channel is enable for announcing
        if (not CHANNELS[chatType]) then
            chatType = "SAY"
        end

        if (C.Interrupts.SpellLink) then
            local extraSpellLink = GetSpellLink(extraSpellID)
            SendChatMessage("Interrupted " .. destName .. " " .. extraSpellLink .. "!", chatType)
        else
            SendChatMessage("Interrupted " .. destName .. " " .. extraSpellName .. "!", chatType)
        end
    end
end